import 'package:knjizara/models/book_model.dart';

class BannerItem {
  final String? imagePath;   
  final String title;        
  final String subtitle;     
  final BannerType type;
  final BookModel? book; // za specifične knjige     

  BannerItem({
    this.imagePath,
    required this.title,
    required this.subtitle,
    required this.type,
    this.book
  });
}

enum BannerType {
  book,
  promo,
  author,       
  explore,       
  else_,    
}