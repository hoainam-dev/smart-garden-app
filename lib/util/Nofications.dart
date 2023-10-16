import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notifications {
  static Future initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize =
    new AndroidInitializationSettings('mipmap/ic_launcher');

    var initializationsSettings =
    new InitializationSettings(android: androidInitialize);

    await flutterLocalNotificationsPlugin.initialize(initializationsSettings);
  }

  static Future showBogTextNotification(
      {var id = 0,
        required String title,
        required String body,
        var payload,
        required FlutterLocalNotificationsPlugin fln}) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
    new AndroidNotificationDetails(
        'you_can_name_it_whatever1', 'channel_name',
        playSound: true,
        // sound: RawResourceAndroidNotificationSound('notification'),
        importance: Importance.max,
        priority: Priority.high);

    var not = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, not);
  }
}