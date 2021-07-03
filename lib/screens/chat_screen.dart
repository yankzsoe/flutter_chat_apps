import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../widgets/chat/new_message.dart';
import '../widgets/chat/messages.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late FirebaseMessaging messaging;

  Future<void> _messageHandler(RemoteMessage message) async {
    print({
      'title': message.notification!.title,
      'body': message.notification!.body,
    });
  }

  @override
  void initState() {
    super.initState();
    messaging = FirebaseMessaging.instance;
    var initSettingAndroid =
        AndroidInitializationSettings('productplaceholder');
    var initSettingIOs = IOSInitializationSettings();
    var initSettings = InitializationSettings(
      android: initSettingAndroid,
      iOS: initSettingIOs,
    );

    _flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: onSelectNotifications);

    final fbm = FirebaseMessaging.instance;
    fbm.requestPermission();
    fbm.getInitialMessage();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        print('A new Message');
        print(message.notification!.body);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print(message);
    });

    FirebaseMessaging.onBackgroundMessage(
        (message) => _messageHandler(message));

    messaging.subscribeToTopic('new_message');
  }

  Future<dynamic> onSelectNotifications(String? payload) async {
    print('Payload: $payload');
  }

  Future<void> showNotificationMediaStyle() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'media channel id',
      'media channel name',
      'media channel description',
      color: Colors.red,
      enableLights: true,
      largeIcon: DrawableResourceAndroidBitmap("productplaceholder"),
      styleInformation: MediaStyleInformation(),
    );
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.show(Random().nextInt(100),
        'notification title', 'notification body', platformChannelSpecifics);
  }

  Future<void> showNotification() async {
    var android = new AndroidNotificationDetails(
        'id', 'channel ', 'description',
        priority: Priority.high, importance: Importance.max);
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iOS);
    await _flutterLocalNotificationsPlugin.show(Random().nextInt(100),
        'Flutter devs', 'Flutter Local Notification Demo', platform,
        payload: 'Welcome to the Local Notification demo ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Apps'),
        actions: [
          DropdownButton(
            underline: Container(),
            dropdownColor: Theme.of(context).accentColor,
            items: [
              DropdownMenuItem<String>(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.exit_to_app),
                      SizedBox(width: 8),
                      Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                value: 'logout',
              ),
            ],
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            onChanged: (value) {
              if (value == 'logout') FirebaseAuth.instance.signOut();
            },
          ),
          ElevatedButton(
              onPressed: showNotificationMediaStyle, child: Text('show notif')),
        ],
      ),
      body: Container(
        child: Column(children: [
          Expanded(
            child: Messages(),
          ),
          NewMessage(),
        ]),
      ),
    );
  }
}
