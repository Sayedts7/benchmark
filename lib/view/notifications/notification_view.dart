import 'package:benchmark_estimate/view/chat_screen/chat_screen_view.dart';
import 'package:benchmark_estimate/view/project_status/project_submitted.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/constants/MySize.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/image_path.dart';
import '../../utils/constants/textStyles.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    MySize().init(context);

    // Mark notifications as read when the view is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FirebaseFirestore.instance
          .collection('Notifications')
          .where('toId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('read', isEqualTo: false)
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.update({'read': true});
        }
      });
    });

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        title: Text(
          'Notification',
          style: AppTextStyles.label14600ATC,
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Notifications')
              .where('toId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .orderBy('date', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if(snapshot.data!.docs.isNotEmpty){
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 0.5,
                        decoration: const BoxDecoration(
                          color: secondaryColor,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 2,
                                spreadRadius: 2)
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: MySize.size5),
                        child: Column(
                          children: [
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.docs.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  var snap = snapshot.data!.docs[index];
                                  bool isUnread = !snap['read'];
                                  return Column(
                                    children: [
                                      InkWell(
                                        onTap:(){
                                          if(snap['title'] == 'New Message'){
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatScreen(projectId: snap['projectId'])));
                                          }else{
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=> ProjectSubmittedView(docId:  snap['projectId'],)));

                                          }
                                        },
                                        child: Container(
                                          color: isUnread ? appColor.withOpacity(0.1) : whiteColor,
                                          width: MySize.screenWidth,
                                          child: Padding(
                                            padding: EdgeInsets.all(MySize.size20),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: MySize.screenWidth * 0.7,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        snap['title'],
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 2,
                                                        style: AppTextStyles.label14600ATC.copyWith(
                                                          fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                                                        ),
                                                      ),
                                                      SizedBox(height: 10,),
                                                      Text(
                                                        snap['message'],
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 3,
                                                        style: AppTextStyles.label12500BTC,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Text(
                                                      snap['date'] != null
                                                          ? (snap['date'] as Timestamp)
                                                          .toDate()
                                                          .toString().replaceRange(11, 23, '')
                                                          : '',
                                                      style: AppTextStyles
                                                          .label12400BTC,
                                                    ),
                                                    // IconButton(
                                                    //     onPressed: () {},
                                                    //     icon: Icon(Icons
                                                    //         .more_horiz_outlined))
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                          width: MySize.screenWidth * 0.7,
                                          height: 1,
                                          color: Color(0xffE2E8F0),
                                        ),
                                      ),
                                    ],
                                  );
                                })
                          ],
                        ),
                      ),
                    ],
                  ),
                );

              }else{
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // SizedBox(height: 0,),
                        SvgPicture.asset(noOrders),
                        SizedBox(
                          height: MySize.size20,
                        ),
                        const Text(
                          'No Notifications',
                          style: AppTextStyles.label14600P,
                        ),
                      ],
                    ),
                  ],
                );
              }
            } else if (snapshot.hasError) {
              return Center(child: Icon(Icons.error));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Container();
            }
          }),
    );
  }
}