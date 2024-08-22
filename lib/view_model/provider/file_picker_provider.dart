import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class FilePickerProvider with ChangeNotifier {
  List<File> _files = [];
  List<File> get files => _files;

  List<PlatformFile> _webFiles = [];
  List<PlatformFile> get webFiles => _webFiles;

  ValueNotifier<double> uploadProgress = ValueNotifier<double>(0);

  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      if (kIsWeb) {
        _webFiles = result.files;
      } else {
        _files = result.paths.map((path) => File(path!)).toList();
      }
      notifyListeners();
    }
  }

  void removeFile(File file) {
    _files.remove(file);
    notifyListeners();
  }

  void removeWebFile(PlatformFile file) {
    _webFiles.remove(file);
    notifyListeners();
  }
  void clearAll(){
    _webFiles.clear();
    files.clear();
    notifyListeners();
  }
}
