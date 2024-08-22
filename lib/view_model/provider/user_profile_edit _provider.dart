import 'package:benchmark_estimate/utils/utils.dart';
import 'package:benchmark_estimate/view_model/provider/loader_view_provider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class UserProfileProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isEditing = false;
  bool get isEditing => _isEditing;

  String? _name;
  String? _email;

  String? get name => _name;
  String? get email => _email;

  UserProfileProvider() {
    loadUserData();
  }

  void loadUserData() async {
    final userDoc = await _firestore.collection('User').doc(_auth.currentUser!.uid).get();
    _name = userDoc['name'];
    _email = userDoc['email'];
    notifyListeners();
  }

  void toggleEditing() {
    _isEditing = !_isEditing;
    notifyListeners();
  }

  void updateName(String value) {
    _name = value;
    notifyListeners();
  }

  void saveUserData(BuildContext context) async {
    final loadingProvider = Provider.of<LoaderViewProvider>(context,listen: true);
    loadingProvider.changeShowLoaderValue(true);
    await _firestore.collection('User').doc(_auth.currentUser!.uid).update({
      'name': _name,
    }).then((value) {
      toggleEditing();
      loadingProvider.changeShowLoaderValue(true);

      Utils.toastMessage('ho gaya');
      notifyListeners();
    }).onError((error, stackTrace) {
      Utils.toastMessage('ho gaya');
    loadingProvider.changeShowLoaderValue(true);
    notifyListeners();

    }
    );
  }
}
