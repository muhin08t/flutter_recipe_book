import 'package:flutter/material.dart';
import 'package:flutter_recipe_book/providers/bottom_nav_provider.dart';
import 'package:flutter_recipe_book/providers/category_provider.dart';
import 'package:flutter_recipe_book/providers/recipe_provider.dart';
import 'package:flutter_recipe_book/providers/selected_category_provider.dart';
import 'package:flutter_recipe_book/screens/home_screen.dart';
import 'package:flutter_recipe_book/screens/recipe_screen.dart';
import 'package:flutter_recipe_book/screens/search_screen.dart';
import 'package:flutter_recipe_book/screens/settings_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp( MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => CategoryProvider()),
      ChangeNotifierProvider(create: (_) => BottomNavProvider()),
      ChangeNotifierProvider(create: (_) => SelectedCategoryProvider()),
      ChangeNotifierProvider(create: (_) => RecipeProvider()),
    ],
    child: MyApp(),
  ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipe book',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepPurple,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static final List<Widget> _screens = <Widget>[
    HomeScreen(),
    RecipeScreen(),
    SearchScreen(),
    SettingsScreen(),
  ];


  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavProvider>(
        builder: (context, bottomNav, _)
    {
      return Scaffold(
        appBar: AppBar(title: const Text('Recipe book')),
        body: _screens[bottomNav.currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: bottomNav.currentIndex,
          onTap: (index) => bottomNav.setIndex(index),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.restaurant_menu), label: 'Recipe'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Settings'),
          ],
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.amber[800],
          // backgroundColor: Colors.black, // 👈 Add this line
          // unselectedItemColor: Colors.red,  // 👈 Optional for better contrast
        ),
      );
    }
    );
  }
}
