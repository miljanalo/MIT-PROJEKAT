import 'package:knjizara/models/cart_item_model.dart';

class OrderModel {
  final String id;
  final List<CartItemModel> items;
  final double totalPrice;
  final DateTime date;

  OrderModel({
    required this.id,
    required this.items,
    required this.totalPrice,
    required this.date,
  });
}
