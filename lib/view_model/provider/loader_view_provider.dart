import 'package:flutter/cupertino.dart';

class LoaderViewProvider with ChangeNotifier{
  bool _showLoader = false;

  bool get showLoader => _showLoader;

 void changeShowLoaderValue(bool value) {
    _showLoader = value;
    notifyListeners();
  }
}