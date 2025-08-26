import 'package:flutter/material.dart';
import 'package:flutter_recipe_book/models/recipe_details.dart';
import '../db/database_helper.dart';
import '../models/recipe.dart';
import '../services/api_service.dart';

class RecipeProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Recipe> _recipes = [];
  bool _isLoading = false;
  RecipeDetails? _selectedRecipeDetails;
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<RecipeDetails> _favorites = [];

  List<Recipe> get recipes => _recipes;
  bool get isLoading => _isLoading;
  RecipeDetails? get selectedRecipeDetails => _selectedRecipeDetails;
  List<RecipeDetails> get favorites => _favorites;

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

  Future<void> fetchSearchByRecipes(String query) async {
    _isLoading = true;
    notifyListeners();

    try {
      _recipes = await _apiService.fetchSearchByRecipes(query);
      print("search recipe length ${_recipes.length}");
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchRecipeDetails(String id) async {
    _isLoading = true;
    notifyListeners();
    try {
      _selectedRecipeDetails = await _apiService.fetchRecipeDetails(id);
      print('title value: ${_selectedRecipeDetails?.title}');
    } catch (e) {
      print("Error fetching recipe details: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearRecipes() {
    _recipes = [];
    notifyListeners();
  }

  void clearRecipeDetails() {
    _selectedRecipeDetails = null;
    notifyListeners();
  }

  Future<void> loadFavorites() async {
    _favorites = await _dbHelper.getFavorites();
    notifyListeners();
  }

  Future<void> toggleFavorite(RecipeDetails recipeDetails) async {
    final isFav = await _dbHelper.isFavorite(recipeDetails.id);

    if (isFav) {
      await _dbHelper.deleteFavorite(recipeDetails.id);
      _favorites.removeWhere((r) => r.id == recipeDetails.id);
    } else {
      await _dbHelper.insertFavorite(recipeDetails);
      _favorites.add(recipeDetails);
    }

    notifyListeners();
  }

  Future<bool> isFavorite(String id) async {
    return await _dbHelper.isFavorite(id);
  }
}