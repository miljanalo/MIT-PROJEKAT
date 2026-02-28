import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:knjizara/providers/orders_provider.dart';
import 'package:knjizara/models/order_model.dart';

class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Orders'),
        centerTitle: true,
      ),
      body: StreamBuilder<List<OrderModel>>(
        stream: context
          .read<OrdersProvider>()
          .ordersStream(
            isAdmin: true,
            userId: ''
          ),
        builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('Nema porudžbina'),
          );
        }

        final orders = snapshot.data!;
        
        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {

            final order = orders[index];

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
                      'Porudžbina na ime: ${order.customerName ?? "N/A"}',
                    ),

                    Text(
                      'Email: ${order.customerEmail ?? "N/A"}',
                    ),

                    Text(
                      'Adresa isporuke: ${order.address}',
                    ),

                    Text(
                      'Kontakt telefon: ${order.phoneNumber}',
                    ),

                    const Divider(),

                    Text(
                      'Ukupno: ${order.totalPrice.toStringAsFixed(0)} RSD',
                    ),

                    const SizedBox(height: 8),

                    DropdownButton<OrderStatus>(
                      value: order.status,
                      isExpanded: true,
                      items: OrderStatus.values.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(_statusText(status)),
                        );
                      }).toList(),
                      onChanged: (newStatus) async {
                        if (newStatus != null) {
                          await context
                            .read<OrdersProvider>().updateOrderStatus(
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
        );
        }
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
