import 'dart:io';
import 'dart:math';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:benchmark_estimate/utils/constants/image_path.dart';
import 'package:benchmark_estimate/utils/custom_widgets/custom_button.dart';
import 'package:benchmark_estimate/view/project_status/project_submitted.dart';
import 'package:benchmark_estimate/view/project_status/wait_for_quote.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
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
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProjectSubmittedView(
                                              docId: widget.docId),
                                      maintainState: true,
                                      fullscreenDialog: false,
                                    ),
                                  );
                                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>
                                  //     ProjectSubmittedView(docId: widget.docId)));
                                },
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SvgPicture.asset(statusComplete),
                                    SizedBox(
                                      height: MySize.size30,
                                    ),
                                    const Text(
                                      'Project Submitted',
                                      style: AppTextStyles.label12600B,
                                    )
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (projectData['status'] == 'Quote Submitted' ||
                                      projectData['status'] ==
                                          'Project Started' ||
                                      projectData['status'] == 'Completed') {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                WaitForQuoteView(
                                                  docId: projectData['id'],
                                                  price: projectData['price'],
                                                  userId: projectData['userId'],
                                                  userName: projectData[
                                                      'customerName'],
                                                  projectName: projectData[
                                                      'projectName'],
                                                  message: message,
                                                  date: projectData['deadLine'],
                                                  categories: data,
                                                  paid: projectData['paid'],
                                                  files:
                                                      projectData['fileUrls'],
                                                )));
                                  }
                                },
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    projectData['status'] ==
                                            'Requirements Submitted'
                                        ? SvgPicture.asset(statusZero)
                                        : projectData['status'] ==
                                                'Quote Submitted'
                                            ? AnimatedBuilder(
                                                animation: _controller,
                                                builder: (context, child) {
                                                  return LinearPercentIndicator(
                                                    width: MySize.size95,
                                                    lineHeight: MySize.size10,
                                                    percent: _controller.value,
                                                    barRadius:
                                                        Radius.circular(15),
                                                    linearStrokeCap:
                                                        LinearStrokeCap.round,
                                                    backgroundColor:
                                                        Color(0xffE5EEFF),
                                                    progressColor: primaryColor,
                                                  );
                                                },
                                              )
                                            : projectData['status'] ==
                                                        'Project Started' ||
                                                    projectData['status'] ==
                                                        'Completed'
                                                ? SvgPicture.asset(
                                                    statusComplete)
                                                : SvgPicture.asset(
                                                    statusComplete),
                                    // SvgPicture.asset(statusZero),
                                    SizedBox(height: MySize.size30),
                                    const Text('Wait for quote',
                                        style: AppTextStyles.label12600B),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  projectData['status'] ==
                                          'Requirements Submitted'
                                      ? SvgPicture.asset(statusZero)
                                      : projectData['status'] ==
                                              'Quote Submitted'
                                          ? SvgPicture.asset(statusZero)
                                          : projectData['status'] ==
                                                  'Project Started'
                                              ? AnimatedBuilder(
                                                  animation: _controller,
                                                  builder: (context, child) {
                                                    return LinearPercentIndicator(
                                                      width: MySize.size95,
                                                      lineHeight: MySize.size10,
                                                      percent:
                                                          _controller.value,
                                                      barRadius:
                                                          Radius.circular(15),
                                                      linearStrokeCap:
                                                          LinearStrokeCap.round,
                                                      backgroundColor:
                                                          Color(0xffE5EEFF),
                                                      progressColor:
                                                          primaryColor,
                                                    );
                                                  },
                                                )
                                              : SvgPicture.asset(
                                                  statusComplete),
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
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProjectSubmittedView(
                                                  docId: widget.docId)));
                                },
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SvgPicture.asset(statusComplete),
                                    SizedBox(
                                      height: MySize.size30,
                                    ),
                                    const Text(
                                      'Project Submitted',
                                      style: AppTextStyles.label12600B,
                                    )
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (projectData['status'] == 'Quote Submitted' ||
                                      projectData['status'] ==
                                          'Project Started' ||
                                      projectData['status'] == 'Completed') {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                WaitForQuoteView(
                                                    docId: projectData['id'],
                                                    price: projectData['price'],
                                                    userId:
                                                        projectData['userId'],
                                                    userName: projectData[
                                                        'customerName'],
                                                    projectName: projectData[
                                                        'projectName'],
                                                    message: message,
                                                    date:
                                                        projectData['deadLine'],
                                                    categories: data,
                                                    paid: projectData['paid'],
                                                    files: projectData[
                                                        'fileUrls'])));
                                  }
                                },
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    projectData['status'] ==
                                            'Requirements Submitted'
                                        ? SvgPicture.asset(statusZero)
                                        : projectData['status'] ==
                                                'Quote Submitted'
                                            ? AnimatedBuilder(
                                                animation: _controller,
                                                builder: (context, child) {
                                                  return LinearPercentIndicator(
                                                    width: MySize.size95,
                                                    lineHeight: MySize.size10,
                                                    percent: _controller.value,
                                                    barRadius:
                                                        Radius.circular(15),
                                                    linearStrokeCap:
                                                        LinearStrokeCap.round,
                                                    backgroundColor:
                                                        Color(0xffE5EEFF),
                                                    progressColor: primaryColor,
                                                  );
                                                },
                                              )
                                            : projectData['status'] ==
                                                        'Project Started' ||
                                                    projectData['status'] ==
                                                        'Completed'
                                                ? SvgPicture.asset(
                                                    statusComplete)
                                                : SvgPicture.asset(
                                                    statusComplete),
                                    // SvgPicture.asset(statusZero),
                                    SizedBox(height: MySize.size30),
                                    const Text('Wait for quote',
                                        style: AppTextStyles.label12600B),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  projectData['status'] ==
                                          'Requirements Submitted'
                                      ? SvgPicture.asset(statusZero)
                                      : projectData['status'] ==
                                              'Quote Submitted'
                                          ? SvgPicture.asset(statusZero)
                                          : projectData['status'] ==
                                                  'Project Started'
                                              ? AnimatedBuilder(
                                                  animation: _controller,
                                                  builder: (context, child) {
                                                    return LinearPercentIndicator(
                                                      width: MySize.size95,
                                                      lineHeight: MySize.size10,
                                                      percent:
                                                          _controller.value,
                                                      barRadius:
                                                          Radius.circular(15),
                                                      linearStrokeCap:
                                                          LinearStrokeCap.round,
                                                      backgroundColor:
                                                          Color(0xffE5EEFF),
                                                      progressColor:
                                                          primaryColor,
                                                    );
                                                  },
                                                )
                                              : SvgPicture.asset(
                                                  statusComplete),
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
                              children: projectData['adminFileData']
                                  .map<Widget>((fileData) {
                                // Check if fileData is indeed a map and has the key you expect
                                if (fileData is Map<String, dynamic> &&
                                    fileData.containsKey('url')) {
                                  final fileUrl = fileData[
                                      'url']; // Extract the URL from the map

                                  return Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SvgPicture.asset(uFile),
                                            SizedBox(width: 10),
                                            SizedBox(
                                              width: MySize.size80,
                                              child: Text(
                                                fileUrl, // Use the extracted URL here
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  // Handle unexpected data format if necessary
                                  return SizedBox
                                      .shrink(); // or any placeholder widget
                                }
                              }).toList(),
                            ),
                          if (!kIsWeb)
                            Wrap(
                              children: projectData['adminFileData']
                                  .map<Widget>((fileData) {
                                // Ensure fileData is a Map and contains the expected key
                                if (fileData is Map<String, dynamic> &&
                                    fileData.containsKey('url')) {
                                  final fileUrl =
                                      fileData['url']; // Extract the URL

                                  return Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SvgPicture.asset(uFile),
                                            const SizedBox(width: 10),
                                            SizedBox(
                                              width: MySize.size80,
                                              child: Text(
                                                fileUrl, // Use the extracted URL here
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  // Handle unexpected data format if necessary
                                  return SizedBox
                                      .shrink(); // or any placeholder widget
                                }
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
                if (projectData['adminComplete'] == true) {
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
                            var data = projectData['adminFileData'];
                            // print(projectData['adminFileData'].runtimeType);
                            // List<Map<String, String>> file = data as List<Map<String,String>>;
                            downloadMultipleFilesToPublicDownloads(
                                context, data);
                            // }
                          }),
                      CustomButton8(
                        text: projectData['status'] == 'Completed'
                            ? 'Completed'
                            : 'Mark Completed',
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
                } else {
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

  bool isWeb = false;
  Future<bool> requestStoragePermission() async {
    if (kIsWeb) {
      print('12345678900987654323456789');
      isWeb = true;
      // Storage permissions are not required or supported on the web.
      return true;
    }

    if (Platform.isIOS) {
      // iOS handles permissions differently and does not need the same level of storage permissions.
      return await Permission.photos.request().isGranted;
    }

    if (Platform.isAndroid) {
      print('hereeeeeeeeeeeeeeeeee1android permisison');
      final DeviceInfoPlugin info = DeviceInfoPlugin(); // import 'package:device_info_plus/device_info_plus.dart';
      final AndroidDeviceInfo androidInfo = await info.androidInfo;
      debugPrint('releaseVersion : ${androidInfo.version.release}');
      final int androidVersion = int.parse(androidInfo.version.release);
      // Check Android version
      print(Platform.version);
      print('hereeeeeeeeeeeeeeeeee12 $androidVersion');


      if (androidVersion >= 13) {
        print('hereeeeeeeeeeeeeeeeee13 +++');

        // Android 13+ requires different permissions
        if (await Permission.photos.request().isGranted) {
          print('hereeeeeeeeeeeeeeeeee1 requst');

          return true;
        } else {
          print("Storage permission denied.");
          return false;
        }
      } else {
        // Android 12 and below
        if (await Permission.storage.request().isGranted) {
          return true;
        } else {
          print("Storage permission denied.");
          return false;
        }
      }
    }

    return false; // In case of any unsupported platform or if checks don't pass
  }

  Future<void> downloadMultipleFilesToPublicDownloads(
      BuildContext context, List<dynamic> files) async {
    // Map to keep track of download progress for each file
    if (kIsWeb) {
      openAllUrlsFromList(files);
    } else {
      print('hereeeeeeeeeeeeeeeeee12');
      Map<String, ValueNotifier<double>> progressMap = {
        for (var file in files) file['name']!: ValueNotifier<double>(0.0)
      };
      print('hereeeeeeeeeeeeeeeeee13');

      // Display the download progress dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Downloading Files'),
            content: SizedBox(
              height: 300,
              width: double.maxFinite,
              child: ListView(
                children: files.map((file) {
                  String fileName = file['name']!;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(fileName),
                        ValueListenableBuilder<double>(
                          valueListenable: progressMap[fileName]!,
                          builder: (context, progress, child) {
                            return Column(
                              children: [
                                LinearProgressIndicator(value: progress),
                                SizedBox(height: 10),
                                Text('${(progress * 100).toStringAsFixed(0)}%'),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        },
      );
      print('hereeeeeeeeeeeeeeeeee14');

      try {
        // Request storage permission first
        bool hasPermission = await requestStoragePermission();
        print('hereeeeeeeeeeeeeeeeee12 $hasPermission');

        if (!hasPermission) {
          print('Permission not granted to write to external storage.');
          Navigator.of(context)
              .pop(); // Close the dialog if permission is not granted
          return;
        }
        print('hereeeeeeeeeeeeeeeeee123');

        // Determine the Downloads directory path
        Directory? downloadsDirectory;

        if (Platform.isAndroid) {
          downloadsDirectory = Directory('/storage/emulated/0/Download');
        } else if (Platform.isIOS) {
          downloadsDirectory = await getApplicationDocumentsDirectory();
        }

        // Ensure the Downloads directory is accessible
        if (downloadsDirectory != null && await downloadsDirectory.exists()) {
          Dio dio = Dio();

          // Loop through each file to download
          for (int i = 0; i < files.length; i++) {
            String fileUrl = files[i]['url']!;
            String fileName = files[i]['name']!;
            String uniqueFileName =
                fileName; // Assuming file name is unique already
            String fullPath = '${downloadsDirectory.path}/$uniqueFileName';

            await dio.download(
              fileUrl,
              fullPath,
              onReceiveProgress: (received, total) {
                if (total != -1) {
                  // Update the progress for each file
                  progressMap[fileName]!.value = received / total;
                }
              },
            );
            Utils.toastMessage(
                'File downloaded successfully and saved to: $fullPath');
            print('File downloaded successfully and saved to: $fullPath');
          }
        } else {
          Utils.toastMessage('Cannot access the Downloads directory.');
          print('Cannot access the Downloads directory.');
        }
      } catch (e) {
        Utils.toastMessage(e.toString());
        print('Error downloading files: $e');
      } finally {
        // Close the dialog after all downloads are complete
        Navigator.of(context).pop();
      }
    }
  }

  void openAllUrlsFromList(List<dynamic> urlList) async {
    for (var urlMap in urlList) {
      final String? url = urlMap['url'];

      if (url != null && await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      } else {
        print('Could not launch the URL or URL is invalid: $url');
      }
    }
  }
}
