
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_garden_app/models/Sensors.dart';
import 'package:smart_garden_app/widgets/charts.dart';

import '../../service/ConnectMQTT.dart';
import '../../models/DataPoint.dart';


class SensorScreen extends StatefulWidget {

  const SensorScreen({Key? key}) : super(key: key);
  @override
  State<SensorScreen> createState() => _SensorScreenState();
}
// Định nghĩa enum
enum ChartType {
  humidity,
  temperature,
  soilMoisture
}
class _SensorScreenState extends State<SensorScreen> {
  final MQTTClientWrapper mqttClient = MQTTClientWrapper();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<String> topics = ["Humi", "Smoisture", "Temp"];
  final String sensorId = "DBStaac6RvBSnDqzBTpl";
  bool connectMqtt = false;
   String temperature = "30";
   String humidity = "60";
   String soilMoisture = "80";
   double convertMoisture = 80 ;
   DataPoint humiDataPoint = new DataPoint(x: DateTime.now(), y: Random().nextInt(50) + 20);
   DataPoint tempDataPoint = new DataPoint(x: DateTime.now(), y: Random().nextInt(50) + 10 );
  ChartType currentChart = ChartType.temperature;
  @override
  void initState() {
    super.initState();
    connectMQTT();
    mqttClient.setMessageCallback((messageData) {
      if (messageData.message != null) {
        String topic = messageData.topic;
        String payload = messageData.message;
        print("GET DATA SENSOR " + payload);
        setState(() {
          switch (topic) {
            case "Humi":
              humidity = payload;
              humiDataPoint = DataPoint(
                x: DateTime.now(),
                y: int.parse(payload),
              );
              // Lấy thời gian hiện tại
              updateFirestore('humidity', payload.toString());
              break;
            case "Smoisture":
              soilMoisture = payload;
              moistureValue(soilMoisture);
              updateFirestore('soilMoisture', payload);
              break;
            case "Temp":
              temperature = payload;
              tempDataPoint = DataPoint(
                x: DateTime.now(),
                y: int.parse(payload),
              );
              updateFirestore('temperature', payload);
              break;
            default:
            // Handle other topics if needed
              break;
          }
        });
      }
    });
  }
  void moistureValue(String Moisture) {
    double convert = (1 - double.parse(Moisture)/1023)   * 100;
    setState(() {
      convertMoisture = convert ;
    });
  }
  void updateFirestore(String field, String value) async {
    await _firestore.collection('sensors').doc(sensorId).update({field: value});
  }

  void connectMQTT() {
    // Connect MQTT only if not connected
    if (!mqttClient.isConnected()) {
      mqttClient.prepareMqttClient(topics);
      setState(() {
        connectMqtt = true;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    connectMQTT();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            title: Text("Sensor Data"),
            backgroundColor: Colors.teal[700],
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
                        strokeAlign: BorderSide.strokeAlignOutside,
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
                              "${temperature}°C",
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
                                  "H: ${humidity} %",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(width: 20,),
                                Text(
                                  "S: ${convertMoisture.round()} %",
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
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          currentChart = ChartType.temperature;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        decoration: BoxDecoration(
                          color: currentChart == ChartType.temperature ? Colors.green : Colors.grey.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          'Temperature',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    InkWell(
                      onTap: () {
                        setState(() {
                          currentChart = ChartType.humidity;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        decoration: BoxDecoration(
                          color: currentChart == ChartType.humidity ? Colors.green : Colors.grey.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          'Humidity',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    InkWell(
                      onTap: () {
                        setState(() {
                          currentChart = ChartType.soilMoisture;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        decoration: BoxDecoration(
                          color: currentChart == ChartType.soilMoisture ? Colors.green : Colors.grey.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          'Soil Moisture',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: currentChart == ChartType.temperature
                    ? Temp(tempDataPoint)
                    : currentChart == ChartType.humidity
                    ? Humi(humiDataPoint)
                    : Soil(convertMoisture),
              )
            ],
          )
      ),
    );
  }
}

