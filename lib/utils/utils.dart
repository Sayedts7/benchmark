import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import 'constants/colors.dart';
import 'custom_widgets/custom_button.dart';

// import '../custom_widgets/app_button.dart';


class Utils{
  static launchEmail(String url) async {
    var encoded = Uri.parse(url);
    if (await canLaunchUrl(encoded)) {
      launchUrl(encoded,

          mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  static void authErrorSnackbar(BuildContext context, String title, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.black.withOpacity(0.6),
        // margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
        // elevation: 20,
        behavior: SnackBarBehavior.fixed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            // Add any action on pressing the close button
          },
        ),
      ),
    );
  }
  static void showDeletedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Account Deleted'),
          content: Text('Your account has been deleted.'),
          actions: [
            CustomButton8(
              // width: width(context)* 0.35,
              height: 50,

              onPressed: () {
                launchEmail('mailto:sohib.balkhy@gmail.com');

                // Perform the action when the "Contact Admin" button is pressed
                // Add your logic for contacting the admin here
                Navigator.of(context).pop(); // Close the dialog
              }, text: 'Contact Admin',

            ),
          ],
        );
      },
    );
  }
  static void showImageDialog(BuildContext context, ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('No internet connection'),
        content:
        const Text('Please check your internet connection and try again.'),
        actions: [
          ElevatedButton(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  static launchSocialApps(String url) async {
    var encoded = Uri.parse(url);
    if (await canLaunchUrl(encoded)) {
      launchUrl(encoded,

          mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  static toastMessage(String message){
    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.TOP,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }

  static snackBar(String message, BuildContext context){
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(

          backgroundColor: Colors.black,
          content: Text(message, style: TextStyle(color: Colors.white),),
        )
    );
  }

  static showCustomSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
      backgroundColor: primaryColor,
      // elevation: 50,
      // width: MediaQuery.of(context).size.width*0.8,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.1),

      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(10.0),

      ),
      duration: Duration(seconds: 3),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Add any action you want when the user presses the action button.
        },
        textColor: Colors.white,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static Future<bool> checkInternetConnection() async {
    bool isConnected = false;
    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
      }
    } on SocketException catch (_) {
      isConnected = false;
    }
    return isConnected;
  }

  static String? validateEmail(String value) {
    // The regular expression pattern to check for email format
    String pattern = r'^([a-zA-Z0-9_\.-]+)@([\da-zA-Z\.-]+)\.([a-zA-Z\.]{2,6})$';
    RegExp regExp = RegExp(pattern);

    if (!regExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }
}
Future<CroppedFile?> cropImage(File image,BuildContext context ) async {
  CroppedFile? crop;
   await ImageCropper().cropImage(
    sourcePath: image.path,
    aspectRatioPresets: [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
    ],
    uiSettings: [
      AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: primaryColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      IOSUiSettings(
        title: 'Cropper',
      ),
      WebUiSettings(
        context: context,
      ),
    ],
  ).then((value) {
    crop = value;
    print('==========');
    print(crop?.path);
  });
return crop;
}

