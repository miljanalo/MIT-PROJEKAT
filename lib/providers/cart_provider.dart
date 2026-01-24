import 'package:flutter/widgets.dart';
import 'package:knjizara/models/book_model.dart';
import 'package:knjizara/models/cart_item_model.dart';

class CartProvider with ChangeNotifier{
  final List<CartItemModel> _items = [];

  List<CartItemModel> get items => _items;

  void addToCart(BookModel book){
    final index = _items.indexWhere((item) => item.book.id == book.id);

    if(index >= 0){
      _items[index].quantity++;
    }
    else {
      _items.add(CartItemModel(book: book));
    }

    notifyListeners();
  }

  double get totalPrice {
    double total = 0;
    for(var item in _items){
      total += item.book.price * item.quantity;
    }
    return total;
  }

  int get totalItems {
  int total = 0;
  for (var item in _items) {
    total += item.quantity;
  }
  return total;
}

  bool get isEmpty => _items.isEmpty;

void increaseQuantity(BookModel book) {
  final index = _items.indexWhere((item) => item.book.id == book.id);
  if (index >= 0) {
    _items[index].quantity++;
    notifyListeners();
  }
}

void decreaseQuantity(BookModel book) {
  final index = _items.indexWhere((item) => item.book.id == book.id);
  if (index >= 0) {
    if (_items[index].quantity > 1) {
      _items[index].quantity--;
    } else {
      _items.removeAt(index);
    }
    notifyListeners();
  }
}

void removeFromCart(BookModel book) {
  _items.removeWhere((item) => item.book.id == book.id);
  notifyListeners();
}

void clearCart() {
  _items.clear();
  notifyListeners();
}


}

