class BookModel {
  final String id;
  final String title;
  final String author;
  final String description;
  final double price;
  final String imagePath;
  final bool isFavorite;

  BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.price,
    required this.imagePath,
    this.isFavorite = false,
  });
}