import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recipe_book/models/recipe_details.dart';
import 'package:provider/provider.dart';
import '../providers/recipe_provider.dart';
import 'recipe_details_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenScreenState();

}

  class _FavoriteScreenScreenState extends State<FavoriteScreen> {

  @override
  void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
  final recipeProvider = Provider.of<RecipeProvider>(context, listen: false);
  recipeProvider.loadFavorites(); // Fetch default recipes
  });
  }

  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);

    return Scaffold(
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

                  itemCount: recipeProvider.favorites.length,
                  itemBuilder: (context, index) {
                    RecipeDetails recipe = recipeProvider.favorites[index];
                    return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipeDetailsScreen(id: recipe.id,),
                            ),
                          );
                        },
                        child: Card(
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
                        )
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
