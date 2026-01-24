import 'package:flutter/material.dart';
import 'package:knjizara/screens/checkout/order_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:knjizara/providers/orders_provider.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Orders'),
        centerTitle: true,
      ),
      body: ordersProvider.isEmpty
          ? const Center(
              child: Text(
                'Nema porudžbina',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: ordersProvider.orders.length,
              itemBuilder: (context, index) {
                final order = ordersProvider.orders[index];
                return Card(
                  margin: const EdgeInsets.all(12),
                  child: ListTile(
                    title: Text(
                      'Porudžbina #${order.id.substring(order.id.length - 6)}'
                    ),
                    subtitle: Text(
                      '${order.items.length} proizvoda • ${order.totalPrice.toStringAsFixed(2)} RSD',
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OrderDetailsScreen(order: order)
                        )
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
