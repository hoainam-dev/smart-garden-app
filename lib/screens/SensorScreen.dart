
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../ConnectMQTT.dart';
import '../models/Sensors.dart';


class SensorScreen extends StatefulWidget {
  const SensorScreen({Key? key}) : super(key: key);

  @override
  State<SensorScreen> createState() => _SensorScreenState();
}

class _SensorScreenState extends State<SensorScreen> {
  final MQTTClientWrapper mqttClient = MQTTClientWrapper();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> topics = [];
  List<Sensor> sensors = [];
  List<Sensor> temperatureSensors = [];
  List<Sensor> humiditySensors = [];
  List<Sensor> soilMoistureSensors = [];
  int Smoisture = 40 ;
  double SmoistureValue = 0 ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    connectMQTT();
    fetchData();
    mqttClient.setMessageCallback((messageData){
        Sensor sensor = sensors.firstWhere((d) => d.topic == messageData.topic);
        if (sensor != null) {
          setState(() {
            sensor.value = messageData.message ;
            sensor.time = DateTime.now();
          });
          if (messageData.topic.contains('Temp')) {
            temperatureSensors.add(sensor);
          }

          else if (messageData.topic.contains('Humi')) {
            humiditySensors.add(sensor);
          }

          else if (messageData.topic.contains('Smoisture')) {
            soilMoistureSensors.add(sensor);
          }
          updateSensor(sensor);
        }
    });
  }
  void connectMQTT() {
    if (!mqttClient.isConnected()) {
      mqttClient.prepareMqttClient(topics);
      print(topics.length);
    }
  }
  Future<void> fetchData() async {
    QuerySnapshot querySnapshot = await _firestore.collection('sensors').get();
    List<Sensor> fetchedSensor = [];
    querySnapshot.docs.forEach((doc) {
      fetchedSensor.add(Sensor(
          id: doc.id,
          value: doc['value'],
          topic: doc['topic'],
          time: doc['time'].toDate()
      ));
    });
    setState(() {
      sensors = fetchedSensor;
      topics.addAll(sensors.map((d) => d.topic));
    });
  }

  Future updateSensor(Sensor sensor) async {
    await _firestore.collection('sensors')
        .doc(sensor.id)
        .update({
      'value': sensor.value,
      'time': sensor.time
    });
  }

  @override
  Widget build(BuildContext context) {
    Smoisture = int.parse(soilMoistureSensors.last.value);
    print(Smoisture);
    setState(() {
      // Cập nhật giá trị SmoistureValue
      SmoistureValue = 100 - (((4095 - Smoisture) / 4095) * 100);
    });
    return Scaffold(
        appBar: AppBar(
          title: Text('Sensors'),
        ),
        body: Column(
          children: [
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 250,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color: Colors.white.withOpacity(0.5),
                    ),
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                child: Stack(
                  children: [
                    // Hình ảnh nền
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height:  300,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage("https://img.freepik.com/premium-photo/rainy-day-3d-weather-icon-3d-render-illustration_11823-2270.jpg"),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),

                    // Nhiệt độ và độ ẩm
                    Positioned(
                      top: 65, // Điều chỉnh vị trí theo y
                      left: 140, // Điều chỉnh vị trí theo x
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "${temperatureSensors.last.value}°C",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 40,
                                fontWeight: FontWeight.w400
                            ),
                          ),
                          Row(
                            mainAxisAlignment:MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "H: ${humiditySensors.last.value} %",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(width: 20,),
                              Text(
                                "S:${SmoistureValue.toStringAsFixed(1)}%",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
    );

  }
}


