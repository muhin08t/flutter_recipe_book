import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/api_service.dart';

class CategoryProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Category> _categories = [];
  bool _isLoading = false;

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;

  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      _categories = await _apiService.fetchCategories();
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}