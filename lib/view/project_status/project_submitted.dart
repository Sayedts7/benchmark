import 'package:benchmark_estimate/view/project_status/wait_for_delivery.dart';
import 'package:benchmark_estimate/view/project_status/wait_for_quote.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../../utils/constants/MySize.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/textStyles.dart';
import '../../utils/constants/image_path.dart';
import '../../utils/custom_widgets/reusable_container.dart';
import 'package:benchmark_estimate/view_model/provider/file_picker_provider.dart';

import '../chat_screen/chat_screen_view.dart';

class ProjectSubmittedView extends StatefulWidget {
  final String docId;

  ProjectSubmittedView({super.key, required this.docId});

  @override
  State<ProjectSubmittedView> createState() => _ProjectSubmittedViewState();
}

class _ProjectSubmittedViewState extends State<ProjectSubmittedView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: false);
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
            String details = projectData['message'];
            Map<String, dynamic> data = projectData['category'];
            List<dynamic> fileUrls = projectData['fileUrls'];

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
                          spreadRadius: 2,
                        )
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
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                               projectData['status'] == 'Project Submitted'?
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
                                const Text('Project Submitted',
                                    style: AppTextStyles.label12600B),
                              ],
                            ),
                            InkWell(
                              onTap:(){
                                if(projectData['status'] != 'Project Submitted'){
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
                        SizedBox(height: MySize.size30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Project Details', style: AppTextStyles.label14700B),
                            Text(date, style: AppTextStyles.label14400BTC),
                          ],
                        ),
                        SizedBox(height: MySize.size20),
                        ListView.builder(
                          itemCount: data.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            String categoryKey = data.keys.elementAt(index);
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5.0),
                              child: AccountReusableContainer(
                                height: MySize.size50,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(categoryKey, style: AppTextStyles.label13500BTC),
                                    Icon(Icons.arrow_forward_ios_rounded, size: 14, color: bodyTextColor),
                                  ],
                                ),
                                ontap: () {

                                  _showModalBottomSheet(context, categoryKey);
                                },
                              ),
                            );
                          },
                        ),
                        SizedBox(height: MySize.size20),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Color(0xFFDEE3EA),
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(MySize.size10),
                            child: Center(
                              child: Text(
                                details,
                                style: AppTextStyles.label12500BTC,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: MySize.size20),
                        Wrap(
                          children: fileUrls.map<Widget>((file) {
                            return Container(
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
                                      file,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
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

    );
  }

  void _showModalBottomSheet(BuildContext context, String categoryKey) async {
    List<String> subcategories = await _fetchSubcategories(widget.docId, categoryKey);
    List<bool> selectedOptions = List.generate(subcategories.length, (index) => false);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...List.generate(subcategories.length, (index) {
                      return Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(subcategories[index]),
                          ),
                          Divider()
                        ],
                      );
                    }),
                    
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
  Future<List<String>> _fetchSubcategories(String docId, String categoryKey) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('Projects').doc(docId).get();
    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      Map<String, dynamic> categories = Map<String, dynamic>.from(data['category']);
      if (categories.containsKey(categoryKey)) {
        if (categoryKey == 'Scheduling') {
          Map<String, String> schedulingMap = Map<String, String>.from(categories[categoryKey]);
          return schedulingMap.entries.map((entry) => '${entry.key}: ${entry.value}').toList();
        } else {
          return List<String>.from(categories[categoryKey] ?? []);
        }
      }
    }
    return [];
  }


}
