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
  final String userId;
  final String? customerName;
  final String? customerEmail;
  final List<CartItemModel> items;
  final double totalPrice;
  final DateTime date;
  final String address;
  final String phoneNumber;
  final OrderStatus status;

  OrderModel({
    required this.id,
    required this.userId,
    required this.customerName,
    required this.customerEmail,
    required this.items,
    required this.totalPrice,
    required this.date,
    required this.address,
    required this.phoneNumber,
    this.status = OrderStatus.pending
  });
}
