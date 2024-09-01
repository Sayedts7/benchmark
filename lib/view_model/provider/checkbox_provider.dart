import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckBoxProvider with ChangeNotifier{
  bool _isChecked = false;
  bool get isChecked => _isChecked;
  void updateCheckBox(bool value)async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    _isChecked = value;
    if(isChecked == true){
      prefs.setBool('rememberMe', true);
    }else{
      prefs.setBool('rememberMe', false);

    }
    notifyListeners();
  }
}