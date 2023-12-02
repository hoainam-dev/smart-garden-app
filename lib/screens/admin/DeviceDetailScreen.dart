import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/Device.dart';

class DeviceDetailScreen extends StatelessWidget {
  final String deviceId;

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
          String _getRunningTime() {

            var duration = turnOffTime.difference(turnOnTime);

            // Chuyển từ Duration sang DateTime
            var dateTime = DateTime(1970);
            dateTime = dateTime.add(duration);

            return DateFormat('mm').format(dateTime);
          }
          return Scaffold(
            appBar: AppBar(
              title: Text('Device Details'),
              backgroundColor: Colors.teal[700],
            ),
            body: ListView(
              padding: EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        ListTile(
                          leading: Icon(
                            deviceData['status'] == "ON" ? Icons.check_circle : Icons.error,
                            color: Colors.teal[700],
                          ),
                          title: Text(
                            deviceData['name'],
                            style: Theme.of(context).textTheme.headline6!.copyWith(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          trailing: Text(
                            deviceData['status'] == "ON" ? 'Active' : 'Inactive',
                            style: TextStyle(
                                color: deviceData['status'] == "ON" ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),

                        SizedBox(height: 8),

                        Row(

                          children: [
                            Icon(Icons.signal_cellular_alt, color: Colors.grey[700]),
                            SizedBox(width: 8),
                            Text('Topic', style: Theme.of(context).textTheme.subtitle2),
                          ],
                        ),

                        Text(deviceData['topic']),

                        SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.access_time, color: Colors.grey[700]),
                            SizedBox(width: 8),
                            Text('Turned on at', style: Theme.of(context).textTheme.subtitle2),
                          ],
                        ),

                        Text(DateFormat('HH:mm, MMM dd yyyy').format(turnOnTime)),

                        SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.access_time, color: Colors.grey[700]),
                            SizedBox(width: 8),
                            Text('Turned off at', style: Theme.of(context).textTheme.subtitle2),
                          ],
                        ),

                        Text(DateFormat('HH:mm, MMM dd yyyy').format(turnOffTime)),
                        SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Running On ' + _getRunningTime() + ' Minutes',
                              style: TextStyle(color: Colors.green ,  fontSize: 20 , fontWeight: FontWeight.w400),),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Card(
                child: Padding(
                padding: const EdgeInsets.all(16.0),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Trong Widget
                Text('Description', style: Theme.of(context).textTheme.subtitle1),

                Text(
                  descriptions[deviceData['topic']] ?? 'No description',
                  maxLines: 10,
                  overflow: TextOverflow.ellipsis,
                )
                ]
              )
                )
                )
              ],
            ),
          );
        });
  }
}
