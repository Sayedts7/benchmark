import 'dart:async';

import 'package:benchmark_estimate/utils/constants/MySize.dart';
import 'package:benchmark_estimate/utils/constants/colors.dart';
import 'package:benchmark_estimate/utils/constants/image_path.dart';
import 'package:benchmark_estimate/view/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../utils/constants/textStyles.dart';
import '../../utils/custom_widgets/custom_button.dart';
import '../../utils/custom_widgets/custom_textfield.dart';

class PhoneVerificationView extends StatefulWidget {
  final String verificationId, phoneNumber,from;

  const PhoneVerificationView({super.key,required this.verificationId, required this.phoneNumber, this.from= 'All'});

  @override
  State<PhoneVerificationView> createState() => _PhoneVerificationViewState();
}

class _PhoneVerificationViewState extends State<PhoneVerificationView> {
  TextEditingController textEditingController = TextEditingController();
// ..text = "123456";

// ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

// snackBar Widget
  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    if (MySize.screenWidth > 700) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: SvgPicture.asset(logoSec),
          automaticallyImplyLeading: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal:MySize.screenWidth * 0.4, vertical: MySize.screenHeight * 0.2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Text('Verification Code', style:  AppTextStyles.heading,),
                SizedBox(
                  height: MySize.size10,
                ),
                Text('We have send the code verification to your  Mobile Number',
                  style:              AppTextStyles.label12500BTC,),

                SizedBox(
                  height: MySize.size20,
                ),
                Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 0,
                    ),
                    child: PinCodeTextField(
                      appContext: context,
                      pastedTextStyle: const TextStyle(
                        color: Color(0xffCED8E3),
                        fontWeight: FontWeight.bold,
                      ),
                      length: 6,
                      // obscureText: true,
                      // obscuringCharacter: '*',
                      // obscuringWidget: const FlutterLogo(
                      //   size: 24,
                      // ),
                      // blinkWhenObscuring: true,
                      animationType: AnimationType.fade,
                      // validator: (v) {
                      //   if (v!.length < 3) {
                      //     return "I'm from validator";
                      //   } else {
                      //     return null;
                      //   }
                      // },
                      pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 50,
                          fieldWidth: 40,
                          activeFillColor: secondaryColor,
                          activeBorderWidth: 1,
                          activeColor: primaryColor,

                          inactiveBorderWidth: 1,
                          inactiveColor: Color(0xffCED8E3),
                          inactiveFillColor: secondaryColor,

                          selectedBorderWidth: 1,
                          selectedFillColor: secondaryColor,
                          selectedColor: blackColor
                      ),
                      cursorColor: Colors.black,
                      animationDuration: const Duration(milliseconds: 300),
                      enableActiveFill: true,
                      errorAnimationController: errorController,
                      controller: textEditingController,
                      keyboardType: TextInputType.number,
                      boxShadows: const [
                        BoxShadow(
                          offset: Offset(0, 1),
                          color: Colors.black12,
                          blurRadius: 10,
                        )
                      ],
                      onCompleted: (v) {
                        debugPrint("Completed");
                      },
