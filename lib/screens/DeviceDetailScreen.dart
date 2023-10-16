import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_garden_app/models/Device.dart';

class DeviceDetailScreen extends StatelessWidget {
  final String deviceId;

  Device? _device;

  DeviceDetailScreen({required this.deviceId});

  final Gradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromARGB(255, 71, 205, 113),
      Color.fromARGB(255, 247, 158, 4)
    ],
  );

  @override
  Widget build(BuildContext context) {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('devices');

    return StreamBuilder<DocumentSnapshot>(
      stream: collectionReference.doc(deviceId).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Đã xảy ra lỗi khi tải chi tiết thiết bị.'),
          );
        }

        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        var deviceData = snapshot.data!.data() as Map<String, dynamic>;

        var turnOn = deviceData['turn_on'] as Timestamp;
        var turnOff = deviceData['turn_off'] as Timestamp;

        var turnOnTime = turnOn.toDate();
        var turnOffTime = turnOff.toDate();

        return Scaffold(
          appBar: AppBar(
            title: Text('Detail Device'),
            backgroundColor: Colors.green,
            centerTitle: true,
          ),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg.png'),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 100, bottom: 110),
                      child: Text(
                        "Name Device: " + deviceData['name'],
                        style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                ),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.all(15),
                      height: 100,
                      width: 165,
                      decoration: BoxDecoration(gradient: backgroundGradient),
                      child: Center(
                        child: Text(
                          "Status: " + deviceData['status'],
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 85, 36, 0)),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(15),
                      height: 100,
                      width: 165,
                      decoration: BoxDecoration(gradient: backgroundGradient),
                      child: Center(
                        child: Text(
                          "Topic: " + deviceData['topic'],
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 85, 36, 0)),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.all(15),
                      padding: EdgeInsets.all(20),
                      height: 200,
                      width: 165,
                      decoration: BoxDecoration(gradient: backgroundGradient),
                      child: Center(
                        child: Text(
                          "Turn On Time: $turnOnTime",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 85, 36, 0)),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.all(15),
                      height: 200,
                      width: 165,
                      decoration: BoxDecoration(gradient: backgroundGradient),
                      child: Center(
                        child: Text(
                          "Turn Off Time: $turnOffTime",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 85, 36, 0)),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
