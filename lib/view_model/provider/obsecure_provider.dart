import 'package:flutter/cupertino.dart';

class ObscureProvider with ChangeNotifier{
  bool _obsecureText = true;

  bool get obsecureText => _obsecureText;

  setObsecureText(bool value) {
    _obsecureText = value;
    notifyListeners();
  }
}