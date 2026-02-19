import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:knjizara/models/book_model.dart';
import 'package:knjizara/models/order_model.dart';
import 'package:knjizara/models/cart_item_model.dart';

class OrdersProvider with ChangeNotifier {
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get _ordersRef {
    return _firestore.collection('orders');
  }

  Stream<List<OrderModel>> ordersStream({
    required bool isAdmin,
    required String userId,
  }) {

    Query query = _ordersRef;

    if(!isAdmin) {
      query = query.where(
        'userId',
        isEqualTo: userId,
      );
    }

    return query
        .orderBy('createdAt', descending: true)
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
        items: items,
        totalPrice:
          (data['totalPrice'] as num).toDouble(),
        date:
          (data['createdAt'] as Timestamp).toDate(),
        status: 
          OrderStatus.values[data['status'] ?? 0],
      );
      }).toList();
    });
  }   

  Future<void> addOrder({
    required List<CartItemModel> items,
    required double totalPrice,
  }) async {

    final uid = _auth.currentUser!.uid;

    await _ordersRef.add({
      'userId' : uid,
      'totalPrice': totalPrice,
      'createdAt': Timestamp.now(),
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


