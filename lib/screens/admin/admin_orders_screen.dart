import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:knjizara/providers/orders_provider.dart';
import 'package:knjizara/models/order_model.dart';

class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Orders'),
        centerTitle: true,
      ),
      body: ordersProvider.isEmpty
          ? const Center(child: Text('Nema porudžbina'))
          : ListView.builder(
              itemCount: ordersProvider.orders.length,
              itemBuilder: (context, index) {
                final order = ordersProvider.orders[index];

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order #${order.id.substring(order.id.length - 6)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Ukupno: ${order.totalPrice.toStringAsFixed(0)} RSD',
                        ),
                        const SizedBox(height: 8),

                        // 🔽 STATUS DROPDOWN
                        DropdownButton<OrderStatus>(
                          value: order.status,
                          isExpanded: true,
                          items: OrderStatus.values.map((status) {
                            return DropdownMenuItem(
                              value: status,
                              child: Text(_statusText(status)),
                            );
                          }).toList(),
                          onChanged: (newStatus) {
                            if (newStatus != null) {
                              ordersProvider.updateOrderStatus(
                                order.id,
                                newStatus,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  String _statusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Na čekanju';
      case OrderStatus.approved:
        return 'Odobrena';
      case OrderStatus.shipped:
        return 'Poslata';
      case OrderStatus.delivered:
        return 'Isporučena';
      case OrderStatus.cancelled:
        return 'Otkazana';
    }
  }
}
