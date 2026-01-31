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

  void updateOrderStatus(String orderId, OrderStatus newStatus) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index] = OrderModel(
        id: _orders[index].id,
        items: _orders[index].items,
        totalPrice: _orders[index].totalPrice,
        date: _orders[index].date,
        status: newStatus,
      );
      notifyListeners();
    }
  }

  OrderModel? getOrderById(String id) {
    try {
      return _orders.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }


  bool get isEmpty => _orders.isEmpty;
}
