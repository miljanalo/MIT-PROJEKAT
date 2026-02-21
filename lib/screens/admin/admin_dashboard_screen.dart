import 'package:flutter/material.dart';
import 'package:knjizara/screens/admin/admin_banners_screen.dart';
import 'package:knjizara/screens/admin/admin_books_screen.dart';
import 'package:knjizara/screens/admin/admin_orders_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // BOOKS
            Card(
              child: ListTile(
                leading: const Icon(Icons.menu_book),
                title: const Text('Manage Books'),
                subtitle: const Text('Add, edit or delete books'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AdminBooksScreen(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // ORDERS
            Card(
              child: ListTile(
                leading: const Icon(Icons.receipt_long),
                title: const Text('Manage Orders'),
                subtitle: const Text('View and approve orders'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AdminOrdersScreen(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // BANNERS
            Card(
              child: ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Manage Banners'),
                subtitle: const Text('Add, edit or delete banners'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AdminBannersScreen(),
                    ),
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}
