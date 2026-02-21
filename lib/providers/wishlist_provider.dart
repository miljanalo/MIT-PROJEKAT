import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:knjizara/models/book_model.dart';

class WishlistProvider with ChangeNotifier {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference wishlistRef(String userId){
    return _firestore
      .collection('users') 
      .doc(userId)
      .collection('wishlist');
  } 

  Stream<List<BookModel>> wishlistStream(String userId) {
    return wishlistRef(userId)
      .snapshots()
      .map((snapshot){
        return snapshot.docs.map((doc){
          final data = doc.data() as Map<String, dynamic>;

          return BookModel(
            id: doc.id,
            title: data['title'],
            author: data['author'],
            description: data['description'],
            price: (data['price'] as num).toDouble(),
            imagePath: data['imagePath'],
          );
        }).toList();
      });
  }

  Stream<bool> isInWishlistStream(String userId, String bookId) {
    return wishlistRef(userId)
      .doc(bookId)
      .snapshots()
      .map((doc) => doc.exists);
  }

  Future<void> toggleWishlist(String userId, BookModel book) async {

    final doc = wishlistRef(userId).doc(book.id);

    final snapshot = await doc.get();

    if (snapshot.exists) {
      await doc.delete();
    } else {
      await doc.set({
        'title': book.title,
        'author': book.author,
        'description': book.description,
        'price': book.price,
        'imagePath': book.imagePath,
      });
    }
  }

  Future<void> removeFromWishlist(String userId, String bookId) async {
    await wishlistRef(userId).doc(bookId).delete();
  }
}
