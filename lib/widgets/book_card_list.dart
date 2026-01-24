import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:knjizara/models/book_model.dart';
import 'package:knjizara/providers/cart_provider.dart';
import 'package:knjizara/screens/book_details_screen.dart';
import 'package:provider/provider.dart';

class BookListCard extends StatelessWidget {
  final BookModel book;

  const BookListCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context,MaterialPageRoute(builder: (_) => BookDetailsScreen(book: book),),);
      },

    child: Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Slika knjige
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                book.imagePath,
                width: 80,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),

            // Tekst pored
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book.author,
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${book.price.toStringAsFixed(0)} RSD',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Dugme (za kasnije)
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () {
                Provider.of<CartProvider>(context, listen: false).addToCart(book);
                Flushbar(
                                message: 'Proizvod je dodat u korpu',
                                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                                duration: const Duration(seconds: 2),
                              ).show(context);
              },
            ),
          ],
        ),
      ),
    ),
    );
  }
}