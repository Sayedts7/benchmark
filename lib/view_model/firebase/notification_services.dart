// import 'dart:convert';
//
// import 'package:benchmark_estimate/view_model/firebase/push_notification.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:googleapis_auth/auth_io.dart';
// import 'package:http/http.dart' as http;
// import 'package:overlay_support/overlay_support.dart';
//
// class NotificationService {
//   late String _fcmToken;
//
//   static final FlutterLocalNotificationsPlugin _notificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   static void initialize() {
//     final InitializationSettings initializationSettings =
//     InitializationSettings(
//       android: AndroidInitializationSettings("@mipmap/ic_launcher"),
//       iOS: DarwinInitializationSettings(
//         requestSoundPermission: false,
//         requestBadgePermission: false,
//         requestAlertPermission: false,
//       ),
//     );
//
//     _notificationsPlugin.initialize(initializationSettings);
//   }
//
//   static void display(RemoteMessage message) async {
//     PushNotification? _notificationInfo;
//
//     try {
//       final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
//
//       final NotificationDetails notificationDetails = NotificationDetails(
//         android: AndroidNotificationDetails(
//           'high_importance_channel', // id
//      'High Importance Notifications', // title
//           importance: Importance.max,
//           priority: Priority.high,
//         ),
//         iOS: DarwinNotificationDetails(),
//       );
// print('here 101');
//
//       await _notificationsPlugin.show(
//         id,
//         message.notification!.title,
//         message.notification!.body,
//         notificationDetails,
//         payload:  message.data['body']
//       );
//       PushNotification notification = PushNotification(
//         title: message.notification?.title,
//         body: message.notification?.body,
//       );
//       _notificationInfo = notification;
//       print(_notificationInfo.title);
//       print(_notificationInfo.title);
//       if(_notificationInfo != null)
//       {
//         showSimpleNotification(Text(_notificationInfo!.title!),subtitle: Text(_notificationInfo!.body!),
//             background: Colors.cyan.shade700,
//             duration: Duration(seconds: 10));
//       }
//
//     } on Exception catch (e) {
//       print('0000000000000000000000000000');
//       print(e);
//     }
//   }
//
//   // Function to check and request permissions
//   Future<void> checkAndRequestPermissions(BuildContext context) async {
//     // For iOS, we need to request permissions explicitly
//     if (Theme.of(context).platform == TargetPlatform.iOS) {
//       FirebaseMessaging messaging = FirebaseMessaging.instance;
//       NotificationSettings settings = await messaging.requestPermission(
//         alert: true,
//         announcement: false,
//         badge: true,
//         carPlay: false,
//         criticalAlert: false,
//         provisional: false,
//         sound: true,
//       );
//
//       if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//         print('User granted permission');
//       } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
//         print('User granted provisional permission');
//       } else {
//         print('User declined or has not accepted permission');
//       }
//     }
//     // For Android, permissions are handled in the manifest file
//     else {
//       print('Android permissions are set in the manifest file');
//     }
//   }
//   // Function to get FCM token and save it to Firestore
//   Future<void> getFCMTokenAndSave() async {
//     // Get the current user
//     User? user = FirebaseAuth.instance.currentUser;
//
//     if (user != null) {
//       // Get the FCM token
//       _fcmToken = await FirebaseMessaging.instance.getToken() ?? '';
//       print('FCM Token: $_fcmToken');
//
//       // Save the token to Firestore
//       await FirebaseFirestore.instance.collection('User').doc(user.uid).set({
//         'token': _fcmToken,
//       }, SetOptions(merge: true));
//
//       print('FCM Token saved to Firestore');
//     } else {
//       print('User is not signed in');
//     }
//   }
//   Future<String> getServerKeyToken() async  {
//     final scopes = [
//       'https://www.googleapis.com/auth/userinfo.email',
//       'https://www.googleapis.com/auth/firebase.database',
//       'https://www.googleapis.com/auth/firebase.messaging',
//     ];
//
//     final client = await clientViaServiceAccount(
//       ServiceAccountCredentials.fromJson({
//         "type": "service_account",
//         "project_id": "benchmark-estimates",
//         "private_key_id": "dbe1827f98dd40a4a9916986580ed2b88264d9da",
//         "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDXSCefLxvfHIRG\nZBIP+omYgznsf2k+1I2x9VxKbNTWhppMRRBK2OEynvytZf4TIm+lxySg7mr0WUYE\n8sTILfuBCoy4/aXysYz/chJmOID9jOF4rzdhjj2jT7x4+yF9DS+V+w1H4r0RbPP/\n2J/QGXwUa1rFfYczp+0sE5Hb0YvMpOYx0mOaCiVhg4Ktek6MyVCsXxbS7XCu5KTU\nC5pj/BqvRdp3sc8a3u0KNj19fKONnGwmVk5kD8pffFzw2cRZu7sjfM4pYEdjFsot\nuNsh5Pj4S6XJu24KA9QJW+vT79Nw8X0sttxq/dfsq7lRRfdEuZSOZV7ytMQcjOz3\n3zqmehMzAgMBAAECggEASLj4nXbh8OfmrQqf6WLmOS1XE1Nk/5L4vJ1YTFHgQgmd\nNNd9rfL+e8WmMIMMJXWUBomzj2OKoLlJhGFn5QFXfNtN9y3D8axVp3Lm0T4UINKG\n1ehGin9sxe6pCas3wFEEeqMgdOCcorbN4+bO8ZKyTgmH07/YPLRk02dW9c0e7wVE\nnEQL/tVt7pqcvZDocEMxbwSM8jWnrzpH4babqviY+LgBB/+eVIbNtQBIDB4L0RLD\nksvywy4fmCHwnjpF2ZWTWHXP/+sYMzXNVfNCBMyWIas6PFNbdayqhEGHiTF6nqhG\nOZYrH6D8uIyAvavggJW8y1LTTeyjbeYmGv2Clc4xsQKBgQDqx5/mi23LV+1VFJ6o\ni+eFog6PWTta/cXAlMTUzk93DFjL+UBVgF9JTho/6PcPgMkylVhc0zS1+L8JLDMq\nTxOcLpcXvsV7bcOZ1lNaPN0J8i9A1tORQDhIcr2sA0Oa4eM25aAqsWHNYfk8nmZa\nkJY6HCKb+3f++8ss6U0z5H3xYwKBgQDqvWI5xSMAJc6Xv6J74ZVs0WMnGgMB/qSp\n1vSzZmk3730YZG3l5/wILZ4QENFGMPRbyzhVSd5NgUoDL35diu6l3ktkNtJqhSoE\nJ3J0ffgw0U650avDZ+b7wAPjv80jh2VoSC7BbkKTWw77EDgQy+j26A06AQbPcrCI\nMo+ImHln8QKBgBu4ej7EU7Bgr1sOVjVcX3e9zK5MQN/bes/kQOFHgsZxpMJgqaHu\nyFFlcV/+Z71i3V6ll4tOPLkHp7azi08BizUzow9grPyH10KAtdK/wPF9sOqc8toB\nlSOouJBoykCtTyCaODESRJP1b3Ii2b7zt2khDU0RgfePT0v8N+tanSw1AoGBAL1c\nsVRxF18TIKmByg2tWOFDuHzemvaM+UCZSyU9xDt/UqbOvWjtz365bfz/1BKPg1BZ\ni8QhptdXKOGQ+ptzbDkaLi9VmkCb090uBUK8K+8VqjB0V992ffswVvLu0wmKO9/3\n+t/HlqVQm7Ek0FWcaP5lC+Zy1Y+bsZTtVKSYe7fBAoGAO2VdhAtXtp5koMvcFYHi\nupUjYaNWA4K8b77+I+qsE5cqu0xlwgcmnqU6HcBjCfVb1TyZwRkQwcg5lyPR8vOs\nliCUWigf2mA1yeMe/CoKwE9GoWfwNWCkI5zRkFH24HMu+jtSeDfVN4sf1Neiwvuu\npffOZAWtFo37MguQNNsia/E=\n-----END PRIVATE KEY-----\n",
//         "client_email": "firebase-adminsdk-xl6qk@benchmark-estimates.iam.gserviceaccount.com",
//         "client_id": "115794491112301104369",
//         "auth_uri": "https://accounts.google.com/o/oauth2/auth",
//         "token_uri": "https://oauth2.googleapis.com/token",
//         "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
//         "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-xl6qk%40benchmark-estimates.iam.gserviceaccount.com",
//         "universe_domain": "googleapis.com"
//       }
//       ),
//       scopes,
//     );
//     final accessServerKey = client.credentials.accessToken.data;
//     return accessServerKey;
//   }
//
//   void sendNotification(String token, BuildContext context)async{
//     final String serverKey = await getServerKeyToken();
//     String endPoint = 'https://fcm.googleapis.com/v1/projects/benchmark-estimates/messages:send';
//     final Map<String, dynamic> message = {
//       'message': {
//         'token': token,
//         'notification':{
//           'title': 'This is the title',
//           'body': 'this is the body'
//         },
//         'data':{
//           'projectName': '12345'
//         }
//       }
//     };
//     final http.Response response = await http.post(
//       Uri.parse(endPoint),
//       headers: <String,String>{
//         "Content-Type" : "application/json",
//         "Authorization" : "Bearer $serverKey"
//       },
//       body: jsonEncode(message),
//     );
//     if(response.statusCode == 200){
//       print('sent succesfull');
//     }else{
//       print('failed to send ${response.statusCode}');
//     }
//   }
//
// }