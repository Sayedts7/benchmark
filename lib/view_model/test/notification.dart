// // ignore_for_file: depend_on_referenced_packages
//
// import 'dart:convert';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
//
// class NotificationServices {
//   ///Push 1-1 Notification
//   Future pushOneToOneNotification({
//     required String title,
//     required String body,
//     required String sendTo,
//     required String message,
//     required String location,
//     required String type,
//     required String id,
//   }) async {
//
//     var data = {
//       'to': sendTo,
//       'notification': {
//         'title': title,
//         'body': body,
//         'sound': 'default',
//       },
//       'android': {
//         'notification': {
//           'notification_count': 23,
//         },
//       },
//       'data': {
//         'type': type,
//         'id': id,
//       }
//     };
//
//     return await http
//         .post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
//             headers: {
//               'Content-Type': 'application/json; charset=UTF-8',
//               "Authorization": "key=${BackendConfigs.kServerKey}"
//             },
//             body: json.encode(data))
//         .then((value) {
//       if (kDebugMode) {
//         print(value.body.toString());
//       }
//     }).onError((error, stackTrace) {
//       if (kDebugMode) {
//         print(error);
//       }
//     });
//   }
//
//   ///TopicNotification
//   Future sendTopicNotification({
//     required String title,
//     required String body,
//     required String location,
//   }) async {
//     http.Response response =
//         await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
//             headers: {
//               "Content-Type": "application/json",
//               "Authorization": "key=${BackendConfigs.kServerKey}"
//             },
//             body: json.encode({
//               "notification": {
//                 "body": body,
//                 "title": title,
//                 "sound": "default",
//                 "location": location,
//               },
//               "android": {"priority": "high"},
//               "apns": {
//                 "payload": {
//                   "aps": {"sound": "default", "contentAvailable": true}
//                 }
//               },
//               "headers": {
//                 "apns-push-type": "background",
//                 "apns-priority": "5",
//                 "apns-topic": "io.flutter.plugins.firebase.messaging"
//               },
//               "to": '/topics/${getUserID()}'
//             }));
//     if (response.statusCode == 200) {
//     } else {}
//   }
//
//   ///Get One Specific User Token
//   Stream<String> streamSpecificUserToken(String docID) {
//     return FirebaseFirestore.instance
//         .collection('tokens')
//         .doc(docID)
//         .snapshots()
//         .map((event) {
//       return event.data()!['deviceTokens'];
//     });
//   }
// }
