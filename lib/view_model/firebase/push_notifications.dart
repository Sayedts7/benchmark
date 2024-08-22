
import 'dart:convert';
import 'package:benchmark_estimate/view/chat_screen/chat_screen_view.dart';
import 'package:benchmark_estimate/view/create_project/create_project_view.dart';
import 'package:benchmark_estimate/view/project_status/project_submitted.dart';
import 'package:benchmark_estimate/view_model/firebase/push_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class NotificationServices with ChangeNotifier{
   int? route ;
  //FirebaseMessaging messaging = FirebaseMessaging.instance;

  late final FirebaseMessaging _messaging;
  PushNotification? _notificationInfo;
  String? token;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


  void requestAndRegisterNotification(BuildContext context)async{
    //1. Intilize the firebase app
    await Firebase.initializeApp();

    //2.intantiate firebase messaging
    _messaging = FirebaseMessaging.instance;
    FirebaseMessaging.onBackgroundMessage(FirebaseMessagingBackgroundHandler);

    // 3.Take user permission on ios
    NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        provisional: false,
        sound: true
    );

    if(settings.authorizationStatus ==AuthorizationStatus.authorized)
    {
      print("user permission granted");
      token = await _messaging.getToken();
      print("the token is "+token!);
      //for handling the received notification
      FirebaseMessaging.onMessage.listen((RemoteMessage message){
        //parse the message received
        print(message.notification?.title);
        print(message.notification?.body);

        NotificationDetails platformChannelSpecfics = NotificationDetails(iOS: const IOSNotificationDetails());

        flutterLocalNotificationsPlugin.show(0, message.notification!.title,
            message.notification!.body, platformChannelSpecfics,payload: message.data['body']);

        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
        );
        _notificationInfo = notification;
        if(_notificationInfo != null)
        {
          showSimpleNotification(Text(_notificationInfo!.title!),subtitle: Text(_notificationInfo!.body!),
              background: Colors.cyan.shade700,
              duration: Duration(seconds: 10));
        }
      });

      // For handling notification when the app is in background but not terminated
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print(' here in For handling notification when the app is in background but not terminated');
    // TODO: handle the message and navigate if needed
    _handleBackgroundMessage(message,context);
  });


