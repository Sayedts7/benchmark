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
 final String? message;
 final String? id;
 final Map<String, dynamic>? categories;
 final bool preview;
   const CreateProjectView({super.key, this.projectName, this.date, this.message, required this.preview, this.categories, this.id});

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
    super.initState();
  }
  void setPreviewCategories() {
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    categoryProvider.setPreviewCategories(widget.categories!);
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
                                          await filePickerProvider.pickFiles();
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
                                                mainAxisAlignment: MainAxisAlignment
                                                    .center,
                                                children: [
                                                  SvgPicture.asset(upload),
                                                  SizedBox(width: 10,),
                                                  Text('Upload File',
                                                    style: AppTextStyles
                                                        .label14700P,)
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      if (kIsWeb)
                                        Wrap(
                                          children: filePickerProvider.webFiles
                                              .map((file) {
                                            return Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.all(10),
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.grey),
                                                    borderRadius: BorderRadius
                                                        .circular(5),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize
                                                        .min,
                                                    children: [
                                                      SvgPicture.asset(uFile),
                                                      SizedBox(width: 10),
                                                      SizedBox(
                                                        width: MySize.size80,
                                                        child: Text(
                                                          file.name,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontSize: 14),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Positioned(
                                                  right: 2,
                                                  top: 2,
                                                  child: InkWell(
                                                    onTap: () {
                                                      filePickerProvider
                                                          .removeWebFile(file);
                                                    },
                                                    child: SvgPicture.asset(
                                                      close, width: 20,
                                                      height: 20,),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }).toList(),
                                        )
                                      else
                                        Wrap(
                                          children: filePickerProvider.files.map((
                                              file) {
                                            return Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.all(10),
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.grey),
                                                    borderRadius: BorderRadius
                                                        .circular(5),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize
                                                        .min,
                                                    children: [
                                                      SvgPicture.asset(uFile),
                                                      SizedBox(width: 10),
                                                      SizedBox(
                                                        width: MySize.size80,
                                                        child: Text(
                                                          file.path
                                                              .split('/')
                                                              .last,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontSize: 14),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Positioned(
                                                  right: 2,
                                                  top: 2,
                                                  child: InkWell(
                                                    onTap: () {
                                                      filePickerProvider
                                                          .removeFile(file);
                                                    },
                                                    child: SvgPicture.asset(
                                                      close, width: 20,
                                                      height: 20,),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }).toList(),
                                        ),
                                    ],
                                  );
                                },
                              ), SizedBox(
                                height: MySize.size26,
                              ),
                              CustomButton8(text: 'Submit', onPressed: () {
                                // print('hello');
                                if (_createProjectkey.currentState!.validate()) {
                                  if (!categoryProvider.hasValidSelection()) {
                                    Utils.toastMessage('Please select at least one category and subcategory');
                                  }else {
                                  if(widget.preview){
                                    final selectedData = categoryProvider.getSelectedCategoriesWithSubcategories();

                                    //add update project function here
                                    FirebaseFirestore.instance.collection('Projects').doc(widget.id).update({
                                      'status': 'Project Submitted',
                                      'price': '',
                                      'projectName': projectNameController.text,
                                      'deadLine': DateTime.parse(deadlineController.text.trim()),
                                      'message': messageController.text,
                                      // 'fileUrls': fileUrls,
                                      'category': selectedData,


                                    });

                                  }else{
                                    addProject(context,
                                        projectNameController.text,
                                        deadlineController.text,
                                        messageController.text
                                    );
                                  }
                                  }
                                }
                              })
                            ],
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
        );
      },
    );
  }

  void addProject(BuildContext context, String projectName, String deadline,
      String message) async {
    var docId = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
    final fileProvider = Provider.of<FilePickerProvider>(
        context, listen: false);
    final categoryProvider = Provider.of<CategoryProvider>(
        context, listen: false);
    String? name = await  FirestoreService().fetchUserName();

    List<String> fileUrls = [];

   if(kIsWeb && fileProvider.webFiles.isNotEmpty){
     try {
       int totalFiles = kIsWeb ? fileProvider.webFiles.length : fileProvider
           .files.length;
       int uploadedFiles = 0;

       // Show the progress dialog
       showDialog(
         context: context,
         barrierDismissible: false,
         builder: (context) {
           return AlertDialog(
             content: Column(
               mainAxisSize: MainAxisSize.min,
               children: [
                 ValueListenableBuilder<double>(
                   valueListenable: fileProvider.uploadProgress,
                   builder: (context, progress, child) {
                     return Column(
                       children: [
                         CircularProgressIndicator(value: progress / 100),
                         SizedBox(height: 20),
                         Text('${progress.toStringAsFixed(2)}% uploaded'),
                       ],
                     );
                   },
                 ),
               ],
             ),
           );
         },
       );

       if (kIsWeb) {
         // For web
         for (var file in fileProvider.webFiles) {
           String fileName = file.name;
           var ref = FirebaseStorage.instance.ref().child(
               'uploads/$docId/$fileName');
           UploadTask uploadTask = ref.putData(file.bytes!);

           uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
             double progress = (snapshot.bytesTransferred /
                 snapshot.totalBytes) * 100;
             fileProvider.uploadProgress.value = progress;
           });

           TaskSnapshot snapshot = await uploadTask;
           String downloadUrl = await snapshot.ref.getDownloadURL();
           fileUrls.add(downloadUrl);

           uploadedFiles++;
           fileProvider.uploadProgress.value =
               (uploadedFiles / totalFiles) * 100;
         }
       }
       else {
         // For mobile
         for (var file in fileProvider.files) {
           String fileName = file.path
               .split('/')
               .last;
           var ref = FirebaseStorage.instance.ref().child(
               'uploads/$docId/$fileName');
           UploadTask uploadTask = ref.putFile(file);

           uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
             double progress = (snapshot.bytesTransferred /
                 snapshot.totalBytes) * 100;
             fileProvider.uploadProgress.value = progress;
           });

           TaskSnapshot snapshot = await uploadTask;
           String downloadUrl = await snapshot.ref.getDownloadURL();
           fileUrls.add(downloadUrl);

           uploadedFiles++;
           fileProvider.uploadProgress.value =
               (uploadedFiles / totalFiles) * 100;
         }
       }
       final selectedData = categoryProvider.getSelectedCategoriesWithSubcategories();

       // Save project details along with file URLs in Firestore
       await FirebaseFirestore.instance.collection('Projects').doc(docId).set({
         'projectName': projectName,
         'id': docId,
         'userId': FirebaseAuth.instance.currentUser!.uid,
         'deadLine': DateTime.parse(deadline.trim()),
         'startDate': DateTime.now(),
         'message': message,
         'fileUrls': fileUrls,
         'status': 'Project Submitted',
         'price': '',
         'customerName': name ?? '',
         'category': selectedData,
         'paid': false,
         'adminComplete': false,
         'adminMessage': '',
         'adminMessageOnComplete': '',
         'assigned': false,
         'assignedTo': '',
         'assigneeName':''


       }).then((value) {
         FirestoreService().setNotifications('admin', 'New Projects Created', '$name has created a new project.', docId);

       });

       Navigator.of(context).pop(); // Close the dialog
       fileProvider.clearAll();
       showCustomDialog(context);
       Provider.of<CategoryProvider>(context, listen: false).resetSelections();

     } catch (error) {
       Navigator.of(context).pop(); // Close the dialog in case of error
       Utils.toastMessage(error.toString());
     }
   }
   else if(!kIsWeb && fileProvider.files.isNotEmpty ){
     try {
       int totalFiles = kIsWeb ? fileProvider.webFiles.length : fileProvider
           .files.length;
       int uploadedFiles = 0;

       // Show the progress dialog
       showDialog(
         context: context,
         barrierDismissible: false,
         builder: (context) {
           return AlertDialog(
             content: Column(
               mainAxisSize: MainAxisSize.min,
               children: [
                 ValueListenableBuilder<double>(
                   valueListenable: fileProvider.uploadProgress,
                   builder: (context, progress, child) {
                     return Column(
                       children: [
                         CircularProgressIndicator(value: progress / 100),
                         SizedBox(height: 20),
                         Text('${progress.toStringAsFixed(2)}% uploaded'),
                       ],
                     );
                   },
                 ),
               ],
             ),
           );
         },
       );

       if (kIsWeb) {
         // For web
         for (var file in fileProvider.webFiles) {
           String fileName = file.name;
           var ref = FirebaseStorage.instance.ref().child(
               'uploads/$docId/$fileName');
           UploadTask uploadTask = ref.putData(file.bytes!);

           uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
             double progress = (snapshot.bytesTransferred /
                 snapshot.totalBytes) * 100;
             fileProvider.uploadProgress.value = progress;
           });

           TaskSnapshot snapshot = await uploadTask;
           String downloadUrl = await snapshot.ref.getDownloadURL();
           fileUrls.add(downloadUrl);

           uploadedFiles++;
           fileProvider.uploadProgress.value =
               (uploadedFiles / totalFiles) * 100;
         }
       } else {
         // For mobile
         for (var file in fileProvider.files) {
           String fileName = file.path
               .split('/')
               .last;
           var ref = FirebaseStorage.instance.ref().child(
               'uploads/$docId/$fileName');
           UploadTask uploadTask = ref.putFile(file);

           uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
             double progress = (snapshot.bytesTransferred /
                 snapshot.totalBytes) * 100;
             fileProvider.uploadProgress.value = progress;
           });

           TaskSnapshot snapshot = await uploadTask;
           String downloadUrl = await snapshot.ref.getDownloadURL();
           fileUrls.add(downloadUrl);

           uploadedFiles++;
           fileProvider.uploadProgress.value =
               (uploadedFiles / totalFiles) * 100;
         }
       }
       final selectedData = categoryProvider.getSelectedCategoriesWithSubcategories();

       // Save project details along with file URLs in Firestore
       await FirebaseFirestore.instance.collection('Projects').doc(docId).set({
         'projectName': projectName,
         'id': docId,
         'userId': FirebaseAuth.instance.currentUser!.uid,
         'deadLine': DateTime.parse(deadline.trim()),
         'startDate': DateTime.now(),
         'message': message,
         'fileUrls': fileUrls,
         'status': 'Project Submitted',
         'price': '',
         'customerName': name ?? '',
         'category': selectedData,
         'paid': false,
         'adminComplete': false,
         'adminMessage': '',
         'adminMessageOnComplete': '',
         'assigned': false,
         'assignedTo': '',
         'assigneeName':''

       }).then((value) {
         FirestoreService().setNotifications('admin', 'New Projects Created', '$name has created a new project.',docId);
       });

       Navigator.of(context).pop(); // Close the dialog
       fileProvider.clearAll();
       showCustomDialog(context);
       Provider.of<CategoryProvider>(context, listen: false).resetSelections();

     } catch (error) {
       Navigator.of(context).pop(); // Close the dialog in case of error
       Utils.toastMessage(error.toString());
     }
   }
   else{
     Utils.toastMessage('Please add at least 1 file.');
   }
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
}