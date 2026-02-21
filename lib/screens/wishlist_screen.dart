import 'package:flutter/material.dart';
import 'package:knjizara/models/book_model.dart';
import 'package:knjizara/providers/auth_provider.dart';
import 'package:knjizara/providers/wishlist_provider.dart';
import 'package:knjizara/widgets/book_card_list.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final wishlistProvider = context.read<WishlistProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        centerTitle: true,
      ),
      body:StreamBuilder<List<BookModel>>(
        stream: wishlistProvider.wishlistStream(auth.user!.id),
        builder: (context, snapshot){

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Greška: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Wishlist je prazan',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final wishlist = snapshot.data!;

          return ListView.builder(
            itemCount: wishlist.length,
            itemBuilder: (context, index) {
              return BookListCard(
                book: wishlist[index],
              );
            }
          );
        }
      )
    );
  }
}
