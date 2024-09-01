import 'package:benchmark_estimate/utils/constants/image_path.dart';
import 'package:benchmark_estimate/utils/custom_widgets/custom_button.dart';
import 'package:benchmark_estimate/utils/custom_widgets/loader_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../utils/constants/MySize.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/textStyles.dart';
import '../../../utils/custom_widgets/custom_textfield.dart';
import '../../../utils/utils.dart';
import '../../../view_model/provider/loader_view_provider.dart';
import '../../../view_model/provider/user_profile_edit _provider.dart';

class MyProfileView extends StatelessWidget {
   MyProfileView({super.key});

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return Stack(
      children: [
        Scaffold(
          backgroundColor: whiteColor,
          appBar: AppBar(
            backgroundColor: whiteColor,
            title: const Text('My profile', style: AppTextStyles.label14600ATC,),
            centerTitle: true,
            automaticallyImplyLeading: true,
            actions: [
              Consumer<UserProfileProvider>(
                builder: (context, provider, _) {
                  return provider.isEditing ?IconButton(onPressed:  provider.toggleEditing, icon: Icon(Icons.close, color: blackColor,)): IconButton(
                    icon: Icon( Icons.edit, color: blackColor,),
                    onPressed:  provider.toggleEditing,
                  );
                },
              ),
            ],
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
                  child:

        Consumer<UserProfileProvider>(
        builder: (context, provider, _) {
          if (provider.name == null || provider.email == null) {
            return CircularProgressIndicator();
          }
          nameController.text = provider.name!;
          emailController.text = provider.email!;

         return Column(
            children: [
              CustomTextField13(
                readOnly: !provider.isEditing,
                controller: nameController,
                prefixIcon: Padding(
                  padding:  EdgeInsets.all(MySize.size15),
                  child: SvgPicture.asset(user),
                ),
                hintText: 'Name',
                fillColor: whiteColor,
                onChanged: (value) => provider.updateName(value),
              ),
              SizedBox(
                height: MySize.size20,
              ),
              CustomTextField13(
                readOnly: true,
                controller: emailController,
                prefixIcon: Padding(
                  padding:  EdgeInsets.all(MySize.size15),
                  child: SvgPicture.asset(user),
                ),
                hintText: 'Email',
                fillColor: whiteColor,
              ),
              SizedBox(
                height: MySize.size120,
              ),
              Consumer<LoaderViewProvider>(
                builder: (context, loadingProvider, child){
                  return Visibility(
                    visible: provider.isEditing,
                    child: CustomButton8(text: 'Update', onPressed: ()async{
                    loadingProvider.changeShowLoaderValue(true);

                    print('0000000000000000222222222222222');
                    await FirebaseFirestore.instance.collection('User').doc(FirebaseAuth.instance.currentUser!.uid).update({
                    'name': provider.name,
                    }).then((value) {
                      provider.toggleEditing();
                    loadingProvider.changeShowLoaderValue(false);

                    Utils.toastMessage('Updated');
                    }).onError((error, stackTrace) {
                    Utils.toastMessage(error.toString());
                    loadingProvider.changeShowLoaderValue(false);



                    }
                    );              }),
                  );
                },
              )
            ],
          );

        }),
                ),
              ],
            ),
          ),
        ),
        LoaderView()
      ],
    );
  }
}
