// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/foundation.dart';
//
// class FilePickerProvider with ChangeNotifier {
//   List<File> _files = [];
//   List<File> get files => _files;
//
//   List<PlatformFile> _webFiles = [];
//   List<PlatformFile> get webFiles => _webFiles;
//
//   List<dynamic> _existingFileUrls = [];
//   List<dynamic> get existingFileUrls => _existingFileUrls;
//   ValueNotifier<double> uploadProgress = ValueNotifier<double>(0);
//
//   Future<void> pickFiles() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
//
//     if (result != null) {
//       if (kIsWeb) {
//         _webFiles.addAll(result.files);
//       } else {
//         _files.addAll(result.paths.map((path) => File(path!)).toList());
//       }
//       notifyListeners();
//     }
//   }
//
//   void removeFile(File file) {
//     _files.remove(file);
//     notifyListeners();
//   }
//
//   void removeWebFile(PlatformFile file) {
//     _webFiles.remove(file);
//     notifyListeners();
//   }
//
//
//   void setExistingFileUrls(List<dynamic> urls) {
//     _existingFileUrls = urls;
//     notifyListeners();
//   }
//
//   void removeExistingFileUrl(String url) {
//     _existingFileUrls.remove(url);
//     notifyListeners();
//   }
//   void clearAll() {
//     _webFiles.clear();
//     _files.clear();
//     _existingFileUrls.clear();
//     uploadProgress.value = 0;
//     notifyListeners();
//   }
// }




//////////////////////////////////

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class FilePickerProvider with ChangeNotifier {
  List<File> _files = [];
  List<File> get files => _files;

  List<PlatformFile> _webFiles = [];
  List<PlatformFile> get webFiles => _webFiles;

  List<dynamic> _existingFileUrls = [];
  List<dynamic> get existingFileUrls => _existingFileUrls;

  ValueNotifier<double> uploadProgress = ValueNotifier<double>(0);

  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      if (kIsWeb) {
        _webFiles.addAll(result.files);
      } else {
        _files.addAll(result.paths.map((path) => File(path!)).toList());
      }
      notifyListeners();
    }
  }

  void removeFile(dynamic file) {
    if (file is File) {
      _files.remove(file);
    } else if (file is PlatformFile) {
      _webFiles.remove(file);
    }
    notifyListeners();
  }

  void setExistingFileUrls(List<dynamic> urls) {
    _existingFileUrls = urls;
    notifyListeners();
  }

  void removeExistingFileUrl(String url) {
    _existingFileUrls.remove(url);
    notifyListeners();
  }

  void clearAll() {
    _webFiles.clear();
    _files.clear();
    _existingFileUrls.clear();
    uploadProgress.value = 0;
    notifyListeners();
  }

  List<dynamic> getAllFiles() {
    if (kIsWeb) {
      print('this is 1st lenght ${ [..._webFiles, ..._existingFileUrls].length}');

      return [..._webFiles, ..._existingFileUrls];
    } else {
      print('this is 2nd lenght ${ [...files, ..._existingFileUrls].length}');

      return [..._files, ..._existingFileUrls];
    }
  }

  bool get hasFiles => _files.isNotEmpty || _webFiles.isNotEmpty || _existingFileUrls.isNotEmpty;
}