// onTap: () {
//   print("Pressed");
// },
                      onChanged: (value) {
                        debugPrint(value);
                        setState(() {
                          currentText = value;
                        });
                      },
                      beforeTextPaste: (text) {
                        debugPrint("Allowing to paste $text");
//if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
//but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                CustomButton8(text: 'Submit', onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>  HomeView()));
                }),
                const SizedBox(
                  height: 20,
                ),
                Center(child: Text('Send Code in 00:21', style: AppTextStyles.label16600BTC,))


              ],
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: SvgPicture.asset(logoSec),
          automaticallyImplyLeading: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.all(MySize.size20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MySize.size150,),
                const Text('Verification Code', style:  AppTextStyles.heading,),
                SizedBox(
                  height: MySize.size10,
                ),
                Text('We have send the code verification to your \nMobile Number',
                  style: AppTextStyles.label12500BTC,),
                SizedBox(
                  height: MySize.size20,
                ),
                Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 0,
                    ),
                    child: PinCodeTextField(
                      appContext: context,
                      pastedTextStyle: const TextStyle(
                        color: Color(0xffCED8E3),
                        fontWeight: FontWeight.bold,
                      ),
                      length: 6,
                      // obscureText: true,
                      // obscuringCharacter: '*',
                      // obscuringWidget: const FlutterLogo(
                      //   size: 24,
                      // ),
                      // blinkWhenObscuring: true,
                      animationType: AnimationType.fade,
                      // validator: (v) {
                      //   if (v!.length < 3) {
                      //     return "I'm from validator";
                      //   } else {
                      //     return null;
                      //   }
                      // },
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: secondaryColor,
                        activeBorderWidth: 1,
                        activeColor: primaryColor,

                        inactiveBorderWidth: 1,
                        inactiveColor: Color(0xffCED8E3),
                        inactiveFillColor: secondaryColor,

                        selectedBorderWidth: 1,
                        selectedFillColor: secondaryColor,
                        selectedColor: blackColor
                      ),
                      cursorColor: Colors.black,
                      animationDuration: const Duration(milliseconds: 300),
                      enableActiveFill: true,
                      errorAnimationController: errorController,
                      controller: textEditingController,
                      keyboardType: TextInputType.number,
                      boxShadows: const [
                        BoxShadow(
                          offset: Offset(0, 1),
                          color: Colors.black12,
                          blurRadius: 10,
                        )
                      ],
                      onCompleted: (v) {
                        debugPrint("Completed");
                      },
