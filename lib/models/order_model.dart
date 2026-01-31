import 'package:knjizara/models/cart_item_model.dart';

enum OrderStatus {
  pending,
  approved,
  shipped,
  delivered,
  cancelled,
}

class OrderModel {
  final String id;
  final List<CartItemModel> items;
  final double totalPrice;
  final DateTime date;
  final OrderStatus status;

  OrderModel({
    required this.id,
    required this.items,
    required this.totalPrice,
    required this.date,
    this.status = OrderStatus.pending
  });
}
