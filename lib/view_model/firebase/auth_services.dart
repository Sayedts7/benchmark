import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../utils/common_function.dart';
import '../../utils/utils.dart';
import '../../view/home/home_view.dart';
import '../provider/loader_view_provider.dart';

class AuthServices{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> signInWithEmail(BuildContext context,String email, String password) async {
    // final obj = Provider.of<LoadingProvider>(context, listen: false);

    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } catch (e) {
      if (kDebugMode) {
        print('Exception is here bro: $e, Type: ${e.runtimeType}');
      }

      if (e is FirebaseAuthException) {
        String errorMessage = '';
        switch (e.code) {
          case 'invalid-email':
            errorMessage = 'Invalid Email';
            break;
          case 'user-not-found':
            errorMessage = 'User nt found';
            break;
          case 'wrong-password':
            errorMessage = 'Wrong Password';
            break;
        // Add more cases as per your requirements
          default:
            errorMessage = e.message.toString() ;
        }
        _showErrorDialog(context, errorMessage);

      } else {
        if (kDebugMode) {
          print('Error signing in and out: $e');
        }
        // Handle other types of exceptions or unknown errors
      }
    }
  }

  Future<UserCredential?> signUpWithEmail(BuildContext context, String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user?.sendEmailVerification();
      return userCredential;
    } catch (e) {
      if (e is FirebaseAuthException) {
        String errorMessage = '';
        switch (e.code) {
          case 'invalid-email':
            errorMessage = 'Invalid Email';
            break;
          case 'user-not-found':
            errorMessage = 'User not found';
            break;
          case 'wrong-password':
            errorMessage = 'Wrong Password';
            break;
          case 'email-already-in-use':
            errorMessage = 'The email address is already in use by another account.';
            break;
          default:
            errorMessage = e.message.toString();
        }
        _showErrorDialog(context, errorMessage);
      } else {
        if (kDebugMode) {
          print('Error signing in and out: $e');
        }
      }
      print('Error signing up with email and password: $e');
      return null;
    }
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final firestore = FirebaseFirestore.instance.collection('User');

  Future<UserCredential?> signInWithGoogle() async {
    if (kIsWeb) {
      // Sign in with Google on the web
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential = await _auth.signInWithPopup(googleProvider);
        return userCredential;
      } catch (e) {
        print(e);
        return null;
      }
    } else {
      // Sign in with Google on mobile
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // Check for cancellation
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      try {
        final UserCredential userCredential = await _auth.signInWithCredential(credential);
        return userCredential;
      } catch (e) {
        print(e);
        return null;
      }
    }
  }

  Future<void> handleGoogleSignIn(BuildContext context) async {
    final obj = Provider.of<LoaderViewProvider>(context, listen: false);

    bool isConnected;
    if (kIsWeb) {
      isConnected = true;
    } else {
      isConnected = await Utils.checkInternetConnection();
    }

    // Start the loading
    obj.changeShowLoaderValue(true);

    if (isConnected) {
      signInWithGoogle().then((value) async {
        if (value != null) {
          // Check if user data already exists
          final userDocument = firestore.doc(FirebaseAuth.instance.currentUser!.uid);
          final userSnapshot = await userDocument.get();

          if (!userSnapshot.exists) {
            await setData(
                value.user!.email!,
                value.user!.displayName!,
                'google',
                value.user!.phoneNumber ?? '',
                ''
            ).then((_) {
              obj.changeShowLoaderValue(false);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeView()));
            }).onError((error, stackTrace) {
              obj.changeShowLoaderValue(false);
              Utils.toastMessage(error.toString());
            });
          } else {
            obj.changeShowLoaderValue(false);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeView()));
          }
        } else {
          obj.changeShowLoaderValue(false);
          Utils.toastMessage('Some Error Occurred');
        }
      });
    } else {
      obj.changeShowLoaderValue(false);
      // Show the dialog if the internet is not available
      CommonFunctions.showNoInternetDialog(context);
    }
  }

  Future<void> setData(String email, String name, String type, String phone, String password) async {
    final DocumentReference parentDocument = firestore.doc(FirebaseAuth.instance.currentUser!.uid);

    await parentDocument.set({
      'id': FirebaseAuth.instance.currentUser!.uid,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'signUpWith': type,
      'verified': false,
      'status': 'Activate',
      'isDeleted': false,
      'isBlocked': false,
      'deleteTime': '',
    });
  }


  void _showErrorDialog(BuildContext context,String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Error sending password reset email: $e');
    }
  }


  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  Future<void> updatePassword(String oldPassword, String newPassword) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      AuthCredential credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: oldPassword,
      );

      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);

      print('Password updated successfully');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        throw Exception('The old password is incorrect');
      } else {
        throw Exception('Error updating password: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}

