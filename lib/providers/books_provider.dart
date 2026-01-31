import 'package:flutter/material.dart';
import 'package:knjizara/data/books_data.dart';
import 'package:knjizara/models/book_model.dart';

class BooksProvider with ChangeNotifier {
  final List<BookModel> _books = [...booksList];

  List<BookModel> get books => _books;

  void addBook(BookModel book) {
    _books.add(book);
    notifyListeners();
  }

  void updateBook(String id, BookModel updatedBook) {
    final index = _books.indexWhere((book) => book.id == id);
    if (index >= 0) {
      _books[index] = updatedBook;
      notifyListeners();
    }
  }

  void removeBook(String id) {
    _books.removeWhere((book) => book.id == id);
    notifyListeners();
  }
}
