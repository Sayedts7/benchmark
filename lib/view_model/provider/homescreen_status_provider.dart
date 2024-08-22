import 'package:flutter/cupertino.dart';

class HomeScreenStatusProvider with ChangeNotifier{

   String status = 'All';
  void updateStatus(String stat){
    status = stat;
    print(status);
    notifyListeners();
  }
}