import 'package:benchmark_estimate/utils/constants/MySize.dart';
import 'package:benchmark_estimate/utils/constants/colors.dart';
import 'package:benchmark_estimate/utils/constants/textStyles.dart';
import 'package:benchmark_estimate/view/account_settings/account_settings_view.dart';
import 'package:benchmark_estimate/view/account_settings/my_profile/my_profile_view.dart';
import 'package:benchmark_estimate/view/create_project/create_project_view.dart';
import 'package:benchmark_estimate/view/notifications/notification_view.dart';
import 'package:benchmark_estimate/view/project_status/project_submitted.dart';
import 'package:benchmark_estimate/view_model/provider/homescreen_status_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../view_model/firebase/global.dart';
import '../../utils/constants/image_path.dart';
import '../../utils/custom_widgets/reusable_container.dart';
import '../../view_model/firebase/global.dart';
import '../../view_model/firebase/notification_services.dart';
import '../../view_model/firebase/push_notifications.dart';
import '../project_status/wait_for_delivery.dart';
import '../project_status/wait_for_quote.dart';
import 'package:badges/badges.dart' as badges;
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    notificationServices.sendToken(uid);

    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    // print('hi');
    // final notProvider = Provider.of<NotificationServices>(context,listen:  false);
    // print(notProvider.route);
    // if(notProvider.route == 1){
    //   print(notProvider.route);
    //   Navigator.push(context, MaterialPageRoute(builder: (context)=> CreateProjectView(preview: false)));
    // }
    // NotificationService().getFCMTokenAndSave();

    MySize().init(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // NotificationServices().sendPushMessage('fw-dYF3CQH-0Lk2_z3Uf8E:APA91bE1ERh3k8usvaZVmFhwGdaeqlXKCAr91VX6_AZwxZkhF8Aet1hRMdmgN8tegzereDxbTfUkntlPBbfXcQdeQSgoNt0NK8oihLHwDDF5plqejOp4pDbHl-o80kda53iCBMPbMwsJ',
          //     'body', 'title');
          // NotificationServices notificationServices = NotificationServices();
          // notificationServices.sendNotification('dRrZTnr_SXub92rE3DI9oB:APA91bHDND9xW95o5_YP4TbN1QI4FsBjtCRRx8REtNrhA9FOSbE3WW5ZktjdubmLZ9VRR-rPtUxSz0iq_BGamCcx3F0UfGYCXyyXQSYy-7sIsC8HON0rsvro0dLTv-FsojNJXdFhs99Z',
          //     context);
          //
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CreateProjectView(preview: false,)));
        },
        shape: const CircleBorder(), // Ensures the FAB is circular
        backgroundColor: primaryColor,
        child: const Icon(
          Icons.add,
          color: whiteColor,
        ),
      ),
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        backgroundColor: whiteColor,
        title: const Text(
          'Home',
          style: AppTextStyles.label14600ATC,
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AccountSettingsView()));
          },
          child: Padding(
            padding: EdgeInsets.all(MySize.size20),
            child: SvgPicture.asset(menu),
          ),
        ),


          actions: [
          StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
          .collection('Notifications')
          .where('toId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('read', isEqualTo: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Icon(Icons.error);
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        int unreadCount = snapshot.data?.docs.length ?? 0;
        return badges.Badge(
          position: badges.BadgePosition.topEnd(top: 0, end: 3),
          badgeContent: Text(
            unreadCount.toString(),
            style: const TextStyle(color: Colors.white),
          ),
          badgeStyle: const badges.BadgeStyle(
            badgeColor: Colors.red,
          ),
          showBadge: unreadCount > 0,
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationView()),
              );
            },
            icon: const Icon(
              Icons.notifications,
              color: blackColor,
            ),
          ),
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
                      spreadRadius: 2)
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(
                MySize.size20,
              ),
              child: SizedBox(
                height: MySize.safeHeight * 0.9,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Consumer<HomeScreenStatusProvider>(
                        builder: (context, projectProvider, child) {
                          return Row(
                            children: [
                              projectProvider.status == 'All'
                                  ? Container(
                                      // width: 85.0,
                                      height: MySize.size28,
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.circular(7.0),
                                        border: Border.all(
                                          color: const Color(0xFFDEE3EA),
                                          width: 1.0,
                                        ),
                                      ),
                                      child: const Center(
                                          child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 15.0),
                                        child: Text(
                                          'All',
                                          style: AppTextStyles.label12500W,
                                        ),
                                      )),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        projectProvider.updateStatus('All');
                                      },
                                      child: Container(
                                        // width: 85.0,
                                        height: MySize.size28,
                                        decoration: BoxDecoration(
                                          color: whiteColor,
                                          borderRadius: BorderRadius.circular(7.0),
                                          border: Border.all(
                                            color: const Color(0xFFDEE3EA),
                                            width: 1.0,
                                          ),
                                        ),
                                        child: const Center(
                                            child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15.0),
                                          child: Text(
                                            'All',
                                            style: AppTextStyles.label12500PTC,
                                          ),
                                        )),
                                      ),
                                    ),
                              SizedBox(
                                width: MySize.size12,
                              ),
                              projectProvider.status == 'In Progress'
                                  ? Container(
                                      // width: 85.0,
                                      height: MySize.size28,
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.circular(7.0),
                                        border: Border.all(
                                          color: const Color(0xFFDEE3EA),
                                          width: 1.0,
                                        ),
                                      ),
                                      child: const Center(
                                          child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 15.0),
                                        child: Text(
                                          'In Progress',
                                          style: AppTextStyles.label12500W,
                                        ),
                                      )),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        projectProvider.updateStatus('In Progress');
                                      },
                                      child: Container(
                                        // width: 85.0,
                                        height: MySize.size28,
                                        decoration: BoxDecoration(
                                          color: whiteColor,
                                          borderRadius: BorderRadius.circular(7.0),
                                          border: Border.all(
                                            color: const Color(0xFFDEE3EA),
                                            width: 1.0,
                                          ),
                                        ),
                                        child: const Center(
                                            child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15.0),
                                          child: Text(
                                            'In Progress',
                                            style: AppTextStyles.label12500PTC,
                                          ),
                                        )),
                                      ),
                                    ),
                              SizedBox(
                                width: MySize.size12,
                              ),
                              projectProvider.status == 'Completed'
                                  ? Container(
                                      // width: 85.0,
                                      height: MySize.size28,
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.circular(7.0),
                                        border: Border.all(
                                          color: const Color(0xFFDEE3EA),
                                          width: 1.0,
                                        ),
                                      ),
                                      child: const Center(
                                          child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 15.0),
                                        child: Text(
                                          'Completed',
                                          style: AppTextStyles.label12500W,
                                        ),
                                      )),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        projectProvider.updateStatus('Completed');
                                      },
                                      child: Container(
                                        // width: 85.0,
                                        height: MySize.size28,
                                        decoration: BoxDecoration(
                                          color: whiteColor,
                                          borderRadius: BorderRadius.circular(7.0),
                                          border: Border.all(
                                            color: const Color(0xFFDEE3EA),
                                            width: 1.0,
                                          ),
                                        ),
                                        child: const Center(
                                            child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15.0),
                                          child: Text(
                                            'Completed',
                                            style: AppTextStyles.label12500PTC,
                                          ),
                                        )),
                                      ),
                                    ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: MySize.size25),
                      Consumer<HomeScreenStatusProvider>(
                        builder: (context, hmsp, child){
                          return  StreamBuilder(
                              stream: getProjectStream(hmsp.status),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return const Center(child: Icon(Icons.error));
                                } else if (snapshot.hasData) {
                                  if (snapshot.data!.docs.length > 0) {
                                    return ListView.builder(
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: snapshot.data!.docs.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          var snap = snapshot.data!.docs[index];
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: ProjectReusableContainer(
                                              height: MySize.size90,
                                              projectName: snapshot.data!.docs[index]
                                              ['projectName'],
                                              expiryDate: snap['deadLine']
                                                  .toDate()
                                                  .toString()
                                                  .replaceRange(11, 23, ''),
                                              statusText: snap['status'],

                                              //text color
                                              textColor:
                                              snap['status'] == 'Wait for quote'
                                                  ? yellowDark
                                                  : snap['status'] ==
                                                  'Wait for delivery'
                                                  ? blueDark :
                                              snap['status'] == 'Project Submitted'
                                                  ? Colors.grey
                                                  : greenDark,

                                              //border color
                                              borderColor:
                                              snap['status'] == 'Wait for quote'
                                                  ? yellowDark
                                                  : snap['status'] ==
                                                  'Wait for delivery'
                                                  ? blueDark :
                                              snap['status'] == 'Project Submitted'
                                                  ? Colors.grey
                                                  : greenDark,

                                              //background color
                                              bgColor:
                                              snap['status'] == 'Wait for quote'
                                                  ? yellowLight
                                                  : snap['status'] ==
                                                  'Wait for delivery'
                                                  ? blueLight :
                                              snap['status'] == 'Project Submitted'
                                                  ? Colors.grey.withOpacity(0.2)
                                                  : greenLight,

                                              ontap: () {
                                                snap['status'] == 'Project Submitted'
                                                    ? Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProjectSubmittedView(
                                                              docId: snap.id,
                                                            )))
                                                    : snap['status'] == 'Wait for quote'
                                                    ? Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            WaitForQuoteView(

                                                              docId: snap.id,
                                                              price:
                                                              snap['price'],
                                                              userId: snap[
                                                              'userId'],
                                                              userName: snap[
                                                              'customerName'],
                                                              projectName: snap[
                                                              'projectName'],
                                                              message:  snap[
                                                            'message'],
                                                              date:  snap[
                                                              'deadLine'],
                                                              categories: snap['category'],
                                                              paid: snap['paid'],
                                                            )))
                                                    : Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            WaitForDeliveryView(
                                                              docId: snap.id,
                                                            )));
                                              },
                                            ),
                                          );
                                        });
                                  } else {
                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 200,),
                                        SvgPicture.asset(noOrders),
                                        SizedBox(
                                          height: MySize.size20,
                                        ),
                                        const Text(
                                          'No Project Found',
                                          style: AppTextStyles.label14600P,
                                        ),
                                      ],
                                    );
                                  }
                                } else if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else {
                                  return Container();
                                }
                              });
                      },

                      ),

                      // SizedBox(height: MySize.size25),

                      // ProjectReusableContainer( height: MySize.size90,
                      //   projectName: 'Project Name',
                      //   expiryDate: '21-2-24',
                      //   statusText: 'Wait for quote',
                      //   textColor: blueDark,
                      //   bgColor: blueLight,
                      //   borderColor: blueDark,
                      //   ontap: (){
                      //     Navigator.push(context, MaterialPageRoute(builder: (context)=> WaitForQuoteView()));
                      //
                      //   },
                      //
                      // ),
                      // SizedBox(height: MySize.size25),
                      //
                      // ProjectReusableContainer( height: MySize.size90,
                      //   projectName: 'Project Name',
                      //   expiryDate: '21-2-24',
                      //   statusText: 'Waiting for Delivery',
                      //   textColor: greenDark,
                      //   bgColor: greenLight,
                      //   borderColor: greenDark,
                      //   ontap: (){
                      //     Navigator.push(context, MaterialPageRoute(builder: (context)=> WaitForDeliveryView()));
                      //   },
                      //
                      // )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Stream<QuerySnapshot> getProjectStream(String status) {
    if (status == 'All') {
      return FirebaseFirestore.instance
          .collection('Projects')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots();
    } else if (status == 'Completed') {
      return FirebaseFirestore.instance
          .collection('Projects')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('status', isEqualTo: 'Completed')
          .snapshots();
    } else if (status == 'In Progress') {
      return FirebaseFirestore.instance
          .collection('Projects')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('status', whereIn: ['Wait for delivery', 'Wait for quote', 'Project Submitted'])
          .snapshots();
    } else {
      // Handle other cases or return an empty stream
      return FirebaseFirestore.instance
          .collection('Projects')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('status', isEqualTo: status)
          .snapshots();
    }
  }
}
