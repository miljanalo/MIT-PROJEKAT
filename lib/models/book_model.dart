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

  factory BookModel.fromFirestore(
    String id,
    Map<String, dynamic> data,
  ){
    return BookModel(
      id: id,
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      description: data['description'] ?? '',
      price: double.tryParse(
          data['price']?.toString() ?? '0',
        ) ??
        0,
      imagePath: data['imagePath'] ?? ''
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'author': author,
      'description': description,
      'price': price,
      'imagePath': imagePath,
    };
  }
}