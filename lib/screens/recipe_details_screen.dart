import 'package:flutter/material.dart';
import 'package:flutter_recipe_book/providers/recipe_provider.dart';
import 'package:provider/provider.dart';

import '../models/recipe_details.dart';

class RecipeDetailsScreen extends StatefulWidget {
  const RecipeDetailsScreen({super.key, required this.id});

  final String id;

  @override
  State<RecipeDetailsScreen> createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {

  @override
  void initState() {
    super.initState();

    // Ensure context is ready before accessing Provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final recipeProvider = Provider.of<RecipeProvider>(context, listen: false);
      recipeProvider.clearRecipeDetails();
      recipeProvider.fetchRecipeDetails(widget.id); // Fetch default recipes
    });
  }

  int servings = 2;
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);
    RecipeDetails? recipeDetails = recipeProvider.selectedRecipeDetails;
    if (recipeDetails == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()), // show loader
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        // Back button (top-left)
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.pink),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        // Center title
        title:  Text(
          recipeDetails.title,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        // Right side buttons
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
            padding: const EdgeInsets.only(top: 1.0),
                child: Image.network(
                  recipeDetails.image,
                  width: double.infinity,
                  height: 240,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child; // ✅ Image is fully loaded
                    }
                    return SizedBox(
                      width: double.infinity,
                      height: 240,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2), // small spinner
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox(
                      width: double.infinity,
                      height: 240,
                      child: Center(
                        child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                      ),
                    );
                  },
                ),
        ),
            sectionHeader("Ingredients"),
            // Divider(),

            // Ingredients list
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  buildCard(recipeDetails.ingredient1, recipeDetails.measure1),
                  buildCard(recipeDetails.ingredient2, recipeDetails.measure2),
                  buildCard(recipeDetails.ingredient3, recipeDetails.measure3),
                  buildCard(recipeDetails.ingredient4, recipeDetails.measure4),
                  buildCard(recipeDetails.ingredient5, recipeDetails.measure5),
                ],
              ),
            ),
            // Divider(),
            sectionHeader('Instructions'),
            // Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                recipeDetails.instructions,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
            ),

            SizedBox(height: 20), // Space before bottom button
          ],
        ),
      ),
    );
  }

  Widget ingredientRow(String name, String quantity, {String? highlight}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                text: name,
                style: TextStyle(color: Colors.black87, fontSize: 16),
                children: highlight != null
                    ? [
                  TextSpan(
                    text: highlight,
                    style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold),
                  ),
                ]
                    : [],
              ),
            ),
          ),
          Text(quantity, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  // Method that returns a Card widget
  Widget buildCard(String title, String quantity) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side (Title)
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),

            // Right side (Quantity)
            Text(
              quantity,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16,horizontal:  16),
      child: Row(
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        ],
      ),
    );
  }
}

