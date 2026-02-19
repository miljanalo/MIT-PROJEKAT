import 'package:flutter/material.dart';
import 'package:knjizara/models/order_model.dart';
import 'package:knjizara/providers/auth_provider.dart';
import 'package:knjizara/screens/checkout/order_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:knjizara/providers/orders_provider.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    final authProvider = context.watch<AuthProvider>();

    if(authProvider.isGuest || authProvider.user == null){
      return Scaffold(
        appBar: AppBar(
          title: const Text('Sve porudžbine'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('Morate biti prijavljeni da biste videli porudžbine.'),
        )
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sve porudžbine'),
        centerTitle: true,
      ),
      body: StreamBuilder<List<OrderModel>>(
        stream: context
          .read<OrdersProvider>()
          .ordersStream(
            isAdmin: authProvider.isAdmin,
            userId: authProvider.user!.id
          ),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Nema porudžbina',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final orders = snapshot.data!;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {

              final order = orders[index];

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
          );
        }
      )
    );
  }
}

