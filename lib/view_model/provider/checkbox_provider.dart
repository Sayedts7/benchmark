import 'package:flutter/cupertino.dart';

class CheckBoxProvider with ChangeNotifier{
  bool _isChecked = false;
  bool get isChecked => _isChecked;
  void updateCheckBox(bool value){
    _isChecked = value;
    notifyListeners();
  }
}