import 'package:benchmark_estimate/utils/constants/MySize.dart';
import 'package:benchmark_estimate/utils/constants/colors.dart';
import 'package:benchmark_estimate/utils/constants/image_path.dart';
import 'package:benchmark_estimate/utils/constants/textStyles.dart';
import 'package:benchmark_estimate/utils/custom_widgets/custom_textfield.dart';
import 'package:benchmark_estimate/view/auth/login_view.dart';
import 'package:benchmark_estimate/view/auth/phone_verification_view.dart';
import 'package:benchmark_estimate/view/home/home_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../utils/common_function.dart';
import '../../utils/custom_widgets/circular_container.dart';
import '../../utils/custom_widgets/custom_button.dart';
import '../../utils/custom_widgets/loader_view.dart';
import '../../utils/utils.dart';
import '../../view_model/firebase/auth_services.dart';
import '../../view_model/provider/loader_view_provider.dart';
import '../../view_model/provider/obsecure_provider.dart';
import 'email_verification.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final AuthServices _authService = AuthServices();
  final GlobalKey<FormState> _signUpKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return  Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body:  kIsWeb && MySize.safeWidth > 700?
          Row(
              children: [
              Container(
              color: backgroundColor,
              height: MySize.screenHeight,
              width: MediaQuery.of(context).size.width *0.5,
              child: Padding(
                padding:  EdgeInsets.all(MySize.size250),
                child: SvgPicture.asset(logoSec),
              )),
          SizedBox(
            width: MediaQuery.of(context).size.width *0.5,

            child: SingleChildScrollView(
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: MySize.size60),
                child: Form(
                  key: _signUpKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MySize.size20,
                      ),
                      SvgPicture.asset(logoSec),
                      SizedBox(
                        height: MySize.size60,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Create Your Account',
                          style: TextStyle(
                              fontSize: MySize.size20, fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        height: MySize.size24,
                      ),
                      CustomTextField13(
                        controller: _userNameController,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SvgPicture.asset(user),
                        ),
                        hintText: 'Username',
                        fillColor: backgroundColor,
                      ),
                      SizedBox(
                        height: MySize.size20,
                      ),
                      CustomTextField13(
                        controller: _nameController,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SvgPicture.asset(user),
                        ),
                        hintText: 'Full Name',
                        fillColor: backgroundColor,
                      ),
                      SizedBox(
                        height: MySize.size20,
                      ),
                      CustomTextField13(
                        controller: _emailController,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SvgPicture.asset(email),
                        ),
                        hintText: 'Enter Your Email',
                        fillColor: backgroundColor,
                      ),
                      SizedBox(
                        height: MySize.size20,
                      ),
                      CustomTextField13(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SvgPicture.asset(phone),
                        ),
                        hintText: 'Enter Your Phone Number',
                        fillColor: backgroundColor,
                      ),
                      SizedBox(
                        height: MySize.size20,
                      ),
                      Consumer<ObscureProvider>(
                        builder: (BuildContext context, ObscureProvider value, Widget? child) {
                          return  CustomTextField13(
                            controller: _passwordController,
                            prefixIcon: Padding(
                              padding:  EdgeInsets.all(MySize.size15),
                              child: SvgPicture.asset(password),
                            ),
                            hintText: 'Password',
                            obscureText: value.obsecureText,
                            fillColor: backgroundColor,
                            sufixIcon: Padding(
                              padding:  EdgeInsets.all(MySize.size15),
                              child: GestureDetector(
                                onTap: (){
                                  value.setObsecureText(!value.obsecureText);
                                },
                                child: SvgPicture.asset(obscure),
                              ),
                            ),
                          );

                        },
                      ),

                      SizedBox(
                        height: MySize.size20,
                      ),
                      CustomButton8(text: 'Register', onPressed: (){
                        _submitForm();
                      }),
                      SizedBox(
                        height: MySize.size15,
                      ),
                      const Row(
                        children: <Widget>[
                          Expanded(
                            child: Divider(
                              color: Color(0xffC2C3CB),
                              height: 1.5,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'OR',
                              style: TextStyle(
                                // color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Color(0xffC2C3CB),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MySize.size20,
                      ),
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: MySize.size40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircularContainer(
                              color: Color(0xff4286F5),
                              image: google,
                            ),
                            CircularContainer(
                              color: Color(0xff4167B2),
                              image: facebook,
                            ),

                            CircularContainer(
                              color: blackColor,
                              image: apple,
                            ),

                          ],
                        ),
                      ),
                      SizedBox(
                        height: MySize.size20,
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Already Have An Account? ',
                          style: const TextStyle(
                            color: Color(0xff97A0B2),
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: '  Sign in',
                              style: const TextStyle(
                                fontSize: 14,

                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                              ),
                              // Add a tap recognizer to handle the sign-up action
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pop(context);
                                  // Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginView()));
                                  // Implement the sign-up action here
                                  print('Sign up tapped');
                                },
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          )
                ]):

          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: MySize.size20),
                child: Form(
                  key: _signUpKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MySize.size20,
                      ),
                      SvgPicture.asset(logoSec),
                      SizedBox(
                        height: MySize.size60,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Create Your Account',
                          style: AppTextStyles.heading
                        ),
                      ),
                      SizedBox(
                        height: MySize.size18,
                      ),
                      CustomTextField13(
                        keyboardType: TextInputType.name,
                        controller: _userNameController,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SvgPicture.asset(user),
                        ),
                        hintText: 'Username',
                        fillColor: backgroundColor,
                        validator:   (value) {
                return CommonFunctions.validateTextField(value,context,'userName');
                },
                      ),
                      SizedBox(
                        height: MySize.size20,
                      ),
                      CustomTextField13(
                        controller: _nameController,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SvgPicture.asset(user),
                        ),
                        hintText: 'Full Name',
                        fillColor: backgroundColor,
                        validator: (value) {
                          return CommonFunctions.validateTextField(value,context,'name');
                        },
                      ),
                      SizedBox(
                        height: MySize.size20,
                      ),
                      CustomTextField13(
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SvgPicture.asset(email),
                        ),
                        hintText: 'Enter Your Email',
                        fillColor: backgroundColor,
                        validator: (value) {
                          return CommonFunctions.validateTextField(value,context,'email');
                        },
                      ),
                      SizedBox(
                        height: MySize.size20,
                      ),
                      CustomTextField13(
                        keyboardType: TextInputType.phone,
                        controller: _phoneController,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SvgPicture.asset(phone),
                        ),
                        hintText: 'Enter Your Phone Number',
                        fillColor: backgroundColor,
                        validator: (value) {
                          return CommonFunctions.validateTextField(value,context,'phone');
                        },
                      ),
                      SizedBox(
                        height: MySize.size20,
                      ),
                      Consumer<ObscureProvider>(
                        builder: (BuildContext context, ObscureProvider value, Widget? child) {
                          return  CustomTextField13(
                            controller: _passwordController,
                            prefixIcon: Padding(
                              padding:  EdgeInsets.all(MySize.size15),
                              child: SvgPicture.asset(password),
                            ),
                            hintText: 'Password',
                            obscureText: value.obsecureText,
                            fillColor: backgroundColor,
                            sufixIcon: Padding(
                              padding:  EdgeInsets.all(MySize.size15),
                              child: GestureDetector(
                                onTap: (){
                                  value.setObsecureText(!value.obsecureText);
                                },
                                child: SvgPicture.asset(obscure),
                              ),
                            ),
                            validator: (value) {
                              return CommonFunctions.validateTextField(value,context,'password');
                            },
                          );

                        },
                      ),

                      SizedBox(
                        height: MySize.size20,
                      ),
                      CustomButton8(text: 'Register', onPressed: (){
                        _submitForm();
                      }),
                      SizedBox(
                        height: MySize.size15,
                      ),
                      const Row(
                        children: <Widget>[
                          Expanded(
                            child: Divider(
                              color: Color(0xffC2C3CB),
                              height: 1.5,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'OR',
                              style: AppTextStyles.label12600B
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Color(0xffC2C3CB),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MySize.size20,
                      ),
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: MySize.size40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircularContainer(
                              color: Color(0xff4286F5),
                              image: google,
                            ),
                            CircularContainer(
                              color: Color(0xff4167B2),
                              image: facebook,
                            ),

                            CircularContainer(
                              color: blackColor,
                              image: apple,
                            ),

                          ],
                        ),
                      ),
                      SizedBox(
                        height: MySize.size20,
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Already Have An Account? ',
                          style: AppTextStyles.label14400BTC2,
                          children: <TextSpan>[
                            TextSpan(
                              text: ' Sign in',
                              style:AppTextStyles.label14600P,
                              // Add a tap recognizer to handle the sign-up action
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                Navigator.pop(context);
                                  // Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginView()));
                                  // Implement the sign-up action here
                                  print('Sign up tapped');
                                },
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

// this a reusable widget used for showing loading
        const LoaderView(),
      ],
    );
  }

  void isLogin() {
    //initializing provider for showing loading when needed
    final obj = Provider.of<LoaderViewProvider>(context,
        listen: false);

    obj.changeShowLoaderValue(false);

    //verifying phone number
    _auth
        .verifyPhoneNumber(
        phoneNumber: _phoneController.text,
        verificationCompleted: (_) {},
        verificationFailed: (e) {
          Utils.toastMessage(e.toString());
          print(e.toString());
          obj.changeShowLoaderValue(false);
        },
        codeSent: (String verification, int? token) {
          print(_phoneController);
          obj.changeShowLoaderValue(false);

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PhoneVerificationView(
                    verificationId: verification,
                    phoneNumber: _phoneController.text,
                  )));
          if (kDebugMode) {
            print(_phoneController);
          }
        },
        codeAutoRetrievalTimeout: (e) {
          obj.changeShowLoaderValue(false);

          if (kDebugMode) {
            print(e.toString());
          }
        })
        .onError((error, stackTrace) {
      Utils.toastMessage(error.toString());
      obj.changeShowLoaderValue(false);
    });
  }

  // void _submitForm() async {
  //   final obj = Provider.of<LoaderViewProvider>(context,
  //       listen: false);
  //
  //   if (_signUpKey.currentState!.validate()) {
  //     // Form is valid, perform login or other actions
  //     String email = _emailController.text;
  //     String name = _nameController.text;
  //     String phonee = _phoneController.text;
  //
  //     // String phonee = Ccode+phoneController.text;
  //
  //     String password = _passwordController.text;
  //     // bool? isUsed = await isPhoneNumberUsed(phonee);
  //     // bool? isUsedOwner = await isPhoneNumberUsedOwner(phonee);
  //
  //     //this line of code starts the loading
  //     obj.changeShowLoaderValue(true);
  //
  //     // if(isUsed == false && isUsedOwner == false){
  //       final UserCredential? userCredential =
  //       await _authService.signUpWithEmail(context, email, password);
  //       if (userCredential != null) {
  //         _authService.setData(email, name, 'email', phonee,password ).then((value) {
  //           obj.changeShowLoaderValue(false);
  //           // isLogin();
  //           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeView()));
  //         });
  //         // Authentication successful, navigate to the next screen
  //       } else {
  //         obj.changeShowLoaderValue(false);
  //
  //         //
  //         print('Authentication failed, display an error message');
  //
  //         // ...
  //       }
  //     // }else{
  //     //   obj.changeShowLoaderValue(false);
  //     //   Utils.toastMessage('Phone number is already used');
  //     // }
  //
  //     // Perform login logic here
  //     print('Login with Email: $email, Password: $password');
  //   }
  // }
  void _submitForm() async {
    final obj = Provider.of<LoaderViewProvider>(context, listen: false);

    if (_signUpKey.currentState!.validate()) {
      String email = _emailController.text;
      String name = _nameController.text;
      String phonee = _phoneController.text;
      String password = _passwordController.text;

      obj.changeShowLoaderValue(true);

      final UserCredential? userCredential = await _authService.signUpWithEmail(context, email, password);
      if (userCredential != null) {
        _authService.setData(email, name, 'email', phonee, password).then((value) {
          obj.changeShowLoaderValue(false);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EmailVerificationScreen()));
        });
      } else {
        obj.changeShowLoaderValue(false);
        print('Authentication failed, display an error message');
      }
    }
  }

}
