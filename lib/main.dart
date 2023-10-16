
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:smart_garden_app/screens/DeviceScreen.dart';
import 'package:smart_garden_app/screens/PlantScreen.dart';
import 'package:smart_garden_app/screens/SensorScreen.dart';
import 'package:smart_garden_app/screens/RegisterFace.dart';
import 'package:smart_garden_app/util/MessageContain.dart';
import 'package:smart_garden_app/util/Nofications.dart';
import 'Home.dart';
import 'package:smart_garden_app/ConnectMQTT.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());

}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (BuildContext context) {
          return const MyHomePage();
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final MQTTClientWrapper mqttClient = MQTTClientWrapper();

  List<String> topics = ["Smoisture", "Temp", "Humi"];


  // function connect to MQTT
  void connectMQTT() {
    if (!mqttClient.isConnected()) {
      mqttClient.prepareMqttClient(topics);
    }
  }

  // function show message dialog
  void Message(String title, String message) async{
    try{
      Notifications.showBogTextNotification(
          title: title,
          body: message,
          fln: flutterLocalNotificationsPlugin);
    }catch(ex){
      print(ex);
    }
  }

  @override
  void initState() {
    super.initState();
    connectMQTT();
    mqttClient.setMessageCallback((messageData) {
      Notifications.initialize(flutterLocalNotificationsPlugin);
      print(messageData.topic);
      print(messageData.message);
      if(messageData.topic.contains("Smoisture")){
        print(messageData.topic);
        if(500<int.parse(messageData.message)){
          Message(MessageContain().TITLE_SMOISTURE_HIGH, "${MessageContain().MESSAGE_SMOISTURE_HIGH} | ${messageData.message}");
        }if(100>int.parse(messageData.message)){
          Message(MessageContain().TITLE_SMOISTURE_LOW, "${MessageContain().MESSAGE_SMOISTURE_LOW} | ${messageData.message}");
        }
      }else if(messageData.topic.contains("Temp")){
        if(32<int.parse(messageData.message)){
          Message(MessageContain().TITLE_TEMPERATURE_HIGH, "${MessageContain().MESSAGE_TEMPERATURE_HIGH} | ${messageData.message}");
        }
        if(16>int.parse(messageData.message)){
          Message(MessageContain().TITLE_TEMPERATURE_LOW, "${MessageContain().MESSAGE_TEMPERATURE_LOW} | ${messageData.message}");
        }
      }else{
        if(70<int.parse(messageData.message)){
          Message(MessageContain().TITLE_HUMIDITY_HIGH, "${MessageContain().MESSAGE_HUMIDITY_HIGH} | ${messageData.message}");
        }if(20>int.parse(messageData.message)){
          Message(MessageContain().TITLE_HUMIDITY_LOW, "${MessageContain().MESSAGE_HUMIDITY_LOW} | ${messageData.message}");
        }
      }
      // Message(messageData.topic, messageData.message);
    });
  }

  int _currentIndex = 0;

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const Home(),
          PlantScreen(),
          const SensorScreen(),
          DeviceScreen(),
          // DeviceScreen(),
          RegisterFace()
        ],
      ),
      bottomNavigationBar: MyAppBar(currentIndex: _currentIndex, onTap: _onTap),
    );
  }
}

class MyAppBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const MyAppBar({Key? key, required this.currentIndex, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      notchMargin: 8.0,
      shape: const CircularNotchedRectangle(),
      color: Colors.lightGreen,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            color: currentIndex == 0 ? Colors.white : Colors.white.withOpacity(0.5),
            onPressed: () => onTap(0),
            icon: Icon(
              Icons.home_outlined,
              size: 30,
            ),
            hoverColor: Colors.white.withOpacity(0.2),
            splashRadius: 20,
            splashColor: Colors.white.withOpacity(0.5),
          ),
          IconButton(
            color: currentIndex == 1 ? Colors.white : Colors.white.withOpacity(0.5),
            onPressed: () => onTap(1),
            icon: Icon(
              CupertinoIcons.tree,
              size: 30,
            ),
            hoverColor: Colors.white.withOpacity(0.2),
            splashRadius: 20,
            splashColor: Colors.white.withOpacity(0.5),
          ),
          IconButton(
            color: currentIndex == 2 ? Colors.white : Colors.white.withOpacity(0.5),
            onPressed: () => onTap(2),
            icon: Icon(
              CupertinoIcons.selection_pin_in_out,
              size: 30,
            ),
            hoverColor: Colors.white.withOpacity(0.2),
            splashRadius: 20,
            splashColor: Colors.white.withOpacity(0.5),
          ),
          IconButton(
            color: currentIndex == 3 ? Colors.white : Colors.white.withOpacity(0.5),
            onPressed: () => onTap(3),
            icon: Icon(
              CupertinoIcons.device_phone_landscape,
              size: 30,
            ),
            hoverColor: Colors.white.withOpacity(0.2),
            splashRadius: 20,
            splashColor: Colors.white.withOpacity(0.5),
          ),
          IconButton(
            color: currentIndex == 4 ? Colors.white : Colors.white.withOpacity(0.5),
            onPressed: () => onTap(4),
            icon: Icon(
              Icons.face,
              size: 30,
            ),
            hoverColor: Colors.white.withOpacity(0.2),
            splashRadius: 20,
            splashColor: Colors.white.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}


// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   final MQTTClientWrapper mqttClient = MQTTClientWrapper();
//   int Smoisture = 0;
//   double SmoistureValue = 0 ;
//   bool isAutoMode = true; // Default mode is Auto
//   bool isLightOn = false;
//   bool isPumpOn = false;
//
//   void toggleMode(bool value) {
//     if (mqttClient != null) {
//       setState(() {
//         isAutoMode = value;
//         if (isAutoMode) {
//           mqttClient.publishMessage('Auto', 'MODEPUMP');
//         } else {
//           mqttClient.publishMessage('Manual', 'MODEPUMP');
//         }
//       });
//     }
//   }
//
//   void _connectMQTT() {
//     if (!mqttClient.isConnected()) {
//       mqttClient.prepareMqttClient(['LED','PUMP','MODEPUMP','Smoisture']);
//     }
//   }
//
//
//   @override
//   void initState() {
//     super.initState();
//     _connectMQTT();
//
//     mqttClient.setMessageCallback((messageData) {
//       final topic = messageData.topic;
//       final message = messageData.message;
//       if (topic == 'LED') {
//         setState(() {
//           isLightOn = message == 'ON';
//         });
//       } else if (topic == 'PUMP') {
//         setState(() {
//           isPumpOn = message == 'ON';
//         });
//       } else if(topic == 'Smoisture') {
//         setState(() {
//           Smoisture = int.parse(message);
//           SmoistureValue =((1024 - Smoisture) / 1024) *100 ;
//         });
//       }
//     });
//
//
//   }
//
//   @override
//   void dispose() {
//     mqttClient.disconnect();
//     super.dispose();
//   }
//
//   void toggleLight(bool value) {
//     if (mqttClient.isConnected() && !isAutoMode) {
//       setState(() {
//         isLightOn = !isLightOn;
//         mqttClient.publishMessage(isLightOn ? 'ON' : 'OFF', 'LED');
//       });
//     }
//   }
//
//   void togglePump(bool value) {
//     if (mqttClient.isConnected() && !isAutoMode) {
//       setState(() {
//         isPumpOn = !isPumpOn;
//         mqttClient.publishMessage(isPumpOn ? 'ON' : 'OFF', 'PUMP');
//       });
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Smart Garden App'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Container(
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage('assets/images/3467446.jpg'),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text(
//                     'Soil Moisture',
//                     style: TextStyle(fontSize: 24, color: Colors.white),
//                   ),
//                   const SizedBox(height: 16),
//                   Container(
//                     width: 200,
//                     height: 200,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       gradient: RadialGradient(
//                         colors: [
//                           Colors.green[800]!,
//                           Colors.green[400]!,
//                         ],
//                       ),
//                     ),
//                     child: Stack(
//                       children: [
//                         Center(
//                           child: Text(
//                             '${(SmoistureValue).toStringAsFixed(1)}%',
//                             style:
//                             const TextStyle(fontSize: 32, color: Colors.white),
//                           ),
//                         ),
//                         Positioned.fill(
//                           child: CircularProgressIndicator(
//                             value: SmoistureValue / 100 ,
//                             strokeWidth: 16,
//                             valueColor:
//                             AlwaysStoppedAnimation<Color>(Colors.white),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Expanded(
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                     margin: const EdgeInsets.all(16),
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color:
//                       isLightOn ? Colors.yellow[100] : Colors.grey[300],
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Icon(Icons.lightbulb_outline, size: 64),
//                         const SizedBox(height: 16),
//                         Text(
//                           'Light ${isLightOn ? 'ON' : 'OFF'}',
//                           style: const TextStyle(fontSize: 20),
//                         ),
//                         const SizedBox(height: 8),
//                         Switch(
//                           value: isLightOn,
//                           onChanged: (value) =>     toggleLight(value),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Container(
//                     margin: const EdgeInsets.all(16),
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color:
//                       isPumpOn ? Colors.blue[100] : Colors.grey[300],
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Icon(Icons.water_outlined, size: 64),
//                         const SizedBox(height: 16),
//                         Text(
//                           'Pump ${isPumpOn ? 'ON' : 'OFF'}',
//                           style: const TextStyle(fontSize: 20),
//                         ),
//                         const SizedBox(height: 8),
//                         Switch(
//                           value: isPumpOn,
//                           onChanged: (value) => togglePump(value),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             margin: const EdgeInsets.all(16),
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color:
//               isAutoMode ? Colors.green[100] : Colors.yellow[100],
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Row(
//               mainAxisAlignment:
//               MainAxisAlignment.spaceEvenly,
//               children: [
//                 TextButton.icon(
//                   onPressed: () => setState(() {
//                     isAutoMode = true;
//                     toggleMode(isAutoMode);
//                   }),
//                   icon:
//                   Icon(Icons.auto_awesome_outlined,
//                       color:
//                       isAutoMode ? Colors.white : Colors.black),
//                   label:
//                   Text('Auto',
//                       style:
//                       TextStyle(color:
//                       isAutoMode ? Colors.white : Colors.black)),
//                 ),
//                 TextButton.icon(
//                   onPressed: () => setState(() {
//                     isAutoMode = false;
//                     toggleMode(isAutoMode);
//                   }),
//                   icon:
//                   Icon(Icons.settings_outlined,
//                       color:
//                       !isAutoMode ? Colors.white : Colors.black),
//                   label:
//                   Text('Manual',
//                       style:
//                       TextStyle(color:
//                       !isAutoMode ? Colors.white : Colors.black)),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: ElevatedButton(
//         onPressed: () {
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (ctx) => AddPlantScreen(),
//             ),
//           );
//         },
//         child: Text('Thêm Cây Cối'),
//       ),
//     );
//   }
// }
