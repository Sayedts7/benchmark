import 'package:benchmark_estimate/utils/constants/MySize.dart';
import 'package:benchmark_estimate/utils/constants/colors.dart';
import 'package:benchmark_estimate/utils/constants/image_path.dart';
import 'package:benchmark_estimate/utils/custom_widgets/loader_view.dart';
import 'package:benchmark_estimate/utils/utils.dart';
import 'package:benchmark_estimate/view_model/firebase/auth_services.dart';
import 'package:benchmark_estimate/view_model/firebase/firebase_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../utils/common_function.dart';
import '../../utils/constants/textStyles.dart';
import '../../utils/custom_widgets/custom_button.dart';
import '../../utils/custom_widgets/custom_textfield.dart';
import '../../view_model/provider/loader_view_provider.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  AuthServices _authServices = AuthServices();
  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    if (MySize.screenWidth > 700) {
      return Stack(
        children: [
          Scaffold(
            backgroundColor: whiteColor,
          appBar: AppBar(
            centerTitle: true,
            title: SvgPicture.asset(logoSec),
            automaticallyImplyLeading: true,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal:MySize.screenWidth * 0.4, vertical: MySize.screenHeight * 0.2),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Text('Forgot Password', style:  AppTextStyles.heading,),
                    SizedBox(
                      height: MySize.size10,
                    ),
                    Text('To reset your password, provide your account\'s email, and we\'ll send a reset link.',
                      style:              AppTextStyles.label12500BTC,),

                    SizedBox(
                      height: MySize.size20,
                    ),
                    CustomTextField13(
                      controller: emailController,
                      prefixIcon: Padding(
                        padding:  EdgeInsets.all(MySize.size15),
                        child: SvgPicture.asset(email),
                      ),
                      hintText: 'Enter Your Email',
                      fillColor: backgroundColor,
                      validator: (value) {
                        return CommonFunctions.validateTextField(value,context,'email');
                      },
                    ),
                    SizedBox(
                      height: MySize.size40,
                    ),

                    CustomButton8(text: 'Submit', onPressed: (){
                      _submitForm();
                    }),

                  ],
                ),
              ),
            ),
          ),
              ),
        ],
      );
    } else {
      return Stack(
        children: [
          Scaffold(
            backgroundColor: whiteColor,
            appBar: AppBar(
            centerTitle: true,
            title: SvgPicture.asset(logoSec),
            automaticallyImplyLeading: true,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding:  EdgeInsets.all(MySize.size20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MySize.size150,
                    ),
                    Text('Forgot Password',    style:  AppTextStyles.heading,),
                    SizedBox(
                      height: MySize.size10,
                    ),
                    Text('To reset your password, provide your account\'s email, and we\'ll send a reset link.',
                      style: AppTextStyles.label12500BTC,),
                    SizedBox(
                      height: MySize.size20,
                    ),
                    CustomTextField13(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      prefixIcon: Padding(
                        padding:  EdgeInsets.all(MySize.size15),
                        child: SvgPicture.asset(email),
                      ),
                      validator: (value) {
                        return CommonFunctions.validateTextField(value,context,'email');
                      },
                      hintText: 'Enter Your Email',
                      fillColor: backgroundColor,
                    ),
                    SizedBox(
                      height: MySize.size40,
                    ),

                    CustomButton8(text: 'Submit', onPressed: (){
                      _submitForm();
                    }),

                  ],
                ),
              ),
            ),
          ),
              ),
          const LoaderView()

        ],
      );
    }
  }
  void _submitForm() async {
    //initializing provider for showing loading when needed
    final obj = Provider.of<LoaderViewProvider>(context, listen: false);

    if (_formKey.currentState!.validate()) {
      // Form is valid, perform login or other actions
      String email = emailController.text;
      //this line of code starts the loading
      obj.changeShowLoaderValue(true);
      bool isConnected;
      if(kIsWeb){
        isConnected = true;
      }else{
        isConnected = await Utils.checkInternetConnection();
      }
      if (isConnected == true) {

        bool? emailExist = await FirestoreService().checkEmailExists(email);
        Utils.toastMessage(emailExist.toString());

        //check if user email is valid
        if (emailExist == true) {


          //code for reset password
          _authServices.resetPassword(emailController.text).then((value) {
            //this line of code closes the loading
            obj.changeShowLoaderValue(false);
            Utils.toastMessage('Password reset email sent');
          });
        } else {
          obj.changeShowLoaderValue(false);

          //check if email is invalid or connected with owner account
          // bool? userType = await getOwner(email);
          Utils.toastMessage('Please enter valid email');


        }
      } else {
        // showNoInternetDialog(context);
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
        print('Login with Email: $email');
      }
    }
  }

}
