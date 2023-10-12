// Define the message callback type
import 'dart:io';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import 'EmitCallback.dart';

typedef MessageCallback = void Function(MessageData messageData);

class MQTTClientWrapper {
  late MqttServerClient client;
  late Stream<String> stream;
  MessageCallback? messageCallback;
  void setMessageCallback(MessageCallback callback) {
    messageCallback = callback;
  }
  MQTTClientWrapper() {
    _setupMqttClient();
  }

  bool isConnected() {
    return client.connectionStatus?.state == MqttConnectionState.connected;
  }


  // Add a getter method to access the stream
  Stream<String> get mqttStream => stream;

  void _emitMessage(String topic, String message) {
    if (messageCallback != null) {
      final messageData = MessageData( message:message, topic:topic);
      messageCallback!(messageData);
    }
  }
  void _setupMqttClient() {
    try {
      client = MqttServerClient.withPort(
        'a621abb6c461490c9be826281c8cc5cc.s2.eu.hivemq.cloud',
        'client_id',
        8883,
      );

      client.secure = true;
      client.securityContext = SecurityContext.defaultContext;
      client.keepAlivePeriod = 20;
      client.onDisconnected = _onDisconnected;
      client.onConnected = _onConnected;
      client.onSubscribed = _onSubscribed;
    } catch (e) {
      print('Error setting up MQTT client: $e');
    }
  }

  Future<void> _connectClient(List<String> topics) async {
    try {
      print('Client connecting...');
      await client.connect('slashx', '@huynhhoainam071102');
    } on Exception catch (e) {
      print('Client exception - $e');
      client.disconnect();
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('Client connected');

      // Subscribe to all topics in the list
      subscribeToTopics(topics);
    } else {
      print(
          'Connection failed - disconnecting, status is ${client.connectionStatus}');
      client.disconnect();
    }
  }

  void subscribeToTopics(List<String> topics) {
    for(String topic in topics) {
      print('Subscribing to topics: $topics');
      client.subscribe(topic, MqttQos.atMostOnce);
    }
    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      for (final MqttReceivedMessage<MqttMessage> message in c) {
        final MqttMessage recMess = message.payload;
        if (recMess is MqttPublishMessage) {
          var topicName = message.topic;
          var msg = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
          print('BẠN ĐÃ NHẬN ĐƯỢC THÔNG ĐIỆP MỚI:');
          print(msg);
          print(topicName);
          // Cập nhật dữ liệu khi có thông điệp mới
          _emitMessage(topicName, msg);
        }
      }
    });
  }
  void publishMessage(String message, String topic) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);

    print('Publishing message "$message" to topic "$topic');
    client.publishMessage(
      topic,
      MqttQos.exactlyOnce,
      builder.payload!,
    );
  }

  void _onSubscribed(String topic) {
    print('Subscription confirmed for topic $topic');
  }

  void _onDisconnected() {
    print('OnDisconnected client callback - Client disconnection');
  }

  void _onConnected() {
    print('OnConnected client callback - Client connection was successful');
  }

  Future<void> prepareMqttClient(List<String> topics) async {
    _setupMqttClient();
    await _connectClient(topics);
  }
  // Disconnect from MQTT and clean up subscriptions
  void disconnect() {
    client.disconnect();
    // subscribedTopics.clear();
  }
}