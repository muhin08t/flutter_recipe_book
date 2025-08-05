import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/api_service.dart';

class RecipeProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Recipe> _recipes = [];
  bool _isLoading = false;

  List<Recipe> get recipes => _recipes;
  bool get isLoading => _isLoading;

  Future<void> fetchCategoryBasedRecipes(String category) async {
    _isLoading = true;
    notifyListeners();

    try {
      _recipes = await _apiService.fetchCategoryBasedRecipes(category);
      print("recipe length ${_recipes.length}");
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}