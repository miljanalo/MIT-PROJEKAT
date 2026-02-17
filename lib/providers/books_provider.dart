import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:knjizara/models/book_model.dart';

class BooksProvider with ChangeNotifier {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<BookModel>> get booksStream {
    return _firestore
      .collection('books')
      .snapshots()
      .map((snapshot){
        return snapshot.docs.map((doc){
          return BookModel.fromFirestore(doc.id, doc.data());
        }).toList();
      });
  }

  Future<void> addBook(BookModel book) async {
    await _firestore
      .collection('books')
      .add(book.toFirestore());
  }

  Future<void> updateBook(String id, BookModel updatedBook) async {
    await _firestore
      .collection('books')
      .doc(id)
      .update(updatedBook.toFirestore());
  }

  Future<void> removeBook(String id) async{
    await _firestore
      .collection('books')
      .doc(id)
      .delete();
  }
}
