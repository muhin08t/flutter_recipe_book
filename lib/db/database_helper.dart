import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/recipe.dart';
import '../models/recipe_details.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "recipes.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE favorites (
            idMeal TEXT PRIMARY KEY,
            strMeal TEXT,
            strMealThumb TEXT,
            strInstructions TEXT,
            strIngredient1 TEXT,
            strIngredient2 TEXT,
            strIngredient3 TEXT,
            strIngredient4 TEXT,
            strIngredient5 TEXT,
            strMeasure1 TEXT,
            strMeasure2 TEXT,
            strMeasure3 TEXT,
            strMeasure4 TEXT,
            strMeasure5 TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertFavorite(RecipeDetails recipeDetails) async {
    final db = await database;
    return await db.insert("favorites", recipeDetails.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> deleteFavorite(String id) async {
    final db = await database;
    return await db.delete("favorites", where: "idMeal = ?", whereArgs: [id]);
  }

  Future<List<RecipeDetails>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("favorites");
    return maps.map((json) => RecipeDetails.fromJson(json)).toList();
  }

  Future<bool> isFavorite(String id) async {
    final db = await database;
    final result =
    await db.query("favorites", where: "idMeal = ?", whereArgs: [id]);
    return result.isNotEmpty;
  }
}
