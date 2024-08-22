import 'package:benchmark_estimate/utils/constants/MySize.dart';
import 'package:benchmark_estimate/utils/constants/colors.dart';
import 'package:benchmark_estimate/utils/constants/image_path.dart';
import 'package:benchmark_estimate/utils/custom_widgets/custom_button.dart';
import 'package:benchmark_estimate/utils/custom_widgets/reusable_container.dart';
import 'package:benchmark_estimate/view/account_settings/change_password/change_password_view.dart';
import 'package:benchmark_estimate/view/account_settings/my_profile/my_profile_view.dart';
import 'package:benchmark_estimate/view/account_settings/order_history/order_history_view.dart';
import 'package:benchmark_estimate/view/auth/login_view.dart';
import 'package:benchmark_estimate/view_model/firebase/auth_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/constants/textStyles.dart';

class AccountSettingsView extends StatelessWidget {
  const AccountSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        title: const Text(
          'Account Settings',
          style: AppTextStyles.label14600ATC,
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 0.5,
              decoration: const BoxDecoration(
                color: secondaryColor,

                boxShadow: [
                  BoxShadow(
                    // offset: Offset(3 , 3),
                      color: Colors.black12,
                      blurRadius: 2,
                      spreadRadius: 2
                  )
                ],
              ),
            ),
            Padding(
              padding: kIsWeb
                  ? EdgeInsets.symmetric(
                      vertical: MySize.size20, horizontal: MySize.screenWidth * 0.2)
                  : EdgeInsets.all(MySize.size20),
              child: Column(
                children: [
                  AccountReusableContainer(
                    ontap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MyProfileView()));
                    },
                    height: kIsWeb ? MySize.size80 : MySize.size50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              user,
                              color: bodyTextColor,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              'My Pofile',
                              style: AppTextStyles.label14500BTC,
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: bodyTextColor,
                          size: MySize.size20,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MySize.size16,
                  ),
                  AccountReusableContainer(
                    ontap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => OrderHistoryView()));
                    },
                    height: kIsWeb ? MySize.size80 : MySize.size50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              user,
                              color: bodyTextColor,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              'Order History',
                              style: AppTextStyles.label14500BTC,
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: bodyTextColor,
                          size: MySize.size20,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MySize.size16,
                  ),
                  AccountReusableContainer(
                    ontap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangePasswordView()));
                    },
                    height: kIsWeb ? MySize.size80 : MySize.size50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              password,
                              color: bodyTextColor,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              'Change Password',
                              style: AppTextStyles.label14500BTC,
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: bodyTextColor,
                          size: MySize.size20,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MySize.size16,
                  ),
                  AccountReusableContainer(
                    ontap: () {
                      showCustomDialog(context);
                    },
                    height: kIsWeb ? MySize.size80 : MySize.size50,
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          logout,
                          color: bodyTextColor,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Logout',
                          style: AppTextStyles.label14500BTC,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Container(
              width: MySize.size335,
              // height: 392,
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.asset(
                    logoutImage, // Replace with your image URL
                    width: MySize.size150,
                    height: MySize.size150,
                  ),
                  Text(
                    'Logout',
                    style: TextStyle(
                        fontSize: MySize.size20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: MySize.size8),
                  Text(
                    'Are you sure you wan to logout of your account?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: MySize.size16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      // InkWell(
                      //   onTap: (){
                      //
                      //   },
                      //   child: Container(
                      //     width: 120,
                      //     height: 40,
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(10),
                      //       border: Border.all(
                      //         color:  bodyTextColor,
                      //         width: 1,
                      //       ),
                      //     ),
                      //     child: Padding(
                      //         padding:  EdgeInsets.all(MySize.size5),
                      //         child:Center(child: Text('Cancel', style: AppTextStyles.label16600BTC,))
                      //     ),
                      //
                      //   ),
                      // ),
                      CustomBorderedButton(
                          width:120,
                          height: 40,
                          text: 'Cancel',
                          onPressed: (){
                        Navigator.of(context).pop();
                      }),
                      CustomButton8(
                        width:120,
                        height: 40,
                        onPressed: () {
                          AuthServices().signOut().then((value) {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginView()));
                          });
                        },
                        text: 'Logout',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
