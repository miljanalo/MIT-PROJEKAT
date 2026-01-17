import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:knjizara/models/cart_item_model.dart';
import 'package:knjizara/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class CartItemCard extends StatelessWidget{
  final CartItemModel item;

  const CartItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Slika
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                item.book.imagePath,
                width: 60,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.book.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(item.book.author),
                  const SizedBox(height: 6),
                  Text(
                    '${item.book.price.toStringAsFixed(0)} RSD',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            // Kolicina
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    cartProvider.increaseQuantity(item.book);
                  },
                ),
                Text(item.quantity.toString()),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    cartProvider.decreaseQuantity(item.book);
                  },
                ),
              ],
            ),

            // Brisanje
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                cartProvider.removeFromCart(item.book);
              },
            ),
          ],
        ),
      ),
    );
  }
}