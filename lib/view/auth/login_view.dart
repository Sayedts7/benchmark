

import 'package:benchmark_estimate/utils/constants/MySize.dart';
import 'package:benchmark_estimate/utils/constants/colors.dart';
import 'package:benchmark_estimate/utils/constants/image_path.dart';
import 'package:benchmark_estimate/utils/constants/textStyles.dart';
import 'package:benchmark_estimate/utils/custom_widgets/circular_container.dart';
import 'package:benchmark_estimate/utils/custom_widgets/custom_button.dart';
import 'package:benchmark_estimate/utils/custom_widgets/custom_textfield.dart';
import 'package:benchmark_estimate/utils/custom_widgets/loader_view.dart';
import 'package:benchmark_estimate/view/auth/forgot_password_view.dart';
import 'package:benchmark_estimate/view/auth/phone_verification_view.dart';
import 'package:benchmark_estimate/view/auth/signup_view.dart';
import 'package:benchmark_estimate/view/home/home_view.dart';
import 'package:benchmark_estimate/view_model/firebase/auth_services.dart';
import 'package:benchmark_estimate/view_model/provider/checkbox_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/common_function.dart';
import '../../utils/utils.dart';
import '../../view_model/provider/loader_view_provider.dart';
import '../../view_model/provider/obsecure_provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool isChecked = false;
  final AuthServices _authService = AuthServices();


  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loadingProvider = Provider.of<LoaderViewProvider>(context,listen: false);
    MySize().init(context);
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body: kIsWeb && MySize.screenWidth > 700?
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
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width *0.5,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: MySize.size60),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                height: MySize.size20,
                              ),
                              SvgPicture.asset(logoSec),
                              SizedBox(
                                height: MySize.size60,
                              ),
                               const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Sign in',
                                  style:  AppTextStyles.heading
                                ),
                              ),
                              SizedBox(
                                height: MySize.size24,
                              ),
                              CustomTextField13(
                                controller: _emailController,
                                prefixIcon: Padding(
                                  padding:  EdgeInsets.all(MySize.size15),
                                  child: SvgPicture.asset(email),
                                ),
                                hintText: 'Enter Your Email',
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
                                height: MySize.size15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Consumer<CheckBoxProvider>(

                                        builder: (BuildContext context, CheckBoxProvider value, Widget? child) {
                                          return GestureDetector(
                                            onTap: () {
                                              value.updateCheckBox(!value.isChecked);

                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                // shape: BoxShape.circle,
                                                borderRadius: BorderRadius.circular(3),
                                                border: Border.all(
                                                  color: value.isChecked ? primaryColor : Colors.grey,
                                                  width: 2.0,
                                                ),
                                                color: value.isChecked? backgroundColor : Colors.transparent,
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(2.0),
                                                child: value.isChecked
                                                    ? const Icon(
                                                  Icons.check,
                                                  size: 14.0,
                                                  color: primaryColor,
                                                )
                                                    : Container(
                                                  width: 14.0,
                                                  height: 14.0,
                                                  decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.transparent,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },

                                      ),
                                      SizedBox(width: MySize.size15,),
                                       const Text('Remember me', style: AppTextStyles.label12400BTC),
                                    ],
                                  ),
                                  InkWell(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const ForgotPasswordView()));
                                      },
                                      child:  const Text('Forgot Password?',
                                        style:  AppTextStyles.label12400BTC)),

                                ],
                              ),
                              SizedBox(
                                height: MySize.size20,
                              ),
                              CustomButton8(text: 'Sign in', onPressed: (){
                                _submitForm();
                                // Navigator.push(context, MaterialPageRoute(builder: (context)=>  PhoneVerificationView()));

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
                                      style:  AppTextStyles.label12600B,
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
                                    InkWell(
                                      onTap: (){
                                        AuthServices().handleGoogleSignIn(context);
                                      },
                                      child: CircularContainer(
                                        color: const Color(0xff4286F5),
                                        image: google,
                                      ),
                                    ),
                                    CircularContainer(
                                      color: const Color(0xff4167B2),
                                      image: facebook,
                                    ),

                                    CircularContainer(
                                      color: blackColor,
                                      image: apple,
                                    ),

                                  ],
                                ),
                              ),
                              SizedBox(height: MySize.size50,),
                              RichText(
                                text: TextSpan(
                                  text: 'Don\'t have an account? ',
                                  style:  AppTextStyles.label14400BTC2,

                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '  Sign up',
                                      style: AppTextStyles.label14600P,

                                      // Add a tap recognizer to handle the sign-up action
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=> const SignUpView()));
                                          // Implement the sign-up action here
                                          print('Sign up tapped');
                                        },
                                    ),
                                  ],
                                ),
                              )

                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ):
            SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: MySize.size20),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
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
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Sign in',
                            style:  AppTextStyles.heading
                        ),
                      ),
                      SizedBox(
                        height: MySize.size24,
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
                        validator: (value) => CommonFunctions.validateTextField(
                            value, context, 'email'),
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
                            validator: (value) =>
                                CommonFunctions.validateTextField(
                                    value, context, 'password'),
                          );
                  
                        },
                      ),
                  
                      SizedBox(
                        height: MySize.size15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  final SharedPreferences prefs = await SharedPreferences.getInstance();

                                  setState(() {
                                    isChecked = !isChecked;
                                  });
                                  if(isChecked == true){
                                    prefs.setBool('rememberMe', true);
                                  }else{
                                    prefs.setBool('rememberMe', false);

                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    // shape: BoxShape.circle,
                                    borderRadius: BorderRadius.circular(3),
                                    border: Border.all(
                                      color: isChecked ? primaryColor : Colors.grey,
                                      width: 2.0,
                                    ),
                                    color: isChecked? backgroundColor : Colors.transparent,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: isChecked
                                        ? const Icon(
                                            Icons.check,
                                            size: 14.0,
                                            color: primaryColor,
                                          )
                                        : Container(
                                            width: 14.0,
                                            height: 14.0,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.transparent,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                              SizedBox(width: MySize.size15,),
                               const Text('Remember me',
                                   style:  AppTextStyles.label12400B),
                            ],
                          ),
                          InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> const ForgotPasswordView()));
                              },
                              child:  const Text('Forgot Password?',
                                style:  AppTextStyles.label12400BTC
                              )),
                  
                        ],
                      ),
                      SizedBox(
                        height: MySize.size20,
                      ),
                      CustomButton8(text: 'Sign in', onPressed: (){
                        //used this method to keep all login functionality out of widget tree
                        _submitForm();
                        // Navigator.push(context, MaterialPageRoute(builder: (context)=>  PhoneVerificationView()));
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
                              style:  AppTextStyles.label12600B
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
                            InkWell(
                              onTap: ()async{
                                AuthServices().handleGoogleSignIn(context);



                              },
                              child: CircularContainer(
                                color: const Color(0xff4286F5),
                                image: google,
                              ),
                            ),
                            CircularContainer(
                              color: const Color(0xff4167B2),
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
                        height: MySize.screenHeight * 0.25,
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Don\'t have an account? ',
                          style:  AppTextStyles.label14400BTC2,
                          children: <TextSpan>[
                            TextSpan(
                              text: ' Sign up',
                              style: AppTextStyles.label14600P,
                  
                              // Add a tap recognizer to handle the sign-up action
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const SignUpView()));
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
        const LoaderView()
      ],
    );
  }
  void _submitForm() async {
    final obj = Provider.of<LoaderViewProvider>(context, listen: false);

    if (_formKey.currentState!.validate()) {
      // Form is valid, perform login or other actions
      String email = _emailController.text;
      String password = _passwordController.text;
      bool isCOnnected;
      if(kIsWeb){
         isCOnnected =true;
      }else{
        isCOnnected = await Utils.checkInternetConnection();
      }
      //this line of code starts the loading
      obj.changeShowLoaderValue(true);
      if (isCOnnected == true) {
        // String? userType = await getUserType(email);
        // String? userStatus= await getUserStatus(email);
        // bool? userDeleteStatus = await getUserDeleteStatus(email);

              try {
                obj.changeShowLoaderValue(true);

                final UserCredential? userCredential =
                await _authService.signInWithEmail(context, email, password);
                if (userCredential != null) {
                  // String? phoneNull = await getPhone();

                  obj.changeShowLoaderValue(false);
                  // if(phoneNull == ''){
                  //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> SignInWithPhone())) ;
                  // }else{
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => HomeView()));
                  // }
                  // Authentication successful, navigate to the next screen


                } else {
                  obj.changeShowLoaderValue(false);
                }
              } catch (e) {
                obj.changeShowLoaderValue(false);
                Utils.toastMessage(e.toString());
                print('Exception is here bro: $e, Type: ${e.runtimeType}');


              }


      } else {
        obj.changeShowLoaderValue(false);
        //show the dialog if internet is not available
        CommonFunctions.showNoInternetDialog(context);
      }

      // } else {
      //   //
      //   print('Authentication failed, display an error message');
      //
      //   // ...
      //
      // }

      // Perform login logic here
      if (kDebugMode) {
        print('Login with Email: $email, Password: $password');
      }
    }
  }

}
