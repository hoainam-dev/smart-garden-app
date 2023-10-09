import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../ConnectMQTT.dart';
import '../models/Device.dart';

class DeviceScreen extends StatefulWidget {
  @override
  _DeviceScreenState createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  final MQTTClientWrapper mqttClient = MQTTClientWrapper();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _topicController = TextEditingController();
  bool  isOn = false;
  bool isModel = false;
  bool isAuto = false;
  List<Device> devices = [];
  Map<String, bool> switchValues = {};
  List<String> topics = [];
  @override
  void initState() {
    super.initState();
    _fetchDevices();
    connectMQTT();
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
    QuerySnapshot querySnapshot =
    await _firestore.collection('devices').get();
    List<Device> fetchedDevices = [];
    Map<String, bool> fetchedSwitchValues = {}; // Sử dụng Map để lưu trạng thái Switch
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
    mqttClient.disconnect();
  }
  @override
  Widget build(BuildContext context) {
    print(devices.length);
    return Scaffold(
      appBar: AppBar(
        title: Text('Device List'),
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
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Số cột trong GridView
              ),
              itemCount: devices.length,
              itemBuilder: (context, index) {
                bool isOn = devices[index].status == 'ON';
                return Card(
                  color: isOn ? Colors.green : Colors.black12,
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(devices[index].name),
                        subtitle: Text('Topic: ${devices[index].topic}'),
                      ),
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
                          SizedBox(width: 8), // Khoảng cách giữa biểu tượng và trạng thái
                          Text(
                            devices[index].status,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );

              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 70),
            child: isModel ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: Text('Auto'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(100, 40),
                    primary: isAuto? Colors.green:Colors.black26,
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
                    primary: isAuto? Colors.black26 :Colors.green,
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
            ): Container(),
          ),
        ],
      ),

        floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Add New Device'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                    ),
                    TextField(
                      controller: _topicController,
                      decoration: InputDecoration(labelText: 'Topic'),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      _addDevice();
                      Navigator.of(context).pop();
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}