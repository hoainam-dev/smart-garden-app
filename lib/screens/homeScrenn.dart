
import 'package:flutter/material.dart';

import '../ConnectMQTT.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final MQTTClientWrapper mqttClient = MQTTClientWrapper();
  int Smoisture = 0;
  double SmoistureValue = 0 ;
  bool isAutoMode = true; // Default mode is Auto
  bool isLightOn = false;
  bool isPumpOn = false;

  void toggleMode(bool value) {
    if (mqttClient != null) {
      setState(() {
        isAutoMode = value;
        if (isAutoMode) {
          mqttClient.publishMessage('Auto', 'MODEPUMP');
        } else {
          mqttClient.publishMessage('Manual', 'MODEPUMP');
        }
      });
    }
  }

  void _connectMQTT() {
    if (!mqttClient.isConnected()) {
      mqttClient.prepareMqttClient(['LED','PUMP','MODEPUMP','Smoisture']);
    }
  }


  @override
  void initState() {
    super.initState();
    _connectMQTT();

    mqttClient.setMessageCallback((messageData) {
      final topic = messageData.topic;
      final message = messageData.message;
      if (topic == 'LED') {
        setState(() {
          isLightOn = message == 'ON';
        });
      } else if (topic == 'PUMP') {
        setState(() {
          isPumpOn = message == 'ON';
        });
      } else if(topic == 'Smoisture') {
        setState(() {
          Smoisture = int.parse(message);
          SmoistureValue =((1024 - Smoisture) / 1024) *100 ;
        });
      }
    });


  }

  @override
  void dispose() {
    mqttClient.disconnect();
    super.dispose();
  }

  void toggleLight(bool value) {
    if (mqttClient.isConnected() && !isAutoMode) {
      setState(() {
        isLightOn = !isLightOn;
        mqttClient.publishMessage(isLightOn ? 'ON' : 'OFF', 'LED');
      });
    }
  }

  void togglePump(bool value) {
    if (mqttClient.isConnected() && !isAutoMode) {
      setState(() {
        isPumpOn = !isPumpOn;
        mqttClient.publishMessage(isPumpOn ? 'ON' : 'OFF', 'PUMP');
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Garden App'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/3467446.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Soil Moisture',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.green[800]!,
                          Colors.green[400]!,
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Text(
                            '${(SmoistureValue).toStringAsFixed(1)}%',
                            style:
                            const TextStyle(fontSize: 32, color: Colors.white),
                          ),
                        ),
                        Positioned.fill(
                          child: CircularProgressIndicator(
                            value: SmoistureValue / 100 ,
                            strokeWidth: 16,
                            valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:
                      isLightOn ? Colors.yellow[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.lightbulb_outline, size: 64),
                        const SizedBox(height: 16),
                        Text(
                          'Light ${isLightOn ? 'ON' : 'OFF'}',
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 8),
                        Switch(
                          value: isLightOn,
                          onChanged: (value) =>     toggleLight(value),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:
                      isPumpOn ? Colors.blue[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.water_outlined, size: 64),
                        const SizedBox(height: 16),
                        Text(
                          'Pump ${isPumpOn ? 'ON' : 'OFF'}',
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 8),
                        Switch(
                          value: isPumpOn,
                          onChanged: (value) => togglePump(value),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:
              isAutoMode ? Colors.green[100] : Colors.yellow[100],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: () => setState(() {
                    isAutoMode = true;
                    toggleMode(isAutoMode);
                  }),
                  icon:
                  Icon(Icons.auto_awesome_outlined,
                      color:
                      isAutoMode ? Colors.white : Colors.black),
                  label:
                  Text('Auto',
                      style:
                      TextStyle(color:
                      isAutoMode ? Colors.white : Colors.black)),
                ),
                TextButton.icon(
                  onPressed: () => setState(() {
                    isAutoMode = false;
                    toggleMode(isAutoMode);
                  }),
                  icon:
                  Icon(Icons.settings_outlined,
                      color:
                      !isAutoMode ? Colors.white : Colors.black),
                  label:
                  Text('Manual',
                      style:
                      TextStyle(color:
                      !isAutoMode ? Colors.white : Colors.black)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
