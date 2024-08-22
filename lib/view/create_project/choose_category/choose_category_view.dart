// import 'package:benchmark_estimate/utils/custom_widgets/custom_textfield.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
//
// import '../../../utils/constants/MySize.dart';
// import '../../../utils/constants/colors.dart';
// import '../../../utils/constants/image_path.dart';
// import '../../../utils/constants/textStyles.dart';
// import '../../../utils/custom_widgets/custom_button.dart';
// import '../../../utils/custom_widgets/reusable_container.dart';
//
// class ChooseCategoryView extends StatefulWidget {
//   const ChooseCategoryView({super.key});
//
//   @override
//   _ChooseCategoryViewState createState() => _ChooseCategoryViewState();
// }
//
// class _ChooseCategoryViewState extends State<ChooseCategoryView> {
//   List<String> categories = [
//     'Architecture',
//     'Structure',
//     'Civil',
//     'Mechanical',
//     'Electrical',
//     'Plumbing',
//     'Earthworks',
//     'Scheduling'
//   ];
//
//   List<String> modalOptions = [
//     'Option 1',
//     'Option 2',
//     'Option 3',
//   ];
//   List<Map<String, dynamic>> category = [
//
//   ];
//
//   List<int> selectedCategoryIndexes = [];
//   List<bool> selectedOptions = [true, true, true];
//    bool sch = false;
//
//   void _showModalBottomSheet(BuildContext context, int categoryIndex) {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (BuildContext context, StateSetter setState) {
//             return Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text('Category'),
//
//                   ...List.generate(modalOptions.length, (index) {
//                     return ListTile(
//                       title: Text(modalOptions[index]),
//                       trailing: selectedOptions[index]
//                           ? const Icon(Icons.check, color: primaryColor)
//                           : null,
//                       onTap: () {
//                         setState(() {
//                           selectedOptions[index] = !selectedOptions[index];
//                         });
//                       },
//                     );
//                   }),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     MySize().init(context);
//     return Scaffold(
//       backgroundColor: whiteColor,
//       appBar: AppBar(
//         backgroundColor: whiteColor,
//         title: const Text(
//           'Categories',
//           style: AppTextStyles.label14600ATC,
//         ),
//         centerTitle: true,
//         automaticallyImplyLeading: true,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               width: double.infinity,
//               height: 0.5,
//               decoration: const BoxDecoration(
//                 color: secondaryColor,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 2,
//                     spreadRadius: 2,
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 20.0),
//               child: Column(
//                 children: [
//                   Container(
//                     color: appColor,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(20.0),
//                           child: Container(
//                             width: MySize.screenWidth * 0.4,
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Text(
//                                   'Create Project',
//                                   style: AppTextStyles.label14700B,
//                                 ),
//                                 SizedBox(height: MySize.size10),
//                                 Text(
//                                   'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
//                                   style: AppTextStyles.label12500BTC,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
//                           child: Image(
//                             image: AssetImage(categoryImage),
//                             height: MySize.size120,
//                             width: MySize.size130,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: MySize.size20,),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal:MySize.size20),
//                     child: Column(
//                       children: List.generate(categories.length, (index) {
//                         return Padding(
//                           padding: EdgeInsets.only(bottom: MySize.scaleFactorHeight * 12),
//                           child: CategoryReusableContainer(
//                             height: 50,
//                             ontap: () {
//                               setState(() {
//                                 if (selectedCategoryIndexes.contains(index)) {
//                                   if(categories[index] == 'Scheduling'){
//                                     sch = !sch;
//                                     setState(() {
//
//                                     });
//                                   }
//                                   selectedCategoryIndexes.remove(index);
//                                 } else {
//                                   selectedCategoryIndexes.add(index);
//                                   if(categories[index] == 'Scheduling'){
//                                     sch = !sch;
//                                     setState(() {
//
//                                     });
//                                   }else{
//                                     _showModalBottomSheet(context, index);
//                                   }
//                                 }
//                               });
//                             },
//                             bgColor: selectedCategoryIndexes.contains(index) ? primaryColor : whiteColor,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   categories[index],
//                                   style: selectedCategoryIndexes.contains(index)
//                                       ? AppTextStyles.label13500W
//                                       : AppTextStyles.label13500B,
//                                 ),
//                                 if (selectedCategoryIndexes.contains(index))
//                                   const Icon(Icons.check, color: whiteColor)
//                               ],
//                             ),
//                           ),
//                         );
//                       }),
//                     ),
//                   ),
//                   // SizedBox(height: MySize.scaleFactorHeight * 12,),
//
//                   Visibility(
//                     visible: sch,
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding:  EdgeInsets.symmetric(horizontal: MySize.size20),
//                           child:  Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               SizedBox(
//                                 width: kIsWeb ? MySize.scaleFactorWidth * 160:MySize.scaleFactorWidth * 160,
//                                 child: const CustomTextField13(
//                                   fillColor: whiteColor,
//                                   hintText: 'Working Hours',
//                                 ),
//                               ),
//                               SizedBox(
//                                   width: kIsWeb ? MySize.scaleFactorWidth * 160:MySize.scaleFactorWidth * 160,
//                                   child: const CustomTextField13(
//                                     fillColor: whiteColor,
//                                     hintText: 'Working Days',
//                                   )),
//
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: MySize.size20,),
//                       ],
//                     ),
//                   ),
//
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: MySize.size20),
//                     child: CustomButton8(text: 'Submit', onPressed: () {}),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/foundation.dart';
// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import '../../../utils/constants/MySize.dart';
// // import '../../../utils/constants/colors.dart';
// // import '../../../utils/constants/image_path.dart';
// // import '../../../utils/constants/textStyles.dart';
// // import '../../../utils/custom_widgets/custom_button.dart';
// // import '../../../utils/custom_widgets/reusable_container.dart';
// // import '../../../utils/custom_widgets/custom_textfield.dart';
// // import '../../../view_model/provider/category_provider.dart';
//
// // class ChooseCategoryView extends StatefulWidget {
// //   const ChooseCategoryView({super.key});
// //
// //   @override
// //   _ChooseCategoryViewState createState() => _ChooseCategoryViewState();
// // }
// //
// // class _ChooseCategoryViewState extends State<ChooseCategoryView> {
// //   @override
// //   void initState() {
// //     super.initState();
// //     fetchCategories();
// //   }
// //
// //   TextEditingController daysController = TextEditingController();
// //   TextEditingController hoursController = TextEditingController();
// //
// //   Future<void> fetchCategories() async {
// //     final snapshot = await FirebaseFirestore.instance.collection('Categories').get();
// //     final categories = snapshot.docs.map((doc) => doc.data()).toList();
// //     context.read<CategoryProvider>().setCategories(categories);
// //   }
// //
// //   void _showModalBottomSheet(BuildContext context, int categoryIndex) {
// //     final provider = context.read<CategoryProvider>();
// //     showModalBottomSheet(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return StatefulBuilder(
// //           builder: (BuildContext context, StateSetter setState) {
// //             return Padding(
// //               padding: const EdgeInsets.all(20.0),
// //               child: Column(
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: [
// //                   Text('Category'),
// //                   ...List.generate(provider.categories[categoryIndex]['subCategory'].length, (index) {
// //                     return ListTile(
// //                       title: Text(provider.categories[categoryIndex]['subCategory'][index]),
// //                       trailing: provider.selectedOptions[index]
// //                           ? const Icon(Icons.check, color: primaryColor)
// //                           : null,
// //                       onTap: () {
// //                         setState(() {
// //                           provider.toggleOption(categoryIndex, index);
// //                         });
// //                       },
// //                     );
// //                   }),
// //                 ],
// //               ),
// //             );
// //           },
// //         );
// //       },
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     MySize().init(context);
// //     final provider = context.watch<CategoryProvider>();
// //     return Scaffold(
// //       backgroundColor: whiteColor,
// //       appBar: AppBar(
// //         backgroundColor: whiteColor,
// //         title: const Text(
// //           'Categories',
// //           style: AppTextStyles.label14600ATC,
// //         ),
// //         centerTitle: true,
// //         automaticallyImplyLeading: true,
// //       ),
// //       body: SingleChildScrollView(
// //         child: Column(
// //           children: [
// //             Container(
// //               width: double.infinity,
// //               height: 0.5,
// //               decoration: const BoxDecoration(
// //                 color: secondaryColor,
// //                 boxShadow: [
// //                   BoxShadow(
// //                     color: Colors.black12,
// //                     blurRadius: 2,
// //                     spreadRadius: 2,
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             Padding(
// //               padding: const EdgeInsets.symmetric(vertical: 20.0),
// //               child: Column(
// //                 children: [
// //                   Container(
// //                     color: appColor,
// //                     child: Row(
// //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                       children: [
// //                         Padding(
// //                           padding: const EdgeInsets.all(20.0),
// //                           child: Container(
// //                             width: MySize.screenWidth * 0.4,
// //                             child: Column(
// //                               crossAxisAlignment: CrossAxisAlignment.start,
// //                               children: [
// //                                 const Text(
// //                                   'Create Project',
// //                                   style: AppTextStyles.label14700B,
// //                                 ),
// //                                 SizedBox(height: MySize.size10),
// //                                 Text(
// //                                   'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
// //                                   style: AppTextStyles.label12500BTC,
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                         ),
// //                         Padding(
// //                           padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
// //                           child: Image(
// //                             image: AssetImage(categoryImage),
// //                             height: MySize.size120,
// //                             width: MySize.size130,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                   SizedBox(height: MySize.size20),
// //                   Padding(
// //                     padding: EdgeInsets.symmetric(horizontal: MySize.size20),
// //                     child: Column(
// //                       children: List.generate(provider.categories.length, (index) {
// //                         return Padding(
// //                           padding: EdgeInsets.only(bottom: MySize.scaleFactorHeight * 12),
// //                           child: CategoryReusableContainer(
// //                             height: 50,
// //                             ontap: () {
// //                               provider.toggleCategory(index);
// //                               if (provider.categories[index]['categoryName'] != 'Scheduling' && provider.isSchedulingSelected) {
// //                                 provider.toggleCategory(0); // Unselect Scheduling
// //                               } else if (provider.categories[index]['categoryName'] != 'Scheduling') {
// //                                 _showModalBottomSheet(context, index);
// //                               }
// //                             },
// //                             bgColor: provider.selectedCategoryIndexes.contains(index) || (index == 0 && provider.isSchedulingSelected)
// //                                 ? primaryColor
// //                                 : whiteColor,
// //                             child: Row(
// //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                               children: [
// //                                 Text(
// //                                   provider.categories[index]['categoryName'],
// //                                   style: provider.selectedCategoryIndexes.contains(index) || (index == 0 && provider.isSchedulingSelected)
// //                                       ? AppTextStyles.label13500W
// //                                       : AppTextStyles.label13500B,
// //                                 ),
// //                                 if (provider.selectedCategoryIndexes.contains(index) || (index == 0 && provider.isSchedulingSelected))
// //                                   const Icon(Icons.check, color: whiteColor)
// //                               ],
// //                             ),
// //                           ),
// //                         );
// //                       }),
// //                     ),
// //                   ),
// //                   Visibility(
// //                     visible: provider.isSchedulingSelected,
// //                     child: Column(
// //                       children: [
// //                         Padding(
// //                           padding: EdgeInsets.symmetric(horizontal: MySize.size20),
// //                           child: Row(
// //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                             children: [
// //                               SizedBox(
// //                                 width: kIsWeb ? MySize.scaleFactorWidth * 160 : MySize.scaleFactorWidth * 160,
// //                                 child:  CustomTextField13(
// //                                   fillColor: whiteColor,
// //                                   hintText: 'Working Hours',
// //                                   controller: hoursController,
// //                                 ),
// //                               ),
// //                               SizedBox(
// //                                 width: kIsWeb ? MySize.scaleFactorWidth * 160 : MySize.scaleFactorWidth * 160,
// //                                 child:  CustomTextField13(
// //                                   fillColor: whiteColor,
// //                                   hintText: 'Working Days',
// //                                   controller: daysController,
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                         SizedBox(height: MySize.size20),
// //                       ],
// //                     ),
// //                   ),
// //                   Padding(
// //                     padding: EdgeInsets.symmetric(horizontal: MySize.size20),
// //                     child: CustomButton8(
// //                       text: 'Submit',
// //                       onPressed: () {
// //                         final selectedData = provider.getSelectedData();
// //                         // Navigate to another screen and pass the selectedData
// //                         // Navigator.push(context, MaterialPageRoute(builder: (context) => NextScreen(selectedData: selectedData)));
// //                       },
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
