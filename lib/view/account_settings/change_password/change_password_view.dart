import 'package:benchmark_estimate/utils/constants/image_path.dart';
import 'package:benchmark_estimate/utils/custom_widgets/custom_button.dart';
import 'package:benchmark_estimate/utils/custom_widgets/loader_view.dart';
import 'package:benchmark_estimate/utils/utils.dart';
import 'package:benchmark_estimate/view_model/firebase/auth_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../utils/constants/MySize.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/textStyles.dart';
import '../../../utils/custom_widgets/custom_textfield.dart';
import '../../../view_model/provider/loader_view_provider.dart';

class ChangePasswordView extends StatelessWidget {
   ChangePasswordView({super.key});
  TextEditingController oldPassController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return Stack(
      children: [
        Scaffold(
          backgroundColor: whiteColor,
          appBar: AppBar(
            backgroundColor: whiteColor,
            title: const Text('Change Password', style: AppTextStyles.label14600ATC,),
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
                      : EdgeInsets.all(MySize.size20),        child: Column(
                    children: [
                      CustomTextField13(
                        controller: oldPassController,
                        prefixIcon: Padding(
                          padding:  EdgeInsets.all(MySize.size15),
                          child: SvgPicture.asset(password),
                        ),
                        hintText: 'Current Password',
                        fillColor: whiteColor,
                      ),
                      SizedBox(
                        height: MySize.size20,
                      ),
                      CustomTextField13(
                        controller: newPassController,
                        prefixIcon: Padding(
                          padding:  EdgeInsets.all(MySize.size15),
                          child: SvgPicture.asset(password),
                        ),
                        hintText: 'New Password',
                        fillColor: whiteColor,
                      ),
                      SizedBox(
                        height: MySize.size20,
                      ),
                      CustomTextField13(
                        controller: confirmPassController,
                        prefixIcon: Padding(
                          padding:  EdgeInsets.all(MySize.size15),
                          child: SvgPicture.asset(password),
                        ),
                        hintText: 'Confirm Password',
                        fillColor: whiteColor,
                      ),
                      SizedBox(
                        height: MySize.size50,
                      ),
                      CustomButton8(
                          text: 'Update',
                          onPressed: () async {
                            final loadingProvider = Provider.of<LoaderViewProvider>(context, listen: false);
                            loadingProvider.changeShowLoaderValue(true);

                            if (oldPassController.text.isEmpty || newPassController.text.isEmpty || confirmPassController.text.isEmpty) {
                              Utils.toastMessage('Please enter all passwords');
                              loadingProvider.changeShowLoaderValue(false);
                            } else if (newPassController.text == confirmPassController.text) {
                              try {
                                AuthServices authServices = AuthServices();
                                await authServices.updatePassword(oldPassController.text, newPassController.text);

                                newPassController.clear();
                                oldPassController.clear();
                                confirmPassController.clear();
                                Utils.toastMessage('Password Updated');
                              } catch (error) {
                                Utils.toastMessage(error.toString());
                              } finally {
                                loadingProvider.changeShowLoaderValue(false);
                              }
                            } else {
                              Utils.toastMessage('The passwords do not match');
                              loadingProvider.changeShowLoaderValue(false);
                            }
                          }
                      )                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const LoaderView()
      ],
    );
  }
}
