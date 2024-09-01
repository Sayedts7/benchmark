import 'dart:io';

import 'package:benchmark_estimate/utils/constants/MySize.dart';
import 'package:benchmark_estimate/utils/constants/image_path.dart';
import 'package:benchmark_estimate/utils/custom_widgets/custom_button.dart';
import 'package:benchmark_estimate/utils/custom_widgets/custom_textfield.dart';
import 'package:benchmark_estimate/utils/custom_widgets/loader_view.dart';
import 'package:benchmark_estimate/utils/utils.dart';
import 'package:benchmark_estimate/view/create_project/choose_category/choose_category_view.dart';
import 'package:benchmark_estimate/view/home/home_view.dart';
import 'package:benchmark_estimate/view_model/firebase/firebase_functions.dart';
import 'package:benchmark_estimate/view_model/provider/loader_view_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../utils/common_function.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/textStyles.dart';
import '../../utils/custom_widgets/reusable_container.dart';
import 'package:dotted_border/dotted_border.dart';

import '../../view_model/provider/category_provider.dart';
import '../../view_model/provider/file_picker_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'choose_category/choose_category_test.dart';

class CreateProjectView extends StatefulWidget {
  final String? projectName;
  final Timestamp? date;
  final List<dynamic>? files;
  final String? message;
  final String? id;
  final Map<String, dynamic>? categories;
  final bool preview;
  const CreateProjectView({super.key, this.projectName, this.date, this.message, required this.preview, this.categories, this.id, this.files});

  @override
  State<CreateProjectView> createState() => _CreateProjectViewState();
}

class _CreateProjectViewState extends State<CreateProjectView> {

  TextEditingController projectNameController = TextEditingController();
  TextEditingController deadlineController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  final GlobalKey<FormState> _createProjectkey = GlobalKey<FormState>();

