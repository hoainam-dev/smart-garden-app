
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/Sensors.dart';
import '../widgets/charts.dart';

class SensorController {

  Future<List<SensorData>> fetchSensorsFromFirebase() async {
    List<SensorData> sensorDataList = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('sensors').get();
      querySnapshot.docs.forEach((doc) {
        String id = doc.id;
        // Đọc dữ liệu từ Firebase và tạo đối tượng SensorData
        SensorData sensor = SensorData(
          id: id,
          temperature: doc['temperature'], // Đảm bảo đọc kiểu số thực
          humidity: doc['humidity'], // Đảm bảo đọc kiểu số thực
          soilMoisture: doc['soilMoisture'], // Đảm bảo đọc kiểu số thực
        );
        sensorDataList.add(sensor);

      });
    } catch (e) {
      print("Error fetching sensor data: $e");
    }

    return sensorDataList;
  }

}
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
  final SensorController controller = SensorController();
  List<SensorData> sensorDataList = [];

  ChartType currentChart = ChartType.temperature;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text("Sensor Data"),
            backgroundColor: Colors.green,
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
                              "30°C",
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
                                  "H: 76 %",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(width: 20,),
                                Text(
                                  "S:80%",
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
                    ? Temp()
                    : currentChart == ChartType.humidity
                    ? Humi()
                    : Soil(),
              )
            ],
          )
      ),
    );
  }
}

