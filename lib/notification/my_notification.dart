import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/view/screens/order/order_details_screen.dart';
import 'package:flutter_restaurant/view/screens/rare_review/review_screen.dart';
import 'package:geocoding/geocoding.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class MyNotification {

  static Future<void> initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize = new AndroidInitializationSettings('notification_icon');
    var iOSInitialize = new IOSInitializationSettings();
    var initializationsSettings = new InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin.initialize(initializationsSettings, onSelectNotification: (String payload) async {
      try{
        if(payload != null && payload.isNotEmpty) {
          MyApp.navigatorKey.currentState.push(
              MaterialPageRoute(builder: (context) => OrderDetailsScreen(orderModel: null, orderId: int.parse(payload))));
        }
        // else if(payload != null && payload.isNotEmpty && payload.startsWith('P')){
        //   MyApp.navigatorKey.currentState.push(
        //       MaterialPageRoute(builder: (context) => ProductReviewScreen(productID: int.parse(payload.substring(1)))));
        // }
      }catch (e) {
        
      }
      
      return;
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage: ${message.data}");
      MyNotification.showNotification(message.data, flutterLocalNotificationsPlugin);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onMessageApp: ${message.data}");
    });
  }

  static Future<void> showNotification(Map<String, dynamic> message, FlutterLocalNotificationsPlugin fln) async {
    if(message['image'] != null && message['image'].isNotEmpty) {
      try{
        await showBigPictureNotificationHiddenLargeIcon(message, fln);
      }catch(e) {
        await showBigTextNotification(message, fln);
      }
    }else {
      await showBigTextNotification(message, fln);
    }
  }

  static Future<void> showTextNotification(Map<String, dynamic> message, FlutterLocalNotificationsPlugin fln) async {
    String _title = message['title'];
    String _body = message['body'];
    String _orderID = message['order_id'];
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description', sound: RawResourceAndroidNotificationSound('notification'),
      importance: Importance.max, priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, _title, _body, platformChannelSpecifics, payload: "$_orderID");
  }

  static Future<void> showBigTextNotification(Map<String, dynamic> message, FlutterLocalNotificationsPlugin fln) async {
    String _title = message['title'];
    String _body = message['body'];
    String _orderID = message['order_id'];
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      _body, htmlFormatBigText: true,
      contentTitle: _title, htmlFormatContentTitle: true,
    );
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'big text channel id', 'big text channel name', 'big text channel description', importance: Importance.max,
      styleInformation: bigTextStyleInformation, priority: Priority.high, sound: RawResourceAndroidNotificationSound('notification'),
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, _title, _body, platformChannelSpecifics, payload: "$_orderID");
  }

  static Future<void> showBigPictureNotificationHiddenLargeIcon(Map<String, dynamic> message, FlutterLocalNotificationsPlugin fln) async {
    String _title = message['title'];
    String _body = message['body'];
    String _orderID = message['order_id'];
    String _image = message['image'].startsWith('http') ? message['image']
        : '${AppConstants.BASE_URL}/storage/app/public/notification/${message['image']}';
    final String largeIconPath = await _downloadAndSaveFile(_image, 'largeIcon');
    final String bigPicturePath = await _downloadAndSaveFile(_image, 'bigPicture');
    final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath), hideExpandedLargeIcon: true,
      contentTitle: _title, htmlFormatContentTitle: true,
      summaryText: _body, htmlFormatSummaryText: true,
    );
    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'big text channel id', 'big text channel name', 'big text channel description',
      largeIcon: FilePathAndroidBitmap(largeIconPath), priority: Priority.high, sound: RawResourceAndroidNotificationSound('notification'),
      styleInformation: bigPictureStyleInformation, importance: Importance.max,
    );
    final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, _title, _body, platformChannelSpecifics, payload: "${_orderID}");
  }

  static Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final Response response = await Dio().get(url, options: Options(responseType: ResponseType.bytes));
    final File file = File(filePath);
    await file.writeAsBytes(response.data);
    return filePath;
  }

  static Future<void> scheduleNotification(
  FlutterLocalNotificationsPlugin fln,
        String id,
        String title,
        String body, String productID) async {
    print("Scheduling Notification");
    var androidSpecifics = AndroidNotificationDetails(
      id,
      'Rate Ingredients',
      'We appreciate your feedback',
    );
    var iOSSpecifics = IOSNotificationDetails();

    final String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.initializeTimeZones();
    // Map payload={
    //   "order": orderID,
    //   "address": addressID,
    // };
    var location=tz.getLocation('Asia/Kolkata');
    var time = tz.TZDateTime.now(location).add(const Duration(minutes: 1));
    var platformChannelSpecifics = NotificationDetails(
        android: androidSpecifics,iOS:  iOSSpecifics);
    await fln.zonedSchedule(0, "Rating", "We'd appreciate your feedback",
        time, platformChannelSpecifics,androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: "$productID",
    );
  }

}

Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  print('background: ${message.data}');
  var androidInitialize = new AndroidInitializationSettings('notification_icon');
  var iOSInitialize = new IOSInitializationSettings();
  var initializationsSettings = new InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.initialize(initializationsSettings);
  MyNotification.showNotification(message.data, flutterLocalNotificationsPlugin);
}