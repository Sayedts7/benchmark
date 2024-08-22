import 'dart:async';

import 'package:benchmark_estimate/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/constants/MySize.dart';
import '../home/home_view.dart';

class EmailVerificationScreen extends StatefulWidget {
  @override
  _EmailVerificationScreenState createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  bool _isEmailVerified = false;
  Timer? _timer;

  @override
  void initState() {
    _user = _auth.currentUser;
    _user?.sendEmailVerification();
    _checkEmailVerified();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _checkEmailVerified() async {
    _user = _auth.currentUser;
    await _user?.reload();
    if (_user != null && _user!.emailVerified) {
      updateUser();
      _timer?.cancel();
    }
  }
  void updateUser(){
    FirebaseFirestore.instance.collection('User').doc(FirebaseAuth.instance.currentUser!.uid).update({
      'verified' : true,
    }).then((value) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeView()));
    }).onError((error, stackTrace){
      Utils.toastMessage(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Your Email'),
      ),
      body: Center(
        child: Padding(
          padding: kIsWeb?   EdgeInsets.symmetric(horizontal:MySize.screenWidth * 0.4, vertical: MySize.screenHeight * 0.2):
          const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('A verification email has been sent to ${_user?.email}. Please check your email and verify your account.'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _user?.sendEmailVerification();
                },
                child: Text('Resend Email'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
