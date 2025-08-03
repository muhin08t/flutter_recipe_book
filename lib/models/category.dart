class Category {
  final String id;
  final String title;
  final String image;
  final String description;
  // final String summary;

  Category({
    required this.id,
    required this.title,
    required this.image,
    required this.description,
    // required this.summary,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['idCategory'].toString(),
      title: json['strCategory'],
      image: json['strCategoryThumb'],
      description: json['strCategoryDescription'],
      // summary: json['summary'],
    );
  }
}