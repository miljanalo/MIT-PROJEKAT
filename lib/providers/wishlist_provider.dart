import 'package:flutter/material.dart';
import 'package:knjizara/models/book_model.dart';

class WishlistProvider with ChangeNotifier {
  final List<BookModel> _wishlist = [];

  List<BookModel> get wishlist => _wishlist;

  bool isInWishlist(BookModel book) {
    return _wishlist.any((item) => item.id == book.id);
  }

  void toggleWishlist(BookModel book) {
    if (isInWishlist(book)) {
      _wishlist.removeWhere((item) => item.id == book.id);
    } else {
      _wishlist.add(book);
    }
    notifyListeners();
  }

  void removeFromWishlist(BookModel book) {
    _wishlist.removeWhere((item) => item.id == book.id);
    notifyListeners();
  }

  bool get isEmpty => _wishlist.isEmpty;
}
