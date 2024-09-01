import 'package:benchmark_estimate/utils/constants/MySize.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_path.dart';
import '../../../utils/constants/textStyles.dart';

class OrderHistoryView extends StatelessWidget {
  const OrderHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return  Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        title: const Text(
          'Payment History',
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

                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Payments')
                        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                        .orderBy('id', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Icon(Icons.error);
                      } else if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                        // Display the image when there's no data
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 200),
                            SvgPicture.asset(noOrders),
                            SizedBox(height: MySize.size20),
                            const Text('No Payments Yet', style: AppTextStyles.label14600P),
                          ],
                        );
                      } else {
                        // Display the list of payments when there is data
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            var snap = snapshot.data!.docs[index];
                            return Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: MySize.size10),
                                  child: ListTile(
                                    title: Padding(
                                      padding: EdgeInsets.symmetric(vertical: MySize.size6),
                                      child: Text(
                                        snap['projectName'],
                                        style: AppTextStyles.label14700B,
                                      ),
                                    ),
                                    trailing: Text(
                                      "\$ ${snap['price']}",
                                      style: AppTextStyles.label12500BTC,
                                    ),
                                    subtitle: Text(
                                      snap['id'],
                                      style: AppTextStyles.label12400BTC,
                                    ),
                                  ),
                                ),
                                Divider(),
                              ],
                            );
                          },
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),

    );
  }
}
