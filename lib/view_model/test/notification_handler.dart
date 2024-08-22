// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:write_way_flutter/infrastructure/models/notification_model.dart';
// import 'package:write_way_flutter/presentation/elements/get_user_id.dart';
//
// import 'notification.dart';
//
// class NotificationHandlerServices {
//   final NotificationServices _services = NotificationServices();
//
//   ///Push 1-1 Notification
//   Future oneToOneNotificationHelper(
//       {required String docID,
//       required String body,
//       required String title,
//       required String message,
//         required String type,
//         required String id,
//
//       required String location}) {
//     return _services.streamSpecificUserToken(docID).first.then((value) {
//       _services.pushOneToOneNotification(
//         sendTo: value,
//         title: title,
//         body: body,
//         location: location,
//         message: message, type: type, id: id,
//
//       );
//     });
//   }
//
//   ///CreateNotification
//
//   Future createNotification(BuildContext context,
//       {required FirebaseNotificatonModel model}) async {
//     DocumentReference docRef =
//         FirebaseFirestore.instance.collection('notifications').doc();
//     return await docRef.set(model.toJson(docRef.id));
//   }
//
//   ///Fetch Notifications
//   Stream<List<FirebaseNotificatonModel>> streamNotification() {
//     return FirebaseFirestore.instance
//         .collection("notifications")
//         .where('reciverID', isEqualTo: getUserID())
//         .orderBy('date', descending: true)
//         .snapshots()
//         .map((event) => event.docs
//             .map((e) => FirebaseNotificatonModel.fromJson(e.data()))
//             .toList())
//         .handleError((error) => Stream.value(FirebaseNotificatonModel()));
//   }
//
//   ///Fetch Notifications
//   Stream<List<FirebaseNotificatonModel>> streamNotificationCounter() {
//     return FirebaseFirestore.instance
//         .collection("notifications")
//         .where('reciverID', isEqualTo: getUserID())
//         .where('isRead', isEqualTo: false)
//         .snapshots()
//         .map((event) => event.docs
//             .map((e) => FirebaseNotificatonModel.fromJson(e.data()))
//             .toList())
//         .handleError((error) => Stream.value(FirebaseNotificatonModel()));
//   }
//
//   ///Update Notification Status
//   Future<void> updateNotificationStatus(String notificationID) async {
//     FirebaseFirestore.instance
//         .collection('notifications')
//         .doc(notificationID)
//         .update({"isRead": true});
//   }
// }
