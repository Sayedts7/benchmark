import 'dart:async';

import 'package:benchmark_estimate/view/home/home_view.dart';
import 'package:benchmark_estimate/view_model/firebase/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../view_model/firebase/firebase_functions.dart';
import '../auth/login_view.dart';


class SplashServices{


  void isLogin(BuildContext context)async{
print('--------------------------');
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
final SharedPreferences prefs = await SharedPreferences.getInstance();
print('=========================================${prefs.getBool('rememberMe')}');
if(prefs.getBool('rememberMe') == false || prefs.getBool('rememberMe') == null) {
  await AuthServices().signOut();
  Timer(const Duration(seconds: 1), () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginView())));

}else{
  if (user != null){
    // String? phoneNull = await getPhone();
    String? status = await FirestoreService().getUserStatus(user.email!);

    if(status == 'Activate'){
      // if(phoneNull == ''){
      //   Timer(const Duration(seconds: 2), () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> SignInWithPhone()))  );
      //
      // }else{
      Timer(const Duration(seconds: 2), () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeView()))  );

      // }
    }else{

      Timer(const Duration(seconds: 5), () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginView())));
      // showDialogStatus(context, 'User is deactivated by admin, Kindly contact admin');
    }


  }
  else{
    Timer(const Duration(seconds: 1), () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginView())));

  }
}


}

}