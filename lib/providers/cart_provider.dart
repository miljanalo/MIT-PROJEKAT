import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:knjizara/models/book_model.dart';
import 'package:knjizara/models/cart_item_model.dart';

class CartProvider with ChangeNotifier{

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference? get _cartRef {
    final user = _auth.currentUser;
    if(user == null) return null;
    return _firestore
      .collection('users')
      .doc(user.uid)
      .collection('cart');
  }

  Stream<List<CartItemModel>> get cartStream {

    final ref = _cartRef;

    if(ref == null){
      return Stream.value([]);
    }

    return ref.snapshots().map((snapshot) {

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

    final ref = _cartRef;
    if(ref == null) return;
    
    final doc = await ref.doc(book.id).get();

    if(doc.exists){

      final currentQty = doc['quantity'] ?? 1;

      await ref.doc(book.id).update({
        'quantity': currentQty + 1,
      });

    }
    else {
      
      await ref.doc(book.id).set({
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

    final ref = _cartRef;
    if(ref == null) return;

    final doc = await ref.doc(bookId).get();
    if (doc.exists) {
      final currentQty = doc['quantity'] ?? 1;
        await ref.doc(bookId).update({
          'quantity': currentQty + 1,
        });
    } 
  }

  Future<void> decreaseQuantity(String bookId) async {

    final ref = _cartRef;
    if(ref == null) return;

    final doc = await ref.doc(bookId).get();

    if (doc.exists) {
      final currentQty = doc['quantity'] ?? 1;

      if (currentQty > 1) {
        await ref.doc(bookId).update({
          'quantity': currentQty - 1,
        });
      } else {
        await ref.doc(bookId).delete();
      }
    }
  }

  Future<void> removeFromCart(String bookId) async {

    final ref = _cartRef;
    if(ref == null) return;

    await ref.doc(bookId).delete();
  }

  Future<void> clearCart() async {

    final ref = _cartRef;
    if(ref == null) return;

    final snapshot = await ref.get();

    for(var doc in snapshot.docs){
      await doc.reference.delete();
    } 
  }
}

