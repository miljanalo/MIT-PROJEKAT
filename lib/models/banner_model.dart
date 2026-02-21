import 'package:cloud_firestore/cloud_firestore.dart';

enum BannerType {
  book,
  promo,
  author,       
  explore,       
  other,    
}

class BannerItem {
  final String id;
  final String imagePath;   
  final String title;        
  final String subtitle;     
  final BannerType type;
  final String? bookId;
  final bool isActive;
  final int order;      

  BannerItem({
    required this.id,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.type,
    this.bookId,
    required this.isActive,
    required this.order
  });

  factory BannerItem.fromFirestore(DocumentSnapshot doc){
    final data = doc.data() as Map<String, dynamic>;

    return BannerItem(
      id: doc.id,
      imagePath: data['imagePath'] ?? '',
      title: data['title'] ?? '',
      subtitle: data['subtitle'] ?? '',
      type: BannerType.values.firstWhere(
        (e) => e.name ==data['type'],
        orElse: () => BannerType.other,
      ),
      bookId: data['bookId'],
      isActive: data['isActive'] ?? true,
      order: data['order'] ?? 0,
    );
  }

  Map<String, dynamic> toMap(){
    return{
      'imagePath': imagePath,
      'title': title,
      'subtitle': subtitle,
      'type': type.name,
      'bookId': bookId,
      'isActive': isActive,
      'order': order,
    };
  }
}

