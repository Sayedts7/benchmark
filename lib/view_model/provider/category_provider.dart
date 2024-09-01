import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CategoryProvider with ChangeNotifier {
  List<String> categories = [];
  Map<String, List<String>> subCategories = {};
  List<int> selectedCategoryIndexes = [];
  List<List<bool>> selectedOptions = [];
  bool sch = false;
  TextEditingController days = TextEditingController();
  TextEditingController hours = TextEditingController();

  Future<void> fetchCategories() async {
    final categoriesSnapshot = await FirebaseFirestore.instance.collection('Categories').get();
    categories = categoriesSnapshot.docs.map((doc) => doc['categoryName'] as String).toList();
    subCategories = {
      for (var doc in categoriesSnapshot.docs)
        doc['categoryName']: List<String>.from(doc['subCategory'])
    };
    // Initialize selectedOptions with true for all subcategories
    selectedOptions = List.generate(
      categories.length,
          (index) => List.generate(subCategories[categories[index]]!.length, (index) => true),
    );
    notifyListeners();
  }

  void toggleCategorySelection(int index) {
    if (categories[index] == 'Scheduling') {
      selectedCategoryIndexes = [index];
      sch = true;
    } else {
      selectedCategoryIndexes.removeWhere((element) => categories[element] == 'Scheduling');
      updateSelectedCategoryIndexes(index);
      sch = false;
    }
    notifyListeners();
  }

  void toggleAllSubCategorySelection(int categoryIndex) {
    bool allSelected = selectedOptions[categoryIndex].every((element) => element);
    for (int i = 0; i < selectedOptions[categoryIndex].length; i++) {
      selectedOptions[categoryIndex][i] = !allSelected;
    }
    updateSelectedCategoryIndexes(categoryIndex);
    notifyListeners();
  }

  void toggleSubCategorySelection(int categoryIndex, int subCategoryIndex) {
    selectedOptions[categoryIndex][subCategoryIndex] = !selectedOptions[categoryIndex][subCategoryIndex];
    updateSelectedCategoryIndexes(categoryIndex);
    notifyListeners();
  }

  void updateSelectedCategoryIndexes(int categoryIndex) {
    if (selectedOptions[categoryIndex].contains(true)) {
      if (!selectedCategoryIndexes.contains(categoryIndex)) {
        selectedCategoryIndexes.add(categoryIndex);
      }
    } else {
      selectedCategoryIndexes.remove(categoryIndex);
    }
  }

  bool areAllSubCategoriesSelected(int categoryIndex) {
    return selectedOptions[categoryIndex].every((element) => element);
  }

  void updateTextControllers(String hour, String day) {
    days.text = day;
    hours.text = hour;
    notifyListeners();
  }

  Map<String, dynamic> getSelectedCategoriesWithSubcategories() {
    Map<String, dynamic> selectedData = {};
    for (int i = 0; i < selectedCategoryIndexes.length; i++) {
      int categoryIndex = selectedCategoryIndexes[i];
      String category = categories[categoryIndex];
      if (category == 'Scheduling') {
        selectedData[category] = {
          'workingHours': hours.text,
          'workingDays': days.text,
        };
      } else {
        List<String> selectedSubCategories = [];
        for (int j = 0; j < selectedOptions[categoryIndex].length; j++) {
          if (selectedOptions[categoryIndex][j]) {
            selectedSubCategories.add(subCategories[category]![j]);
          }
        }
        selectedData[category] = selectedSubCategories;
      }
    }
    return selectedData;
  }

  void resetSelections() {
    selectedCategoryIndexes.clear();
    sch = false;
    days.clear();
    hours.clear();

    // Reset all subcategory selections to true
    selectedOptions = List.generate(
      categories.length,
          (index) => List.generate(subCategories[categories[index]]!.length, (index) => true),
    );

    notifyListeners();
  }

  void addCategory(String category) {
    if (!categories.contains(category)) {
      categories.add(category);
      subCategories[category] = [];
      selectedOptions.add([]);
      notifyListeners();
    }
  }

  void removeCategory(String category) {
    int index = categories.indexOf(category);
    if (index != -1) {
      categories.removeAt(index);
      subCategories.remove(category);
      selectedOptions.removeAt(index);
      selectedCategoryIndexes.remove(index);
      notifyListeners();
    }
  }

  void addSubcategory(String category, String subcategory) {
    if (subCategories.containsKey(category) && !subCategories[category]!.contains(subcategory)) {
      subCategories[category]!.add(subcategory);
      int categoryIndex = categories.indexOf(category);
      selectedOptions[categoryIndex].add(true);
      notifyListeners();
    }
  }

  void removeSubcategory(String category, String subcategory) {
    if (subCategories.containsKey(category)) {
      int index = subCategories[category]!.indexOf(subcategory);
      if (index != -1) {
        subCategories[category]!.removeAt(index);
        int categoryIndex = categories.indexOf(category);
        selectedOptions[categoryIndex].removeAt(index);
        notifyListeners();
      }
    }
  }

  void setPreviewCategories(Map<String, dynamic> previewCategories) {
    selectedCategoryIndexes.clear();
    for (int i = 0; i < categories.length; i++) {
      String category = categories[i];
      if (previewCategories.containsKey(category)) {
        selectedCategoryIndexes.add(i);
        if (category == 'Scheduling') {
          sch = true;
          hours.text = previewCategories[category]['workingHours'];
          days.text = previewCategories[category]['workingDays'];
        } else {
          List<String> selectedSubcats = List<String>.from(previewCategories[category]);
          for (int j = 0; j < subCategories[category]!.length; j++) {
            selectedOptions[i][j] = selectedSubcats.contains(subCategories[category]![j]);
          }
        }
      }
    }
    notifyListeners();
  }

  bool hasValidSelection() {
    if (selectedCategoryIndexes.isEmpty) {
      return false;
    }

    for (int categoryIndex in selectedCategoryIndexes) {
      if (categories[categoryIndex] == 'Scheduling') {
        // For Scheduling, we just need to ensure it's selected
        return true;
      } else {
        // For other categories, check if at least one subcategory is selected
        if (selectedOptions[categoryIndex].contains(true)) {
          return true;
        }
      }
    }

    return false;
  }

  void setSelectedCategoriesFromMap(Map<String, dynamic>? categoryMap) {
    if (categoryMap == null) return;

    selectedCategoryIndexes.clear();
    sch = false;
    hours.clear();
    days.clear();

    categoryMap.forEach((category, value) {
      int categoryIndex = categories.indexOf(category);
      if (categoryIndex != -1) {
        selectedCategoryIndexes.add(categoryIndex);

        if (category == 'Scheduling') {
          sch = true;
          hours.text = value['workingHours'] ?? '';
          days.text = value['workingDays'] ?? '';
        } else {
          List<String> selectedSubcats = (value as List<dynamic>).cast<String>();
          for (int j = 0; j < subCategories[category]!.length; j++) {
            selectedOptions[categoryIndex][j] = selectedSubcats.contains(subCategories[category]![j]);
          }
        }
      }
    });

    notifyListeners();
  }
}