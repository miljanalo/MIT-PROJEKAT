import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:knjizara/models/book_model.dart';
import 'package:knjizara/models/cart_item_model.dart';

class CartProvider with ChangeNotifier{

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get _cartRef {
    final uid = _auth.currentUser!.uid;
    return _firestore
      .collection('users')
      .doc(uid)
      .collection('cart');
  }

  Stream<List<CartItemModel>> get cartStream {
    return _cartRef.snapshots().map((snapshot) {

      return snapshot.docs.map((doc) {

        final data = doc.data() as Map<String, dynamic>;

        final book = BookModel(
          id: doc.id,
          title: data['title'],
          author: data['author'],
          description: '',
          price: (data['price'] as num).toDouble(),
          imagePath: data['imagePath'],
        );

        return CartItemModel(
          book: book,
          quantity: data['quantity'],
        );
      }).toList();
    });
  }

  Future<void> addToCart(BookModel book) async {
    
    final doc = await _cartRef.doc(book.id).get();

    if(doc.exists){

      final currentQty = doc['quantity'] ?? 1;

      await _cartRef.doc(book.id).update({
        'quantity': currentQty + 1,
      });

    }
    else {
      
      await _cartRef.doc(book.id).set({
        'title': book.title,
        'author': book.author,
        'price': book.price,
        'imagePath': book.imagePath,
        'quantity': 1,
      });
    }

    notifyListeners();
  }

  Future<void> increaseQuantity(String bookId) async {
    final doc = await _cartRef.doc(bookId).get();
    if (doc.exists) {
      final currentQty = doc['quantity'] ?? 1;
        await _cartRef.doc(bookId).update({
          'quantity': currentQty + 1,
        });
    } 
  }

  Future<void> decreaseQuantity(String bookId) async {
    final doc = await _cartRef.doc(bookId).get();

    if (doc.exists) {
      final currentQty = doc['quantity'] ?? 1;

      if (currentQty > 1) {
        await _cartRef.doc(bookId).update({
          'quantity': currentQty - 1,
        });
      } else {
        await _cartRef.doc(bookId).delete();
      }
    }
  }

  Future<void> removeFromCart(String bookId) async {
    await _cartRef.doc(bookId).delete();
  }

  Future<void> clearCart() async {
    final snapshot = await _cartRef.get();

    for(var doc in snapshot.docs){
      await doc.reference.delete();
    } 
  }
}

