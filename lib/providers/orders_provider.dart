import 'package:flutter/material.dart';
import 'package:knjizara/models/order_model.dart';
import 'package:knjizara/models/cart_item_model.dart';

class OrdersProvider with ChangeNotifier {
  final List<OrderModel> _orders = [];

  List<OrderModel> get orders => _orders;

  void addOrder({
    required List<CartItemModel> items,
    required double totalPrice,
  }) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    _orders.insert(
      0,
      OrderModel(
        id: timestamp.toString(),
        items: List.from(items), // VAŽNO: kopija liste
        totalPrice: totalPrice,
        date: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  bool get isEmpty => _orders.isEmpty;
}
