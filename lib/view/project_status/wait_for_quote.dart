import 'package:benchmark_estimate/utils/constants/image_path.dart';
import 'package:benchmark_estimate/utils/custom_widgets/custom_button.dart';
import 'package:benchmark_estimate/view/create_project/create_project_view.dart';
import 'package:benchmark_estimate/view/project_status/project_submitted.dart';
import 'package:benchmark_estimate/view/project_status/wait_for_delivery.dart';
import 'package:benchmark_estimate/view_model/firebase/firebase_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../utils/constants/MySize.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/textStyles.dart';
import '../../utils/utils.dart';
import '../../view_model/provider/loader_view_provider.dart';
import '../chat_screen/chat_screen_view.dart';

class WaitForQuoteView extends StatefulWidget {
  final String userId;
  final String userName;
  final String price;
  final String message;
  final Timestamp date;
   final bool paid;

  final String projectName;
final Map<String, dynamic> categories;
  final String docId;

  const WaitForQuoteView({super.key, required this.docId,
    required this.price,
    required this.userId,
    required this.userName,
    required this.projectName,
    required this.message,
    required this.date,
    required this.categories,
    required this.paid,
  });

  @override
  State<WaitForQuoteView> createState() => _WaitForQuoteViewState();
}

class _WaitForQuoteViewState extends State<WaitForQuoteView> with SingleTickerProviderStateMixin {
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
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('Projects').doc(widget.docId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No data found'));
          } else {
            var projectData = snapshot.data!.data() as Map<String, dynamic>;
            String date = projectData['deadLine'].toDate().toString().replaceRange(11, 23, '');
            String adminMessage = projectData['adminMessage'];
            String price = projectData['price'];

            return  SingleChildScrollView(
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
                  SizedBox(
                    height: MySize.screenHeight >700 ? MySize.screenHeight * 0.74: MySize.screenHeight * 0.77,
                    child: Padding(
                      padding: kIsWeb
                          ? EdgeInsets.symmetric(
                          vertical: MySize.size20, horizontal: MySize.screenWidth * 0.2)
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
                              Column(
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
                              InkWell(
                                onTap:(){
                                  if(projectData['status'] == 'Wait for delivery'|| projectData['status'] == 'Completed'){
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> WaitForDeliveryView(docId: projectData['id'],)));
                                  }
                                },
                                child: Column(
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
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MySize.size30,
                          ),
                          const Text('Quotation Received', style: AppTextStyles.label14700B,),
                          SizedBox(
                            height: MySize.size12,
                          ),
                           Text(adminMessage, style: AppTextStyles.label14500BTC,),
                          SizedBox(
                            height: MySize.size20,
                          ),
                           Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total Amount', style: AppTextStyles.label14700B,),
                              Text('\$$price', style: AppTextStyles.label14700P,),
                            ],
                          ),
                          SizedBox(
                            height: MySize.size22,
                          ),
                           Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Date', style: AppTextStyles.label14700B,),
                              Text(date, style: AppTextStyles.label14400BTC,),
                            ],
                          ),
                          SizedBox(
                            height: MySize.size22,
                          ),
                          Visibility(
                            visible: !projectData['paid'],
                            child: Container(
                              // width: MySize.size100,
                              // height: 21.0,
                              decoration: BoxDecoration(
                                color: yellowLight,
                                borderRadius: BorderRadius.circular(7.0),
                                border: Border.all(
                                  color: yellowDark,
                                  width: 1.0,
                                ),),
                              child: Padding(
                                padding:  EdgeInsets.all( MySize.size10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.warning, size: MySize.size20,color: yellowDark,),
                                    SizedBox(width: MySize.size10,),
                                    Text('Pay your payment to proceed to the next step.', style:   AppTextStyles.label12500YD),
                                  ],
                                ),
                              ),),
                          ),


                        ],
                      ),
                    ),
                  ),

                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: Padding(
        padding: kIsWeb
            ? EdgeInsets.symmetric(
            vertical: MySize.size20, horizontal: MySize.screenWidth * 0.2)
            : EdgeInsets.all(MySize.size20),
        child: FloatingActionButton(
            shape: CircleBorder(          ),
            backgroundColor: primaryColor,
            child:SvgPicture.asset(message),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen(projectId: widget.docId,)));
            }),
      ),
      bottomNavigationBar: widget.paid?
          Container(
            height: 1,


          ):
       Padding(
        padding: kIsWeb
            ? EdgeInsets.symmetric(
            vertical: MySize.size20, horizontal: MySize.screenWidth * 0.2)
            : EdgeInsets.all(MySize.size20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomBorderedButton(
                width:kIsWeb ? MySize.scaleFactorWidth * 100:MySize.scaleFactorWidth * 160,
                height: MySize.size50,
                text: 'Preview',
                onPressed: (){

                  Navigator.push(context, MaterialPageRoute(builder: (context)=>
                      CreateProjectView(
                        projectName: widget.projectName,
                        date: widget.date,
                        message: widget.message,
                        id: widget.docId,
                        preview: true,
                        categories: widget.categories,
                      )));
                  // Navigator.of(context).pop();
                }),
            CustomButton8(text: 'Pay', onPressed: (){
              final loadingProvider = Provider.of<LoaderViewProvider>(context, listen: false);
              loadingProvider.changeShowLoaderValue(true);
              var id = DateTime.now().millisecondsSinceEpoch.toString();
              FirebaseFirestore.instance.collection('Projects').doc(widget.docId).update({
                'status': 'Wait for delivery',
                'paid': true,
              }).then((value) {
                FirebaseFirestore.instance.collection('Payments').doc(
                    id).set({
                  'id': id,
                  'userId':widget.userId ?? '',
                  'projectId': widget.docId ?? '',
                  'projectName': widget.projectName?? '',
                  'price':widget.price ?? '',
                  'userName':widget.userName ?? '',
                  'paid': true,
                }).then((value) {
                  FirestoreService().setNotifications('admin', 'Payment', '${widget.userName} has paid for the project with ID $id',widget.docId);
                  loadingProvider.changeShowLoaderValue(false);
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) =>
                      WaitForDeliveryView(docId: widget.docId,)));
                  Utils.toastMessage('Payment Successful');
                }).onError((error, stackTrace) {
                  loadingProvider.changeShowLoaderValue(false);
                  Utils.toastMessage(error.toString());
                });
              }).onError((error, stackTrace) {
                loadingProvider.changeShowLoaderValue(false);
                Utils.toastMessage(error.toString());
              });
            },
              width:kIsWeb ? MySize.scaleFactorWidth * 100:MySize.scaleFactorWidth * 160,
              height: MySize.size50,)
          ],
        ),
      ),
    );
  }
}