// onTap: () {
//   print("Pressed");
// },
                      onChanged: (value) {
                        debugPrint(value);
                        setState(() {
                          currentText = value;
                        });
                      },
                      beforeTextPaste: (text) {
                        debugPrint("Allowing to paste $text");
//if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
//but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                CustomButton8(text: 'Submit', onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>  HomeView()));
                }),
                const SizedBox(
                  height: 20,
                ),
                Center(child: Text('Send Code in 00:21', style: AppTextStyles.label16600BTC,))

              ],
            ),
          ),
        ),
      );
    }
  }
}
//
// class PinCodeVerificationScreen extends StatefulWidget {
// const PinCodeVerificationScreen({
// Key? key,
// this.phoneNumber,
// }) : super(key: key);
//
// final String? phoneNumber;
//
// @override
// State<PinCodeVerificationScreen> createState() =>
// _PinCodeVerificationScreenState();
// }
//
// class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
// TextEditingController textEditingController = TextEditingController();
// // ..text = "123456";
//
// // ignore: close_sinks
// StreamController<ErrorAnimationType>? errorController;
//
// bool hasError = false;
// String currentText = "";
// final formKey = GlobalKey<FormState>();
//
// @override
// void initState() {
// errorController = StreamController<ErrorAnimationType>();
// super.initState();
// }
//
// @override
// void dispose() {
// errorController!.close();
//
// super.dispose();
// }
//
// // snackBar Widget
// snackBar(String? message) {
// return ScaffoldMessenger.of(context).showSnackBar(
// SnackBar(
// content: Text(message!),
// duration: const Duration(seconds: 2),
// ),
// );
// }
//
// @override
// Widget build(BuildContext context) {
// return Scaffold(
// backgroundColor: primaryColor,
// body: GestureDetector(
// onTap: () {},
// child: SizedBox(
// height: MediaQuery.of(context).size.height,
// width: MediaQuery.of(context).size.width,
// child: ListView(
// children: <Widget>[
// const SizedBox(height: 30),
// SizedBox(
// height: MediaQuery.of(context).size.height / 3,
// child: ClipRRect(
// borderRadius: BorderRadius.circular(30),
// child: Image.asset(logo),
// ),
// ),
// const SizedBox(height: 8),
// const Padding(
// padding: EdgeInsets.symmetric(vertical: 8.0),
// child: Text(
// 'Phone Number Verification',
// style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
// textAlign: TextAlign.center,
// ),
// ),
// Padding(
// padding:
// const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
// child: RichText(
// text: TextSpan(
// text: "Enter the code sent to ",
// children: [
// TextSpan(
// text: "${widget.phoneNumber}",
// style: const TextStyle(
// color: Colors.black,
// fontWeight: FontWeight.bold,
// fontSize: 15,
// ),
// ),
// ],
// style: const TextStyle(
// color: Colors.black54,
// fontSize: 15,
// ),
// ),
// textAlign: TextAlign.center,
// ),
// ),
// const SizedBox(
// height: 20,
// ),
// Form(
// key: formKey,
// child: Padding(
// padding: const EdgeInsets.symmetric(
// vertical: 8.0,
// horizontal: 30,
// ),
// child: PinCodeTextField(
// appContext: context,
// pastedTextStyle: TextStyle(
// color: Colors.green.shade600,
// fontWeight: FontWeight.bold,
// ),
// length: 6,
// obscureText: true,
// obscuringCharacter: '*',
// obscuringWidget: const FlutterLogo(
// size: 24,
// ),
// blinkWhenObscuring: true,
// animationType: AnimationType.fade,
// validator: (v) {
// if (v!.length < 3) {
// return "I'm from validator";
// } else {
// return null;
// }
// },
// pinTheme: PinTheme(
// shape: PinCodeFieldShape.box,
// borderRadius: BorderRadius.circular(5),
// fieldHeight: 50,
// fieldWidth: 40,
// activeFillColor: Colors.white,
// ),
// cursorColor: Colors.black,
// animationDuration: const Duration(milliseconds: 300),
// enableActiveFill: true,
// errorAnimationController: errorController,
// controller: textEditingController,
// keyboardType: TextInputType.number,
// boxShadows: const [
// BoxShadow(
// offset: Offset(0, 1),
// color: Colors.black12,
// blurRadius: 10,
// )
// ],
// onCompleted: (v) {
// debugPrint("Completed");
// },
// // onTap: () {
// //   print("Pressed");
// // },
// onChanged: (value) {
// debugPrint(value);
// setState(() {
// currentText = value;
// });
// },
// beforeTextPaste: (text) {
// debugPrint("Allowing to paste $text");
// //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
// //but you can show anything you want here, like your pop up saying wrong paste format or etc
// return true;
// },
// ),
// ),
// ),
// Padding(
// padding: const EdgeInsets.symmetric(horizontal: 30.0),
// child: Text(
// hasError ? "*Please fill up all the cells properly" : "",
// style: const TextStyle(
// color: Colors.red,
// fontSize: 12,
// fontWeight: FontWeight.w400,
// ),
// ),
// ),
// const SizedBox(
// height: 20,
// ),
// Row(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// const Text(
// "Didn't receive the code? ",
// style: TextStyle(color: Colors.black54, fontSize: 15),
// ),
// TextButton(
// onPressed: () => snackBar("OTP resend!!"),
// child: const Text(
// "RESEND",
// style: TextStyle(
// color: Color(0xFF91D3B3),
// fontWeight: FontWeight.bold,
// fontSize: 16,
// ),
// ),
// )
// ],
// ),
// const SizedBox(
// height: 14,
// ),
// Container(
// margin:
// const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
// child: ButtonTheme(
// height: 50,
// child: TextButton(
// onPressed: () {
// formKey.currentState!.validate();
// // conditions for validating
// if (currentText.length != 6 || currentText != "123456") {
// errorController!.add(ErrorAnimationType
//     .shake); // Triggering error shake animation
// setState(() => hasError = true);
// } else {
// setState(
// () {
// hasError = false;
// snackBar("OTP Verified!!");
// },
// );
// }
// },
// child: Center(
// child: Text(
// "VERIFY".toUpperCase(),
// style: const TextStyle(
// color: Colors.white,
// fontSize: 18,
// fontWeight: FontWeight.bold,
// ),
// ),
// ),
// ),
// ),
// decoration: BoxDecoration(
// color: Colors.green.shade300,
// borderRadius: BorderRadius.circular(5),
// boxShadow: [
// BoxShadow(
// color: Colors.green.shade200,
// offset: const Offset(1, -2),
// blurRadius: 5),
// BoxShadow(
// color: Colors.green.shade200,
// offset: const Offset(-1, 2),
// blurRadius: 5)
// ]),
// ),
// const SizedBox(
// height: 16,
// ),
// Row(
// mainAxisAlignment: MainAxisAlignment.center,
// children: <Widget>[
// Flexible(
// child: TextButton(
// child: const Text("Clear"),
// onPressed: () {
// textEditingController.clear();
// },
// ),
// ),
// Flexible(
// child: TextButton(
// child: const Text("Set Text"),
// onPressed: () {
// setState(() {
// textEditingController.text = "123456";
// });
// },
// ),
// ),
// ],
// )
// ],
// ),
// ),
// ),
// );
// }
// }