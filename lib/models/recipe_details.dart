class RecipeDetails {
  final String id;
  final String title;
  final String image;
  final String instructions;
  final String ingredient1;
  final String ingredient2;
  final String ingredient3;
  final String ingredient4;
  final String ingredient5;
  final String measure1;
  final String measure2;
  final String measure3;
  final String measure4;
  final String measure5;


  RecipeDetails({
    required this.id,
    required this.title,
    required this.image,
    required this.instructions,
    required this.ingredient1,
    required this.ingredient2,
    required this.ingredient3,
    required this.ingredient4,
    required this.ingredient5,
    required this.measure1,
    required this.measure2,
    required this.measure3,
    required this.measure4,
    required this.measure5,
  });

  factory RecipeDetails.fromJson(Map<String, dynamic> json) {
    return RecipeDetails(
      id: json['idMeal']?.toString() ?? '',
      title: json['strMeal'] ?? 'Unknown',
      image: json['strMealThumb'] ?? '',
      instructions: json['strInstructions'] ?? '',
      ingredient1: json['strIngredient1'] ?? '',
      ingredient2: json['strIngredient2'] ?? '',
      ingredient3: json['strIngredient3'] ?? '',
      ingredient4: json['strIngredient4'] ?? '',
      ingredient5: json['strIngredient5'] ?? '',
      measure1: json['strMeasure1'] ?? '',
      measure2: json['strMeasure2'] ?? '',
      measure3: json['strMeasure3'] ?? '',
      measure4: json['strMeasure4'] ?? '',
      measure5: json['strMeasure5'] ?? '',
    );
  }
}