//   // For handling notification when the app is terminated
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    print(' here in        For handling notification when the app is terminated');
    if(message != null){
      _handleTerminatedMessage(message, context);

    }
  });
    }

    initInfo(  );
  }
  Future<void> setupNotificationChannels() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> sendToken(String uid)
  async {
    print(uid);
    print(token);
    await FirebaseFirestore.instance.collection('User').doc(uid).update({
      "token" : token
    });
  }

  void sendPushMessage(String tokenReceiver,String body,String title) async{

    try{
      await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
          headers: <String,String>{
            "Content-Type" : "application/json",
            "Authorization" : " ya29.c.c0ASRK0GYxqed-zxcvb85TibAhtnOwnmkXMHtxRNE6ovGrn9uKMewDDHW-MFieI7I4ONta2rYIIjzmGvvoJpMVT4KsfQGk2u-mbLWjIwJc9JnEYMWFVYigVz19NPVf9HQ1U-Fz7LRdHHFMpePghdFAUU75tL1Yo1k21CRj7zNoyn031F0_nMRt1Tlnwp6_wuGS8Yr2nA2Rv_gzhzX0yyx0BxXz1ng66CTtIIIySsylE0Wu-euGGDkiMckeEEwN2o2ZMbiIT-Ts1cUBBpjTd8bWJLSpsPU5CVs-Yce7H0aV_wc_P1QJA9mf7S_21B6b280xBMVik6vhcQF-gT-XTNvYOltAj1DysobRNB1f8Wc4YuaowCKyTuV8bkJ4odkE388CsoeSgqo7ORZaQy6YzUkBw2sqjZn473UUjdxV3c6h16v95bxuMtFoBop0e0gg5l2V9IuBvSIbxqUcxsci7JQbb-t7ve_McqXowrBmhwOhbpkII1wudqbBiSI5Y72ffqOupY4IMXOZQlmQzxgiz-vkUpl-9UmF1nrSpJMbnV9YFXbgaO8XgnYqiuvSJ088O-8um7c0tzM2JjS8sx9qRXr_Ojk93liqpZunJjxZlhUb9BReiUuf3JixU4R0XmM4bO-BdXO720j5Xb1g9QBM6Y8BkvMgs962tp_g6MynefpFU269hbaMy8l8BluhB8RfI27e_-XIl1iZ8gdxfoQ4Q2_sm6zr3_tvstYReyiBJfsW3O-yQvJ2ZkXk3gaRowqdmcfSmbidn5Xr_RyW7Ic-F_RbO1rarZ5ox3kkyFtk27uOjwuufXry5aYf0bc7ij0fsQurjUsfY3nF89O_yr21ZnQOU_o2JVS0cJWJMQsOYt76RRZRen8mFZamm7ts4azryk6vWbXX96pdSBl7F7pBQugjydbB3pcUqFfg-xyyiIQQUyB63_kWdfSi3xwzrxXks38J4o65qYrdmUOzvs0kqc5jg8WfJxuglQkFlwOflveYo-Vt09td0FIqXp"
          },body:  jsonEncode(<String,dynamic> {

            'priority': 'high',
            'data' :<String, dynamic>{
              'click_action' : 'FLUTTER_NOTIFICATION_CLICK',
              'status' : 'done',
              'body' : body,
              'title': title
            },
            "notification" : <String,dynamic>{
              "title" :title,
              "body" : body,
              "android_channel_id" : "benchmark_estimate"
            },
            "to" : tokenReceiver
          })
      );
    }catch(e){
      if(kDebugMode){
        print("error push notification");
      }
    }
  }

  Future<String> getServerKeyToken() async  {
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];

    final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson({
      *********************
      }
      ),
      scopes,
    );
    final accessServerKey = client.credentials.accessToken.data;
    return accessServerKey;
  }

  void sendNotification(String token, BuildContext context)async{
    final String serverKey = await getServerKeyToken();
    String endPoint = 'https://fcm.googleapis.com/v1/projects/benchmark-estimates/messages:send';
    final Map<String, dynamic> message = {
      'message': {
        'token': token,
        'notification':{
          'title': 'This is the title',
          'body': 'this is the body'
        },
        'data':{
          'projectName': '12345'
        }
      }
    };
    final http.Response response = await http.post(
      Uri.parse(endPoint),
      headers: <String,String>{
        "Content-Type" : "application/json",
        "Authorization" : "Bearer $serverKey"
      },
      body: jsonEncode(message),
    );
    if(response.statusCode == 200){
      print('sent succesfull');
    }else{
      print('failed to send ${response.statusCode}');
    }
  }

  initInfo( ) {
    var androidInitialize = const AndroidInitializationSettings(
      '@mipmap/ic_launcher');

    var IOSInitialize = const IOSInitializationSettings();


    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitialize,
        iOS: IOSInitialize);
     flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) async {
        try {
          if (payload != null && payload.isNotEmpty) {
            // Parse the payload and create a RemoteMessage
            // Map<String, dynamic> data = json.decode(payload);
            // RemoteMessage message = RemoteMessage(data: data);
            // print(message.data['type']);
            // print('======================================0000');

            // handleMessage(context, message);
          }
        } catch (e) {
          print("Error handling notification: $e");
        }
      },
    );
  }

   static Future<void> _handleBackgroundMessage(RemoteMessage message, BuildContext context) async {
     print("Handling a background message: ${message.messageId}");
     print(message.notification?.title);
     print(message.notification?.body);

     await _storeNotificationClick();

   }

   static Future<void> _handleTerminatedMessage(RemoteMessage message, BuildContext context) async {
     print("Handling a terminated message: ${message.messageId}");
     print(message.notification?.title);
     print(message.notification?.body);

     // Navigate to CreateProjectScreen
     await _storeNotificationClick();

   }

   static Future<void> _storeNotificationClick() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     await prefs.setBool('notification_clicked', true);
   }

   static Future<bool> checkAndClearNotificationClick() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     bool wasClicked = prefs.getBool('notification_clicked') ?? false;
     print(wasClicked);
     print('objectobjectobjectobjectobjectobjectobject');
     if (wasClicked) {
       await prefs.setBool('notification_clicked', false);
     }
     return wasClicked;
   }
//   Future<void> setupInteractMessage(BuildContext context) async {
//     // when app is terminated
//     RemoteMessage? initialMessage =
//     await FirebaseMessaging.instance.getInitialMessage();
//     print( initialMessage?.data['type']);
//     print(initialMessage?.messageType);
//     print(initialMessage?.notification?.title);
//
// print('======================================123');
//     if (initialMessage != null) {
//
//       handleMessage(context, initialMessage);
//     }
//
//     //when app ins background
//     FirebaseMessaging.onMessageOpenedApp.listen((event) {
//       handleMessage(context, event);
//     });
//   }
//
//   void handleMessage(BuildContext context, RemoteMessage message) {
//     if (message.data['type'] == 'Chat') {
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => ChatScreen(
//                projectId: '1721853150747',
//               )));
//     }
//     if (message.data['type'] == 'order') {
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => ProjectSubmittedView(
//                 docId: '1721853150747',
//               )));
//     }
//   }


}