  // List<File> files = [];
  Map<String, dynamic> getSelectedCategoriesData() {
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    return categoryProvider.getSelectedCategoriesWithSubcategories();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.preview){
      projectNameController.text = widget.projectName!;
      messageController.text = widget.message!;
      if (widget.date != null) {
        // DateTime date = widget.date!.toDate();
        String formattedDate = DateFormat('yyyy-MM-dd').format(widget.date!.toDate());

        deadlineController.text = formattedDate;
      }
    }
    if (widget.preview && widget.categories != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setPreviewCategories();
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadExistingProject();
    });

  }
  void setPreviewCategories()async {
    final loaderProvider =  Provider.of<LoaderViewProvider>(context, listen: false);
    loaderProvider.changeShowLoaderValue(true);
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    await categoryProvider.fetchCategories().then((value) {
      categoryProvider.setPreviewCategories(widget.categories!);
      loaderProvider.changeShowLoaderValue(false);
    }).onError((error, stackTrace) {
      loaderProvider.changeShowLoaderValue(false);
      Utils.toastMessage(error.toString());

    });
  }

  void setExistingFiles() {
    if (widget.preview && widget.files != null && widget.files!.isNotEmpty) {
      final fileProvider = Provider.of<FilePickerProvider>(context, listen: false);
      fileProvider.setExistingFileUrls(widget.files!);
    }
  }
  Future<void> _loadExistingProject() async {
    final projectDoc = await FirebaseFirestore.instance.collection('Projects').doc(widget.id).get();
    final projectData = projectDoc.data() as Map<String, dynamic>;

    setState(() {
      projectNameController.text = projectData['projectName'] ?? '';
      deadlineController.text = (projectData['deadLine'] as Timestamp?)?.toDate().toString() ?? '';
      messageController.text = projectData['message'] ?? '';
    });

    final fileProvider = Provider.of<FilePickerProvider>(context, listen: false);
    final existingFileUrls = (projectData['fileUrls'] as List<dynamic>?)?.cast<String>() ?? [];
    fileProvider.setExistingFileUrls(existingFileUrls);

    // Load categories and subcategories
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    categoryProvider.setSelectedCategoriesFromMap(projectData['category'] as Map<String, dynamic>?);
  }
  @override
  Widget build(BuildContext context) {

    MySize().init(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final selectedCategoriesData = getSelectedCategoriesData();
    return Stack(
      children: [
        Scaffold(
          backgroundColor: whiteColor,
          appBar: AppBar(
            backgroundColor: whiteColor,
            title: const Text(
              'Create Project', style: AppTextStyles.label14600ATC,),
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
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    children: [
                      Container(
                        // height: 150,
                        color: appColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Container(
                                width: MySize.screenWidth * 0.4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Create Project',
                                      style: AppTextStyles.label14700B,),
                                    SizedBox(height: MySize.size10,),
                                    Text(
                                        'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                                        style: AppTextStyles.label12500BTC),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                              child: Image(image: AssetImage(createProject,),
                                height: MySize.size120,
                                width: MySize.size130,),
                            )

                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(MySize.size20),
                        child: Form(
                          key: _createProjectkey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextField13(
                                controller: projectNameController,
                                hintText: 'Project Name',
                                fillColor: whiteColor,
                                validator: (value) {
                                  return CommonFunctions.validateTextField(value,context,'project name');
                                },
                              ),
                              SizedBox(
                                height: MySize.size16,
                              ),
                              CustomTextField13(
                                controller: deadlineController,
                                hintText: 'Project Deadline',
                                fillColor: whiteColor,
                                readOnly: true,
                                sufixIcon: IconButton(
                                  icon: Icon(Icons.calendar_month),
                                  onPressed: ()async{
                                    await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2101),
                                    ).then((value) {
                                      deadlineController.text = value.toString().replaceRange(11, 23, '');
                                    });
                                  },
                                ),
                                validator: (value) {
                                  return CommonFunctions.validateTextField(value,context,'date');
                                },
                              ),
                              SizedBox(
                                height: MySize.size16,
                              ),
                              AccountReusableContainer(
                                ontap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) =>
                                          ChooseCategoryView()));
                                },
                                height: kIsWeb ? MySize.size50 : MySize.size50,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Text('Project Category',
                                      style: AppTextStyles.label14500BTC,),

                                    Icon(Icons.arrow_forward_ios_rounded,
                                      color: bodyTextColor, size: MySize.size20,)

                                  ],
                                ),),
                              SizedBox(
                                height: MySize.size16,
                              ),
                              Visibility(
                                  visible: selectedCategoriesData.length != 0,
                                  child: Text('Selected Categories')),

                              ListView.builder(
                                itemCount: selectedCategoriesData.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  String categoryKey = selectedCategoriesData.keys.elementAt(index);
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
                                        _showModalBottomSheet(context, categoryKey, selectedCategoriesData[categoryKey]);
                                      },
                                    ),
                                  );
                                },
                              ),
                              Visibility(
                                visible: selectedCategoriesData.length != 0,

                                child: SizedBox(
                                  height: MySize.size16,
                                ),
                              ),
                              CustomTextField13(
                                controller: messageController,
                                hintText: 'Additional Message',
                                fillColor: whiteColor,
                                // validator: (value) {
                                //   return CommonFunctions.validateTextField(value,context,'');
                                // },
                              ),
                              SizedBox(
                                height: MySize.size16,
                              ),
                              Consumer<FilePickerProvider>(
                                builder: (context, filePickerProvider, child) {
                                  return Column(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          await Provider.of<FilePickerProvider>(context, listen: false).pickFiles();
                                        },
                                        child: DottedBorder(
                                          borderType: BorderType.RRect,
                                          color: primaryColor,
                                          strokeWidth: 1,
                                          dashPattern: [5, 2],
                                          radius: Radius.circular(10),
                                          child: Container(
                                            clipBehavior: Clip.hardEdge,
                                            decoration: BoxDecoration(
                                              color: appColor,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(upload),
                                                  SizedBox(width: 10),
                                                  Text('Upload File', style: AppTextStyles.label14700P)
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Wrap(
                                      //     children: [
                                      //       ...filePickerProvider.existingFileUrls.map((url) {
                                      //         return Stack(
                                      //             clipBehavior: Clip.none,
                                      //             children: [
                                      //               Container(
                                      //                 margin: EdgeInsets.all(10),
                                      //                 padding: EdgeInsets.all(10),
                                      //                 decoration: BoxDecoration(
                                      //                   border: Border.all(color: Colors.grey),
                                      //                   borderRadius: BorderRadius.circular(5),
                                      //                 ),
                                      //                 child: Row(
                                      //                   mainAxisSize: MainAxisSize.min,
                                      //                   children: [
                                      //                     SvgPicture.asset(uFile),
                                      //                     SizedBox(width: 10),
                                      //                     SizedBox(
                                      //                       width: MySize.size80,
                                      //                       child: Text(
                                      //                         url.split('/').last,
                                      //                         overflow: TextOverflow.ellipsis,
                                      //                         style: TextStyle(fontSize: 14),
                                      //                       ),
                                      //                     ),
                                      //                   ],
                                      //                 ),
                                      //               ),
                                      //               Positioned(
                                      //                 right: 2,
                                      //                 top: 2,
                                      //                 child: InkWell(
                                      //                   onTap: () {
                                      //                     filePickerProvider.removeExistingFileUrl(url);
                                      //                   },
                                      //                   child: SvgPicture.asset(close, width: 20, height: 20),
                                      //                 ),
                                      //               ),
                                      //             ]);})]),
                                      // SizedBox(height: 20),
                                  Wrap(
                                  children: filePickerProvider.getAllFiles().map((file) {
                                  String fileName;
                                  VoidCallback onRemove;
                                  int i = 1;
                                  print(i);

                                  if (file is File) {
                                  fileName = file.path.split('/').last;
                                  onRemove = () => filePickerProvider.removeFile(file);
                                  } else if (file is PlatformFile) {
                                  fileName = file.name;
                                  onRemove = () => filePickerProvider.removeFile(file);
                                  } else if (file is String) {
                                  fileName = file.split('/').last;
                                  onRemove = () => filePickerProvider.removeExistingFileUrl(file);
                                  } else {
                                  return SizedBox.shrink(); // Skip if file type is unknown
                                  }
                                  i++;

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
                                  fileName,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 14),
                                  ),
                                  ),
                                  ],
                                  ),
                                  ),
                                  Positioned(
                                  right: 2,
                                  top: 2,
                                  child: InkWell(
                                  onTap: onRemove,
                                  child: SvgPicture.asset(
                                  close,
                                  width: 20,
                                  height: 20,
                                  ),
                                  ),
                                  ),
                                  ],
                                  );
                                  }).toList(),
                                  ),
                                    ],
                                  );
                                },
                              ),
                              SizedBox(
                                height: MySize.size26,
                              ),
                              CustomButton8(
                                  text: 'Submit',
                                  onPressed: () {
                                    if (_createProjectkey.currentState!.validate()) {
                                      if (!categoryProvider.hasValidSelection()) {
                                        Utils.toastMessage('Please select at least one category and subcategory');
                                      } else {
                                        final fileProvider = Provider.of<FilePickerProvider>(context, listen: false);
                                        final selectedData = categoryProvider.getSelectedCategoriesWithSubcategories();

                                        if (widget.preview) {
                                          updateProject(
                                              context,
                                              widget.id!,
                                              projectNameController.text,
                                              deadlineController.text,
                                              messageController.text,
                                              selectedData
                                          );
                                        } else {
                                          addProject(
                                              context,
                                              projectNameController.text,
                                              deadlineController.text,
                                              messageController.text
                                          );
                                        }
                                      }
                                    }
                                  }
                              )                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        LoaderView()
      ],
    );
  }

  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            // Return false to prevent dialog from being closed
            return false;
          },
          child: Dialog(
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
                      'Congratulations',
                      style: TextStyle(
                          fontSize: MySize.size20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: MySize.size8),
                    Text(
                      'Order Successfully Placed',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: MySize.size16),
                    CustomButton8(
                      // width:120,
                      height: 40,
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeView()));
                      },
                      text: 'Close',
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void addProject(BuildContext context, String projectName, String deadline, String message) async {
    final docId = DateTime.now().millisecondsSinceEpoch.toString();
    final fileProvider = Provider.of<FilePickerProvider>(context, listen: false);
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    final name = await FirestoreService().fetchUserName();

    if ((kIsWeb && fileProvider.webFiles.isEmpty) || (!kIsWeb && fileProvider.files.isEmpty)) {
      Utils.toastMessage('Please add at least 1 file.');
      return;
    }

    try {
      showUploadProgressDialog(context, fileProvider);

      final fileUrls = await uploadFiles(docId, fileProvider);
      final selectedData = categoryProvider.getSelectedCategoriesWithSubcategories();

      await saveProjectToFirestore(docId, projectName, deadline, message, fileUrls, name, selectedData);

      Navigator.of(context).pop(); // Close the progress dialog
      fileProvider.clearAll();
      showCustomDialog(context);
      Provider.of<CategoryProvider>(context, listen: false).resetSelections();
    } catch (error) {
      Navigator.of(context).pop(); // Close the dialog in case of error
      Utils.toastMessage(error.toString());
    }
  }

  Future<List<String>> uploadFiles(String docId, FilePickerProvider fileProvider) async {
    List<String> fileUrls = [];
    final files = kIsWeb ? fileProvider.webFiles : fileProvider.files;
    int totalFiles = files.length;

    for (int i = 0; i < totalFiles; i++) {
      final file = files[i];
      final fileName = kIsWeb ? (file as PlatformFile).name : (file as File).path.split('/').last;
      final ref = FirebaseStorage.instance.ref().child('uploads/$docId/$fileName');

      UploadTask uploadTask;
      if (kIsWeb) {
        uploadTask = ref.putData((file as PlatformFile).bytes!);
      } else {
        uploadTask = ref.putFile(file as File);
      }

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        fileProvider.uploadProgress.value = ((i + progress / 100) / totalFiles) * 100;
      });

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      fileUrls.add(downloadUrl);
    }

    return fileUrls;
  }
  Future<void> saveProjectToFirestore(String docId, String projectName, String deadline,
      String message, List<String> fileUrls, String? name, Map<String, dynamic> selectedData) async {
    await FirebaseFirestore.instance.collection('Projects').doc(docId).set({
      'projectName': projectName,
      'id': docId,
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'deadLine': DateTime.parse(deadline.trim()),
      'startDate': DateTime.now(),
      'message': message,
      'fileUrls': fileUrls,
      'status': 'Requirements Submitted',
      'price': '',
      'customerName': name ?? '',
      'category': selectedData,
      'paid': false,
      'adminComplete': false,
      'adminMessage': '',
      'adminMessageOnComplete': '',
      'assigned': false,
      'assignedTo': '',
      'assigneeName': ''
    });

    await FirestoreService().setNotifications('admin', 'New Projects Created', '$name has created a new project.', docId);
  }

  void showUploadProgressDialog(BuildContext context, FilePickerProvider fileProvider) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ValueListenableBuilder<double>(
              valueListenable: fileProvider.uploadProgress,
              builder: (context, progress, child) => Column(
                children: [
                  CircularProgressIndicator(value: progress / 100),
                  SizedBox(height: 20),
                  Text('${progress.toStringAsFixed(2)}% uploaded'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _showModalBottomSheet(BuildContext context, String categoryKey, dynamic subcategories) {
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
                    Text(categoryKey, style: AppTextStyles.label14700B),
                    SizedBox(height: 20),
                    if (categoryKey == 'Scheduling')
                      Column(
                        children: [
                          Text('Working Hours: ${subcategories['workingHours']}'),
                          Text('Working Days: ${subcategories['workingDays']}'),
                        ],
                      )
                    else
                      ...List.generate((subcategories as List<String>).length, (index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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

  // void updateProject(BuildContext context, String projectId, String projectName, String deadline,
  //     String message, Map<String, dynamic> categories, List<File> newFiles) async {
  //   final fileProvider = Provider.of<FilePickerProvider>(context, listen: false);
  //   final loadingProvider = Provider.of<LoaderViewProvider>(context, listen: false);
  //
  //   try {
  //     loadingProvider.changeShowLoaderValue(true);
  //     showUploadProgressDialog(context, fileProvider);
  //
  //     // Upload new files if any
  //     List<String> newFileUrls = [];
  //     if (newFiles.isNotEmpty) {
  //       newFileUrls = await uploadFiles(projectId, fileProvider);
  //     }
  //
  //     // Fetch existing project data
  //     DocumentSnapshot projectDoc = await FirebaseFirestore.instance.collection('Projects').doc(projectId).get();
  //     Map<String, dynamic> existingData = projectDoc.data() as Map<String, dynamic>;
  //
  //     // Merge new file URLs with existing ones
  //     List<String> updatedFileUrls = [...existingData['fileUrls'], ...newFileUrls];
  //
  //     // Update project in Firestore
  //     await FirebaseFirestore.instance.collection('Projects').doc(projectId).update({
  //       'projectName': projectName,
  //       'deadLine': DateTime.parse(deadline.trim()),
  //       'message': message,
  //       'category': categories,
  //       // 'fileUrls': updatedFileUrls,
  //     });
  //     loadingProvider.changeShowLoaderValue(false);
  //     fileProvider.clearAll();
  //     Utils.toastMessage('Project updated successfully');
  //   } catch (error) {
  //     loadingProvider.changeShowLoaderValue(false);
  //     Utils.toastMessage(error.toString());
  //   }
  // }

  Future<void> updateProject(BuildContext context, String projectId, String projectName, String deadline,
      String message, Map<String, dynamic> categories) async {
    final fileProvider = Provider.of<FilePickerProvider>(context, listen: false);
    final loadingProvider = Provider.of<LoaderViewProvider>(context, listen: false);

    try {
      loadingProvider.changeShowLoaderValue(true);
      showUploadProgressDialog(context, fileProvider);

      // Upload new files if any
      List<String> newFileUrls = [];
      if (kIsWeb) {
        if (fileProvider.webFiles.isNotEmpty) {
          newFileUrls = await uploadFiles(projectId, fileProvider);
        }
      } else {
        if (fileProvider.files.isNotEmpty) {
          newFileUrls = await uploadFiles(projectId, fileProvider);
        }
      }

      // Merge new file URLs with existing ones
      List<String> updatedFileUrls = [...fileProvider.existingFileUrls, ...newFileUrls];

      // Update project in Firestore
      await FirebaseFirestore.instance.collection('Projects').doc(projectId).update({
        'projectName': projectName,
        'deadLine': DateTime.parse(deadline.trim()),
        'message': message,
        'category': categories,
        'fileUrls': updatedFileUrls,
        'status': 'Requirements Submitted',
        'price': '',
      });

      loadingProvider.changeShowLoaderValue(false);
      fileProvider.clearAll();
      Utils.toastMessage('Project updated successfully');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeView()));
    } catch (error) {
      print(error.toString());
      loadingProvider.changeShowLoaderValue(false);
      Utils.toastMessage(error.toString());
    }
  }
}
