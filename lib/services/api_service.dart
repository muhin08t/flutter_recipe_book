
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/recipe.dart';

class ApiService {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(
      Uri.parse('$baseUrl/categories.php'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['categories'];
      return results.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load category');
    }
  }

  Future<List<Recipe>> fetchCategoryBasedRecipes(String category) async {
    String total = '$baseUrl/filter.php?c=$category';
    print("total url value "+total);
    final response = await http.get(
      Uri.parse('$baseUrl/filter.php?c=$category'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['meals'];
      return results.map((json) => Recipe.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  Future<List<Recipe>> fetchSearchByRecipes(String query) async {
    String total = '$baseUrl/search.php?s=$query';
    print("total url value "+total);
    final response = await http.get(
      Uri.parse('$baseUrl/search.php?s=$query'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['meals'];
      return results.map((json) => Recipe.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load search recipes');
    }
  }
}