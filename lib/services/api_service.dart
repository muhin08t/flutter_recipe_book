
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';

class ApiService {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1/categories.php';

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(
      Uri.parse(baseUrl),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['categories'];
      return results.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load category');
    }
  }
}