import 'package:flutter/material.dart';
import 'package:knjizara/providers/wishlist_provider.dart';
import 'package:knjizara/widgets/book_card.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        centerTitle: true,
      ),
      body: wishlistProvider.isEmpty
          ? const Center(
              child: Text(
                'Wishlist je prazan',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: wishlistProvider.wishlist.length,
              itemBuilder: (context, index) {
                return BookCard(
                  book: wishlistProvider.wishlist[index],
                );
              },
            ),
    );
  }
}
