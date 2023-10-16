import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:smart_garden_app/screens/auth/auth_page.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (BuildContext context) {
          return AuthPage();
        },
      ),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   final MQTTClientWrapper mqttClient = MQTTClientWrapper();
//
//   List<String> topics = ["Smoisture", "Temp", "Humi"];
//
//
//   // function connect to MQTT
//   void connectMQTT() {
//     if (!mqttClient.isConnected()) {
//       mqttClient.prepareMqttClient(topics);
//     }
//   }
//
//   // function show message dialog
//   void Message(String title, String message) async{
//     try{
//       Notifications.showBogTextNotification(
//           title: title,
//           body: message,
//           fln: flutterLocalNotificationsPlugin);
//     }catch(ex){
//       print(ex);
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     connectMQTT();
//     mqttClient.setMessageCallback((messageData) {
//       Notifications.initialize(flutterLocalNotificationsPlugin);
//       print(messageData.topic);
//       print(messageData.message);
//       if(messageData.topic.contains("Smoisture")){
//         print(messageData.topic);
//         if(500<int.parse(messageData.message)){
//           Message(MessageContain().TITLE_SMOISTURE_HIGH, "${MessageContain().MESSAGE_SMOISTURE_HIGH} | ${messageData.message}");
//         }if(100>int.parse(messageData.message)){
//           Message(MessageContain().TITLE_SMOISTURE_LOW, "${MessageContain().MESSAGE_SMOISTURE_LOW} | ${messageData.message}");
//         }
//       }else if(messageData.topic.contains("Temp")){
//         if(32<int.parse(messageData.message)){
//           Message(MessageContain().TITLE_TEMPERATURE_HIGH, "${MessageContain().MESSAGE_TEMPERATURE_HIGH} | ${messageData.message}");
//         }
//         if(16>int.parse(messageData.message)){
//           Message(MessageContain().TITLE_TEMPERATURE_LOW, "${MessageContain().MESSAGE_TEMPERATURE_LOW} | ${messageData.message}");
//         }
//       }else{
//         if(70<int.parse(messageData.message)){
//           Message(MessageContain().TITLE_HUMIDITY_HIGH, "${MessageContain().MESSAGE_HUMIDITY_HIGH} | ${messageData.message}");
//         }if(20>int.parse(messageData.message)){
//           Message(MessageContain().TITLE_HUMIDITY_LOW, "${MessageContain().MESSAGE_HUMIDITY_LOW} | ${messageData.message}");
//         }
//       }
//       // Message(messageData.topic, messageData.message);
//     });
//   }
//
//   int _currentIndex = 0;
//
//   void _onTap(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IndexedStack(
//         index: _currentIndex,
//         children: [
//           const Home(),
//           PlantScreen(),
//           const SensorScreen(),
//           DeviceScreen(),
//         ],
//       ),
//       bottomNavigationBar: MyAppBar(currentIndex: _currentIndex, onTap: _onTap),
//     );
//   }
// }
//
// class MyAppBar extends StatelessWidget {
//   final int currentIndex;
//   final void Function(int) onTap;
//
//   const MyAppBar({Key? key, required this.currentIndex, required this.onTap})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return BottomAppBar(
//       notchMargin: 8.0,
//       shape: const CircularNotchedRectangle(),
//       color: Colors.lightGreen,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           IconButton(
//             color: currentIndex == 0
//                 ? Colors.white
//                 : Colors.white.withOpacity(0.5),
//             onPressed: () => onTap(0),
//             icon: Icon(
//               Icons.home_outlined,
//               size: 30,
//             ),
//             hoverColor: Colors.white.withOpacity(0.2),
//             splashRadius: 20,
//             splashColor: Colors.white.withOpacity(0.5),
//           ),
//           IconButton(
//             color: currentIndex == 1
//                 ? Colors.white
//                 : Colors.white.withOpacity(0.5),
//             onPressed: () => onTap(1),
//             icon: Icon(
//               CupertinoIcons.tree,
//               size: 30,
//             ),
//             hoverColor: Colors.white.withOpacity(0.2),
//             splashRadius: 20,
//             splashColor: Colors.white.withOpacity(0.5),
//           ),
//           IconButton(
//             color: currentIndex == 2
//                 ? Colors.white
//                 : Colors.white.withOpacity(0.5),
//             onPressed: () => onTap(2),
//             icon: Icon(
//               CupertinoIcons.selection_pin_in_out,
//               size: 30,
//             ),
//             hoverColor: Colors.white.withOpacity(0.2),
//             splashRadius: 20,
//             splashColor: Colors.white.withOpacity(0.5),
//           ),
//           IconButton(
//             color: currentIndex == 3
//                 ? Colors.white
//                 : Colors.white.withOpacity(0.5),
//             onPressed: () => onTap(3),
//             icon: Icon(
//               CupertinoIcons.device_phone_landscape,
//               size: 30,
//             ),
//             hoverColor: Colors.white.withOpacity(0.2),
//             splashRadius: 20,
//             splashColor: Colors.white.withOpacity(0.5),
//           ),
//         ],
//       ),
//     );
//   }
// }