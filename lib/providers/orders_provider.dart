import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:knjizara/models/book_model.dart';
import 'package:knjizara/models/order_model.dart';
import 'package:knjizara/models/cart_item_model.dart';

class OrdersProvider with ChangeNotifier {
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _ordersRef {
    return _firestore.collection('orders');
  }

  Stream<List<OrderModel>> ordersStream({
    required bool isAdmin,
    required String userId,
  }) {

    Query query = _ordersRef;

    // user vidi samo svoje porudzbine

    if(!isAdmin) {
      query = query.where(
        'userId',
        isEqualTo: userId,
      );
    }

    query = query.orderBy('createdAt', descending: true);

    return query
        
        .snapshots()
        .map((snapshot) {

      return snapshot.docs.map((doc) {

        final data =
          doc.data() as Map<String, dynamic>;

        final items =
          (data['items'] as List)
            .map((item) {

          return CartItemModel(
            quantity: item['quantity'],
            book: BookModel(
              id: item['bookId'],
              title: item['title'],
              author: item['author'],
              description: '',
              price:
                  (item['price'] as num)
                      .toDouble(),
              imagePath:
                  item['imagePath'],
            ),
          );
        }).toList();

      return OrderModel(
        id: doc.id,
        userId: data['userId'],
        customerName: data['customerName'] ?? '',
        customerEmail: data['customerEmail'] ?? '',
        items: items,
        totalPrice:
          (data['totalPrice'] as num).toDouble(),
        date:
          (data['createdAt'] as Timestamp).toDate(),
        address: data['address'] ?? '',
        phoneNumber: data['phoneNumber'] ?? '',
        status: 
          OrderStatus.values[data['status'] ?? 0],
      );
      }).toList();
    });
  }   

  Future<void> addOrder({
    required String userId,
    required String customerName,
    required String customerEmail,
    required List<CartItemModel> items,
    required double totalPrice,
    required String address,
    required String phoneNumber,
  }) async {

    await _ordersRef.add({
      'userId' : userId,
      'totalPrice': totalPrice,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'createdAt': Timestamp.now(),
      'address': address,
      'phoneNumber': phoneNumber,
      'status': OrderStatus.pending.index,
      'items': items.map((item){
        return {
          'bookId': item.book.id,
          'title': item.book.title,
          'author': item.book.author,
          'price': item.book.price,
          'imagePath': item.book.imagePath,
          'quantity': item.quantity,
        };
      }).toList(),
    });
  }

  Future<void> updateOrderStatus(
    String orderId,
    OrderStatus newStatus
  ) async {
    await _ordersRef
      .doc(orderId)
      .update({
        'status': newStatus.index,
      });
  }
}


