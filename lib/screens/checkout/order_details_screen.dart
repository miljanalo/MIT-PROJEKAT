import 'package:flutter/material.dart';
import 'package:knjizara/models/order_model.dart';

String orderStatusText(OrderStatus status) {
  switch (status) {
    case OrderStatus.pending:
      return 'Na čekanju';
    case OrderStatus.approved:
      return 'Odobreno';
    case OrderStatus.shipped:
      return 'Poslato';
    case OrderStatus.cancelled:
      return 'Otkazano';
    case OrderStatus.delivered:
      return 'Isporučeno';
  }
}

Color orderStatusColor(OrderStatus status) {
  switch (status) {
    case OrderStatus.pending:
      return Colors.orange;
    case OrderStatus.approved:
      return Colors.blue;
    case OrderStatus.shipped:
      return Colors.green;
    case OrderStatus.cancelled:
      return Colors.red;
    case OrderStatus.delivered:
      return Colors.blueGrey;
  }
}

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsScreen({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Datum: ${order.date.day}.${order.date.month}.${order.date.year}',
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 12),

            Text(
              'Order ID: ${order.id}',
              style: const TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                const Text(
                  'Status: ',
                  style: TextStyle(fontSize: 16),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: orderStatusColor(order.status).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    orderStatusText(order.status),
                    style: TextStyle(
                      color: orderStatusColor(order.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              'Proizvodi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            ...order.items.map(
              (item) => Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  title: Text(item.book.title),
                  subtitle: Text('Količina: ${item.quantity}'),
                  trailing: Text(
                    '${(item.book.price * item.quantity).toStringAsFixed(0)} RSD',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

            const Divider(),

            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Ukupno: ${order.totalPrice.toStringAsFixed(0)} RSD',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
