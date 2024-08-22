import 'package:benchmark_estimate/utils/constants/image_path.dart';
import 'package:benchmark_estimate/utils/custom_widgets/custom_button.dart';
import 'package:benchmark_estimate/view/project_status/project_submitted.dart';
import 'package:benchmark_estimate/view/project_status/wait_for_quote.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/constants/MySize.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/textStyles.dart';
import '../../utils/utils.dart';
import '../../view_model/provider/file_picker_provider.dart';
import '../chat_screen/chat_screen_view.dart';

class WaitForDeliveryView extends StatefulWidget {
  final String docId;

  const WaitForDeliveryView({super.key, required this.docId});

  @override
  State<WaitForDeliveryView> createState() => _WaitForDeliveryViewState();
}

class _WaitForDeliveryViewState extends State<WaitForDeliveryView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // duration of one animation cycle
    )..repeat(reverse: false); // repeat the animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        title: const Text(
          'Project Status',
          style: AppTextStyles.label14600ATC,
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Projects')
            .doc(widget.docId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No data found'));
          } else {
            var projectData = snapshot.data!.data() as Map<String, dynamic>;
            String date = projectData['deadLine']
                .toDate()
                .toString()
                .replaceRange(11, 23, '');
            String details = projectData['adminMessage'];
            String price = projectData['price'];
            Map<String, dynamic> data = projectData['category'];


            if (projectData['adminComplete'] == false) {
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
                              // offset: Offset(3 , 3),
                              color: Colors.black12,
                              blurRadius: 2,
                              spreadRadius: 2)
                        ],
                      ),
                    ),
                    Padding(
                      padding: kIsWeb
                          ? EdgeInsets.symmetric(
                              vertical: MySize.size20,
                              horizontal: MySize.screenWidth * 0.2)
                          : EdgeInsets.all(MySize.size20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap:(){
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>  ProjectSubmittedView(docId: widget.docId),
                                      maintainState: true,
                                      fullscreenDialog: false,
                                    ),
                                  );
                                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>
                                  //     ProjectSubmittedView(docId: widget.docId)));
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SvgPicture.asset(statusComplete),
                                    SizedBox(height: MySize.size30,),
                                    const Text('Project Submitted',style: AppTextStyles.label12600B ,)
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap:(){
                                  if(projectData['status'] == 'Wait for quote'|| projectData['status'] == 'Wait for delivery'|| projectData['status'] == 'Completed'){
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> WaitForQuoteView(docId: projectData['id'], price: projectData['price'], userId: projectData['userId'],
                                        userName: projectData['customerName'], projectName: projectData['projectName'], message: message, date: projectData['deadLine'], categories: data, paid: projectData['paid'],)));
                                  }
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    projectData['status'] == 'Project Submitted'?
                                    SvgPicture.asset(statusZero):
                                    projectData['status'] == 'Wait for quote'?
                                    AnimatedBuilder(
                                      animation: _controller,
                                      builder: (context, child) {
                                        return LinearPercentIndicator(
                                          width: MySize.size95,
                                          lineHeight: MySize.size10,
                                          percent: _controller.value,
                                          barRadius: Radius.circular(15),
                                          linearStrokeCap: LinearStrokeCap.round,
                                          backgroundColor: Color(0xffE5EEFF),
                                          progressColor: primaryColor,
                                        );
                                      },
                                    ):
                                    projectData['status'] == 'Wait for delivery' ||  projectData['status'] == 'Completed'?
                                    SvgPicture.asset(statusComplete):
                                    SvgPicture.asset(statusComplete),
                                    // SvgPicture.asset(statusZero),
                                    SizedBox(height: MySize.size30),
                                    const Text('Wait for quote',
                                        style: AppTextStyles.label12600B),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  projectData['status'] == 'Project Submitted'?
                                  SvgPicture.asset(statusZero):
                                  projectData['status'] == 'Wait for quote'?
                                  SvgPicture.asset(statusZero) :
                                  projectData['status'] == 'Wait for delivery' ?
                                  AnimatedBuilder(
                                    animation: _controller,
                                    builder: (context, child) {
                                      return LinearPercentIndicator(
                                        width: MySize.size95,
                                        lineHeight: MySize.size10,
                                        percent: _controller.value,
                                        barRadius: Radius.circular(15),
                                        linearStrokeCap: LinearStrokeCap.round,
                                        backgroundColor: Color(0xffE5EEFF),
                                        progressColor: primaryColor,
                                      );
                                    },
                                  ):
                                  SvgPicture.asset(statusComplete),
                                  SizedBox(height: MySize.size30),
                                  const Text('Wait for Delivery',
                                      style: AppTextStyles.label12600B),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MySize.size180,
                          ),
                          Center(child: Text('Please Wait')),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
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
                              // offset: Offset(3 , 3),
                              color: Colors.black12,
                              blurRadius: 2,
                              spreadRadius: 2)
                        ],
                      ),
                    ),
                    Padding(
                      padding: kIsWeb
                          ? EdgeInsets.symmetric(
                              vertical: MySize.size20,
                              horizontal: MySize.screenWidth * 0.2)
                          : EdgeInsets.all(MySize.size20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap:(){
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ProjectSubmittedView(docId: widget.docId)));
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SvgPicture.asset(statusComplete),
                                    SizedBox(height: MySize.size30,),
                                    const Text('Project Submitted',style: AppTextStyles.label12600B ,)
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap:(){
                                  if(projectData['status'] == 'Wait for quote'|| projectData['status'] == 'Wait for delivery'|| projectData['status'] == 'Completed'){
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> WaitForQuoteView(docId: projectData['id'], price: projectData['price'], userId: projectData['userId'],
                                        userName: projectData['customerName'], projectName: projectData['projectName'], message: message, date: projectData['deadLine'], categories: data, paid: projectData['paid'],)));
                                  }
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    projectData['status'] == 'Project Submitted'?
                                    SvgPicture.asset(statusZero):
                                    projectData['status'] == 'Wait for quote'?
                                    AnimatedBuilder(
                                      animation: _controller,
                                      builder: (context, child) {
                                        return LinearPercentIndicator(
                                          width: MySize.size95,
                                          lineHeight: MySize.size10,
                                          percent: _controller.value,
                                          barRadius: Radius.circular(15),
                                          linearStrokeCap: LinearStrokeCap.round,
                                          backgroundColor: Color(0xffE5EEFF),
                                          progressColor: primaryColor,
                                        );
                                      },
                                    ):
                                    projectData['status'] == 'Wait for delivery' ||  projectData['status'] == 'Completed'?
                                    SvgPicture.asset(statusComplete):
                                    SvgPicture.asset(statusComplete),
                                    // SvgPicture.asset(statusZero),
                                    SizedBox(height: MySize.size30),
                                    const Text('Wait for quote',
                                        style: AppTextStyles.label12600B),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  projectData['status'] == 'Project Submitted'?
                                  SvgPicture.asset(statusZero):
                                  projectData['status'] == 'Wait for quote'?
                                  SvgPicture.asset(statusZero) :
                                  projectData['status'] == 'Wait for delivery' ?
                                  AnimatedBuilder(
                                    animation: _controller,
                                    builder: (context, child) {
                                      return LinearPercentIndicator(
                                        width: MySize.size95,
                                        lineHeight: MySize.size10,
                                        percent: _controller.value,
                                        barRadius: Radius.circular(15),
                                        linearStrokeCap: LinearStrokeCap.round,
                                        backgroundColor: Color(0xffE5EEFF),
                                        progressColor: primaryColor,
                                      );
                                    },
                                  ):
                                  SvgPicture.asset(statusComplete),
                                  SizedBox(height: MySize.size30),
                                  const Text('Wait for Delivery',
                                      style: AppTextStyles.label12600B),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MySize.size30,
                          ),
                          Text(
                            projectData['projectName'],
                            style: AppTextStyles.label14700B,
                          ),
                          SizedBox(
                            height: MySize.size12,
                          ),
                          Text(
                            projectData['adminMessageOnComplete'],
                            style: AppTextStyles.label14500BTC,
                          ),
                          SizedBox(
                            height: MySize.size20,
                          ),
                          if (kIsWeb)
                            Wrap(
                              children: projectData['adminFileUrls']
                                  .map<Widget>((fileUrl) {
                                return Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(10),
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SvgPicture.asset(uFile),
                                          SizedBox(width: 10),
                                          SizedBox(
                                            width: MySize.size80,
                                            child: Text(
                                              fileUrl,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          if (!kIsWeb)
                            Wrap(
                              children: projectData['adminFileUrls']
                                  .map<Widget>((fileUrl) {
                                return Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(10),
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SvgPicture.asset(uFile),
                                          const SizedBox(width: 10),
                                          SizedBox(
                                            width: MySize.size80,
                                            child: Text(
                                              fileUrl,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          }
        },
      ),
      floatingActionButton: Padding(
        padding: kIsWeb
            ? EdgeInsets.symmetric(
                vertical: MySize.size20, horizontal: MySize.screenWidth * 0.2)
            : EdgeInsets.all(MySize.size20),
        child: FloatingActionButton(
            shape: CircleBorder(),
            backgroundColor: primaryColor,
            child: SvgPicture.asset(message),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatScreen(
                            projectId: widget.docId,
                          )));
            }),
      ),
      bottomNavigationBar: Padding(
        padding: kIsWeb
            ? EdgeInsets.symmetric(
                vertical: MySize.size20, horizontal: MySize.screenWidth * 0.2)
            : EdgeInsets.all(MySize.size20),
        child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Projects')
                .doc(widget.docId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || !snapshot.data!.exists) {
                return Center(child: Text('No data found'));
              } else if (snapshot.hasData) {
                var projectData = snapshot.data!.data() as Map<String, dynamic>;
                if(projectData['adminComplete'] == true){
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomBorderedButton(
                          width: kIsWeb
                              ? MySize.scaleFactorWidth * 100
                              : MySize.scaleFactorWidth * 160,
                          height: 50,
                          text: 'Export Files',
                          onPressed: () {
                            // print(projectData['adminFileUrls']);
                            for(String url in projectData['adminFileUrls']){
                              launchURL(url);
                            }
                          }),
                      CustomButton8(
                        text: projectData['status'] == 'Completed'? 'Completed': 'Mark Completed',
                        onPressed: () {
                          showCustomDialog(context, widget.docId);
                        },
                        width: kIsWeb
                            ? MySize.scaleFactorWidth * 100
                            : MySize.scaleFactorWidth * 160,
                        height: 50,
                      )
                    ],
                  );
                }
                else{
                 return CustomBorderedButton(
                      width: kIsWeb
                          ? MySize.scaleFactorWidth * 200
                          : MySize.scaleFactorWidth * 120,
                      height: 50,
                      text: 'Please Wait',
                      onPressed: () {
                        // print(projectData['adminFileUrls']);

                      });
                }
              }
              return Container();
            }),
      ),
    );
  }

  void showCustomDialog(BuildContext context, String id) {
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
                    projectCreated, // Replace with your image URL
                    width: MySize.size120,
                    height: MySize.size120,
                  ),
                  SizedBox(height: MySize.size10),
                  Text(
                    'Confirmation',
                    style: TextStyle(
                        fontSize: MySize.size20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: MySize.size8),
                  Text(
                    'Would you like to Complete this Project?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: MySize.size16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CustomBorderedButton(
                          width: 120,
                          height: 40,
                          text: 'Cancel',
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                      CustomButton8(
                        width: 120,
                        height: 40,
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('Projects')
                              .doc(id)
                              .update({
                            'status': 'Completed',
                          }).then((value) {
                            Utils.toastMessage('Completed');
                            Navigator.pop(context);
                          }).onError((error, stackTrace) {
                            Utils.toastMessage(error.toString());
                          });
                        },
                        text: 'Yes',
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
  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
