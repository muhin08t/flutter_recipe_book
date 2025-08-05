import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recipe_book/models/category.dart';
import 'package:provider/provider.dart';

import '../providers/bottom_nav_provider.dart';
import '../providers/category_provider.dart';
import '../providers/selected_category_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Ensure context is ready before accessing Provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
      categoryProvider.fetchCategories(); // Fetch default recipes
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0),

          child: Column(
            children: [
              Expanded(
                child: categoryProvider.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns in the grid
                    crossAxisSpacing: 8.0, // Spacing between columns
                    mainAxisSpacing: 8.0, // Spacing between rows
                    childAspectRatio: 0.75, // Aspect ratio of each item (width / height)
                  ),
                  itemCount: categoryProvider.categories.length,
                  itemBuilder: (context, index) {
                    Category category = categoryProvider.categories[index];
                    return InkWell(
                        onTap: () {
                      print('Tapped on ${category.title}');
                      final selectedCategory = category.title;

                      // 1. Set selected category
                      Provider.of<SelectedCategoryProvider>(context, listen: false)
                          .setCategory(selectedCategory);
                      Provider.of<BottomNavProvider>(context, listen: false).setIndex(1);
                      // Navigate or perform action here
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
                                imageUrl: category.image,
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
                              category.title,
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