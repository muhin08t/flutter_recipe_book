import 'package:flutter/material.dart';

class SelectedCategoryProvider with ChangeNotifier {
  String _selectedCategory = 'Pasta';

  String? get selectedCategory => _selectedCategory;

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }
}
