import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_garden_app/screens/DeleteConfirmationDialog.dart';
import 'package:smart_garden_app/screens/DeviceDetailScreen.dart';

import '../ConnectMQTT.dart';
import '../models/Device.dart';

class DeviceScreen extends StatefulWidget {
  @override
  _DeviceScreenState createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  final Gradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromARGB(255, 71, 205, 113),
      Color.fromARGB(255, 247, 158, 4)
    ],
  );
  final MQTTClientWrapper mqttClient = MQTTClientWrapper();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _topicController = TextEditingController();
  bool isOn = false;
  bool isModel = false;
  bool isAuto = false;
  List<Device> devices = [];
  Map<String, bool> switchValues = {};
  List<String> topics = [];
  bool _isLoading = false;
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference().child('devices');

  @override
  void initState() {
    super.initState();
    _fetchDevices();
    connectMQTT();
    devices = [];
    mqttClient.setMessageCallback((messageData) {
      Device device = devices.firstWhere((d) => d.topic == messageData.topic);

      if (device != null) {
        setState(() {
          device.status = messageData.message;
          isOn = messageData.message == 'ON';
        });
      }
    });
  }

  void connectMQTT() {
    if (!mqttClient.isConnected()) {
      mqttClient.prepareMqttClient(topics);
    }
  }

  void _fetchDevices() async {
    QuerySnapshot querySnapshot = await _firestore.collection('devices').get();
    List<Device> fetchedDevices = [];
    Map<String, bool> fetchedSwitchValues =
        {}; // Sử dụng Map để lưu trạng thái Switch
    querySnapshot.docs.forEach((doc) {
      isOn = doc['status'] == 'ON';
      fetchedSwitchValues[doc.id] = isOn; // Lưu trạng thái vào Map
      fetchedDevices.add(Device(
        id: doc.id, // Sử dụng doc.id làm trường id
        name: doc['name'],
        status: doc['status'],
        topic: doc['topic'],
        turnOnTime: doc['turn_on'].toDate(),
        turnOffTime: doc['turn_off'].toDate(),
      ));
    });
    setState(() {
      devices = fetchedDevices;
      topics.addAll(devices.map((d) => d.topic));
      switchValues = fetchedSwitchValues;
    });
  }

  void _addDevice() async {
    String name = _nameController.text;
    String topic = _topicController.text;
    await _firestore.collection('devices').add({
      'name': name,
      'status': 'OFF', // Mặc định là Off
      'topic': topic,
      'turn_on': DateTime.now(),
      'turn_off': DateTime.now()
    });
    _nameController.clear();
    _topicController.clear();
    _fetchDevices();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have successfully created ')));
  }

  void _deleteDevice(String? id) {
    setState(() {
      _firestore.collection('devices').doc(id).delete();
      _fetchDevices();
    });

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have successfully deleted ')));
  }

  void validatorCreateDevice() async {
    if (_nameController.text.isEmpty || _topicController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter all required fields.'),
      ));
    } else {
      String name = _nameController.text;
      String topic = _topicController.text;
      await _firestore.collection('devices').add({
        'name': name,
        'status': 'OFF', // Mặc định là Off
        'topic': topic,
        'turn_on': DateTime.now(),
        'turn_off': DateTime.now()
      });
      _nameController.clear();
      _topicController.clear();
      _fetchDevices();
    }
  }

  void _toggleDeviceStatus(String deviceId) async {
    // Lấy thiết bị cần update
    Device device = devices.firstWhere((d) => d.id == deviceId);

    bool newStatus = !switchValues[deviceId]!; // Đảo trạng thái
    Map<String, dynamic> updateData = {
      'status': newStatus ? 'ON' : 'OFF',
    };
    if (newStatus == 'ON') {
      updateData['turn_on'] = DateTime.now();
    } else {
      updateData['turn_off'] = DateTime.now();
    }

    await _firestore.collection('devices').doc(deviceId).update(updateData);
    setState(() {
      switchValues[deviceId] = newStatus; // Cập nhật trạng thái trong Map
    });
    // Publish lên MQTT
    mqttClient.publishMessage(newStatus ? 'ON' : 'OFF', device.topic);
  }

  @override
  void dispose() {
    super.dispose();
    mqttClient.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    print(devices.length);
    return Scaffold(
      appBar: AppBar(
        title: Text('Device List'),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              setState(() {
                isModel = !isModel;
              });
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _databaseReference.onValue,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!.snapshot.value;
            if (data != null) {
              final devices = [];
              data.forEach((key, value) => devices.add(Device(
                  id: key,
                  name: value['name'],
                  status: value['status'],
                  topic: value['topic'],
                  turnOnTime: value['turnOnTime'],
                  turnOffTime: value['turnOffTime'])));
            }
          }
          return Container(
            child: Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Số cột trong GridView
                    ),
                    itemCount: devices.length,
                    itemBuilder: (context, index) {
                      // final deviceData =
                      //     deviceDocs[index].data() as Map<String, dynamic>;

                      bool isOn = devices[index].status == 'ON';

                      return Card(
                        color: isOn
                            ? Colors.green
                            : Color.fromARGB(31, 27, 244, 99),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 90,
                                    margin: EdgeInsets.only(left: 50),
                                    child: Center(
                                      child: Text(
                                        devices[index].name,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        print("id la: " + devices[index].id);
                                        print("turnOnTime:" +
                                            devices[index].name);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DeviceDetailScreen(
                                                    deviceId:
                                                        devices[index].id),
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.report_gmailerrorred,
                                        size: 26,
                                        color: Colors.white,
                                      )),
                                ],
                              ),
                            ),
                            Text(
                              'Topic: ${devices[index].topic}',
                              style: TextStyle(color: Colors.white),
                            ),
                            // ListTile(
                            //   title: Text(devices[index].name),
                            //   subtitle: Text('Topic: ${devices[index].topic}'),
                            // ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Switch(
                                  value: isOn,
                                  onChanged: (newValue) {
                                    _toggleDeviceStatus(devices[index].id);
                                  },
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  devices[index].status == 'ON'
                                      ? Icons.power
                                      : Icons.power_off,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                    width:
                                        8), // Khoảng cách giữa biểu tượng và trạng thái
                                Text(
                                  devices[index].status,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                    onPressed: () async {
                                      // _deleteDevice(devices[index].id);
                                      final result = await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return DeleteConfirmationDialog(
                                                deviceId: devices[index].id,
                                                onDelete: _deleteDevice);
                                          });
                                    },
                                    icon: Icon(
                                      Icons.delete_outline,
                                      size: 27,
                                      color: Colors.white,
                                    ))
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 70),
                  child: isModel
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              child: Text('Auto'),
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(100, 40),
                                primary: isAuto ? Colors.green : Colors.black26,
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontStyle: FontStyle.normal),
                              ),
                              onPressed: () {
                                mqttClient.publishMessage('Auto', 'MODEPUMP');
                                setState(() {
                                  isAuto = true;
                                });
                              },
                            ),
                            SizedBox(width: 16), // Khoảng cách giữa hai nút
                            ElevatedButton(
                              child: Text('Manual'),
                              style: ElevatedButton.styleFrom(
                                elevation: 1,
                                minimumSize: Size(50, 40),
                                primary: isAuto ? Colors.black26 : Colors.green,
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontStyle: FontStyle.normal),
                              ),
                              onPressed: () {
                                mqttClient.publishMessage('Manual', 'MODEPUMP');
                                setState(() {
                                  isAuto = false;
                                });
                              },
                            ),
                          ],
                        )
                      : Container(),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Color.fromARGB(255, 238, 255, 241),
                  title: Center(
                    child: Text(
                      'ADD DEVICE',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        autofocus: false,
                        decoration: InputDecoration(
                            labelText: 'Enter device name',
                            labelStyle: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400),
                            border: OutlineInputBorder(),
                            errorStyle:
                                TextStyle(color: Colors.black26, fontSize: 15)),
                        controller: _nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter device name !';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        autofocus: false,
                        decoration: InputDecoration(
                            labelText: 'Enter topic name',
                            labelStyle: TextStyle(fontSize: 18),
                            border: OutlineInputBorder(),
                            errorStyle:
                                TextStyle(color: Colors.black26, fontSize: 15)),
                        controller: _topicController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter topic name !';
                          }
                          return null;
                        },
                      )
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'CANCEL',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          validatorCreateDevice();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'ADD',
                          style: TextStyle(color: Colors.black),
                        ))
                  ],
                );
              });
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
