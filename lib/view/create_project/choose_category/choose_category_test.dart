  import 'package:benchmark_estimate/utils/utils.dart';
  import 'package:flutter/foundation.dart';
  import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';
  import '../../../utils/constants/MySize.dart';
  import '../../../utils/constants/colors.dart';
  import '../../../utils/constants/image_path.dart';
  import '../../../utils/constants/textStyles.dart';
  import '../../../utils/custom_widgets/custom_button.dart';
  import '../../../utils/custom_widgets/custom_textfield.dart';
  import '../../../utils/custom_widgets/reusable_container.dart';
  import '../../../view_model/provider/category_provider.dart';

  class ChooseCategoryView extends StatefulWidget {
    const ChooseCategoryView({super.key});

    @override
    _ChooseCategoryViewState createState() => _ChooseCategoryViewState();
  }

  class _ChooseCategoryViewState extends State<ChooseCategoryView> {
    @override
    void initState() {
      super.initState();
      final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
      if (categoryProvider.categories.isEmpty) {
        categoryProvider.fetchCategories();
      }
    }

    void _showModalBottomSheet(BuildContext context, int categoryIndex) {
      final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              final subCategoryList = categoryProvider.subCategories[categoryProvider.categories[categoryIndex]];
              if (subCategoryList == null) {
                return Center(child: Text('No subcategories available'));
              }
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 60,),
                          Text('Category', style: AppTextStyles.label14700B,),
                          TextButton(onPressed: (){
                            setState(() {
                              categoryProvider.unselectAllSubCategorySelection(categoryIndex);
                            });
                            }, child: Text('Unselect all'))
                        ],
                      ),
                      ...List.generate(subCategoryList.length, (index) {
                        return ListTile(
                          title: Text(subCategoryList[index]),
                          trailing: categoryProvider.selectedOptions[categoryIndex][index]
                              ? const Icon(Icons.check, color: primaryColor)
                              : null,
                          onTap: () {
                            setState(() {
                              categoryProvider.toggleSubCategorySelection(categoryIndex, index);
                            });
                          },
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
  TextEditingController hoursController = TextEditingController();
    TextEditingController daysController = TextEditingController();

    @override
    Widget build(BuildContext context) {
      MySize().init(context);
      final categoryProvider = Provider.of<CategoryProvider>(context);
      return Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          backgroundColor: whiteColor,
          title: const Text(
            'Categories',
            style: AppTextStyles.label14600ATC,
          ),
          centerTitle: true,
          automaticallyImplyLeading: true,
        ),
        body: categoryProvider.categories.isEmpty
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
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
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  children: [
                    Container(
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
                                  const Text(
                                    'Create Project',
                                    style: AppTextStyles.label14700B,
                                  ),
                                  SizedBox(height: MySize.size10),
                                  Text(
                                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                                    style: AppTextStyles.label12500BTC,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                            child: Image(
                              image: AssetImage(categoryImage),
                              height: MySize.size120,
                              width: MySize.size130,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: MySize.size20,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: MySize.size20),
                      child: Column(
                        children: List.generate(categoryProvider.categories.length, (index) {
                          bool isSelected = categoryProvider.selectedCategoryIndexes.contains(index);
                          return Padding(
                            padding: EdgeInsets.only(bottom: MySize.scaleFactorHeight * 12),
                            child: CategoryReusableContainer(
                              height: 50,
                              ontap: () {
                                setState(() {
                                  categoryProvider.toggleCategorySelection(index);
                                  if (categoryProvider.categories[index] != 'Scheduling') {
                                    if (categoryProvider.selectedCategoryIndexes.contains(index)) {
                                      _showModalBottomSheet(context, index);
                                    }
                                  }
                                });
                              },
                              bgColor: isSelected ? primaryColor : whiteColor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    categoryProvider.categories[index],
                                    style: isSelected
                                        ? AppTextStyles.label13500W
                                        : AppTextStyles.label13500B,
                                  ),
                                  if (isSelected)
                                    const Icon(Icons.check, color: whiteColor)
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),                    Visibility(
                      visible: categoryProvider.sch,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: MySize.size20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: kIsWeb ? MySize.scaleFactorWidth * 160 : MySize.scaleFactorWidth * 160,
                                  child:  CustomTextField13(
                                    fillColor: whiteColor,
                                    hintText: 'Working Hours',
                                    controller: hoursController,
                                  ),
                                ),
                                SizedBox(
                                  width: kIsWeb ? MySize.scaleFactorWidth * 160 : MySize.scaleFactorWidth * 160,
                                  child:  CustomTextField13(
                                    fillColor: whiteColor,
                                    hintText: 'Working Days',
                                    controller: daysController,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: MySize.size20,),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: MySize.size20),
                      child: CustomButton8(
                        text: 'Submit',
                        onPressed: () {
                          final selectedData = categoryProvider.getSelectedCategoriesWithSubcategories();
                          print(selectedData);

                          // Check if the selected category includes 'Scheduling'
                          if (selectedData.containsKey('Scheduling')) {
                            if(hoursController.text.isEmpty){
                              Utils.toastMessage('Please enter hours');
                            }else if(daysController.text.isEmpty){
                              Utils.toastMessage('Please enter days');
                            }else{
                              categoryProvider.updateTextControllers(hoursController.text, daysController.text);
                              Navigator.pop(context);
                            }
                            // Perform specific action if 'Scheduling' is selected
                            // For example, save additional data related to scheduling
                            print('Scheduling category is selected');
                            // Add your specific logic here

                          } else {
                            Navigator.pop(context);
                            // Perform general save logic
                            print('Scheduling category is not selected');
                            // Add your general save logic here
                          }

                          // Navigate back or perform other actions
                          // Navigator.pop(context);
                        },
                      ),
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
