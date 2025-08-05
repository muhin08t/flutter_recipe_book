class Category {
  final String id;
  final String title;
  final String image;
  final String description;

  Category({
    required this.id,
    required this.title,
    required this.image,
    required this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['idCategory']?.toString() ?? '',
      title: json['strCategory'] ?? 'Unknown',
      image: json['strCategoryThumb'] ?? '',
      description: json['strCategoryDescription'] ?? '',
    );
  }
}