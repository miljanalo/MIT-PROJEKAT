import 'package:flutter/material.dart';
import 'package:knjizara/models/order_model.dart';

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
      body: Padding(
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

            const SizedBox(height: 24),

            const Text(
              'Proizvodi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: ListView.builder(
                itemCount: order.items.length,
                itemBuilder: (context, index) {
                  final item = order.items[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(item.book.title),
                      subtitle: Text('Količina: ${item.quantity}'),
                      trailing: Text(
                        '${(item.book.price * item.quantity).toStringAsFixed(0)} RSD',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
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
