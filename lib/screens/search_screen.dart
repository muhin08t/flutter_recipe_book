import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/recipe.dart';
import '../providers/recipe_provider.dart';
import '../providers/selected_category_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final recipeProvider = Provider.of<RecipeProvider>(context, listen: false);
      recipeProvider.clearRecipes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             // SizedBox(height: 15), // Space between title and search field
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 15), // Add padding
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for recipes',
                  filled: true, // Adds background color
                  fillColor: Colors.white, // Optional: Set background color
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      recipeProvider.fetchSearchByRecipes(_searchController.text);
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5), // Rounded corners
                    borderSide: BorderSide.none, // Removes the default border
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: Colors.grey.shade300), // Light grey border
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: Colors.blue, width: 2), // Highlighted border
                  ),
                ),
              ),
            ),
          ],
        ),
        // backgroundColor: Color(0xFFd7456a),
        // toolbarHeight: 130, // Increase height to fit search bar
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0),

          child: Column(
            children: [
              Expanded(
                child: recipeProvider.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns in the grid
                    crossAxisSpacing: 8.0, // Spacing between columns
                    mainAxisSpacing: 8.0, // Spacing between rows
                    childAspectRatio: 0.75, // Aspect ratio of each item (width / height)
                  ),

                  itemCount: recipeProvider.recipes.length,
                  itemBuilder: (context, index) {
                    Recipe recipe = recipeProvider.recipes[index];
                    return Card(
                      elevation: 2.0, // Add a shadow to the card
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0), // Rounded corners
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(8.0), // Rounded top corners
                              ),
                              // child: Image.network(
                              //   recipe.image,
                              //   fit: BoxFit.cover, // Ensure the image covers the space
                              // ),
                              child: CachedNetworkImage(
                                imageUrl: recipe.image,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey.shade300,
                                ),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              recipe.title,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2, // Limit the title to 2 lines
                              overflow: TextOverflow.ellipsis, // Add ellipsis if overflow
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}