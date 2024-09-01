import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;


  Future<String?> getUserStatus(String email) async {
    final QuerySnapshot querySnapshot = await _db
        .collection('User')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs[0]['status'].toString();
    } else {
      return null;
    }
  }

  Future<bool> checkEmailExists(String email) async {
    try {
      print('Checking email: $email');
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection('User').
    where('email', isEqualTo: email)
          .where('signUpWith', isEqualTo: 'email')
          .limit(1) // Limiting to 1 document for efficiency
          .get();

      print('Query snapshot: ${querySnapshot.docs}');
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      // Handle errors appropriately, e.g., log the error or show a message to the user
      print('Error checking email existence: $e');
      return false;
    }
  }
// Fetch a single user by ID
  Future<UserData?> fetchUserById(String id) async {
    try {
      DocumentSnapshot docSnapshot = await _db.collection('users').doc(id).get();
      if (docSnapshot.exists) {
        return UserData.fromJson(docSnapshot.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }
  Future<String?> fetchUserName() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        String uid = currentUser.uid;
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('User').doc(uid).get();
        if (userDoc.exists) {
          String userName = userDoc.get('name');
          return userName;
        } else {
          print('User document does not exist');
          return null;
        }
      } else {
        print('No user is currently signed in');
        return null;
      }
    } catch (e) {
      print('Error fetching user name: $e');
      return null;
    }
  }

  Future<void> setNotifications(String receiverId,String title, String message, String projectId )async {
    var id = DateTime.now().millisecondsSinceEpoch.toString();
    // var alpha = Random();
    FirebaseFirestore.instance.collection('Notifications').doc(id).set({
      'id': id,
      'fromId': FirebaseAuth.instance.currentUser!.uid,
      'toId': receiverId,
      'title':title,
      'message': message,
      'date': DateTime.now(),
      'read': false,
      'projectId':projectId,
    });
  }

  Future<String?> getTokenFromUserCollection(String uid) async {
    try {
      // Reference to the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Reference to the User document with the given UID
      DocumentSnapshot userDoc = await firestore.collection('users').doc(uid).get();

      // Check if the document exists and contains a token field
      if (userDoc.exists && userDoc.data() != null) {
        var data = userDoc.data() as Map<String, dynamic>;
        if (data.containsKey('token')) {
          return data['token'] as String?;
        } else {
          print('Token field does not exist in the document.');
          return null;
        }
      } else {
        print('User document does not exist.');
        return null;
      }
    } catch (e) {
      print('Error getting token: $e');
      return null;
    }
  }


}

