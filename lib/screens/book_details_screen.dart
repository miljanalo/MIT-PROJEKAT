import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:knjizara/models/book_model.dart';
import 'package:knjizara/providers/auth_provider.dart';
import 'package:knjizara/providers/cart_provider.dart';
import 'package:knjizara/providers/wishlist_provider.dart';
import 'package:provider/provider.dart';

class BookDetailsScreen extends StatelessWidget{
  final BookModel book;

  const BookDetailsScreen({super.key, required this.book});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalji knjige'),
        centerTitle: true,
        actions: [
          Consumer<WishlistProvider>(
            builder: (context, wishlistProvider, child) {
              final isInWishlist = wishlistProvider.isInWishlist(book);

              return IconButton(
                icon: Icon(
                  isInWishlist ? Icons.favorite : Icons.favorite_border,
                  color: isInWishlist ? Colors.red : null,
                ),
                onPressed: () {
                  final authProvider = Provider.of<AuthProvider>(context, listen: false);

                  // ako je gost
                  if (!authProvider.isAuthenticated || authProvider.isGuest) {
                    Flushbar(
                      message: 'Morate biti ulogovani da biste koristili wishlist',
                      icon: const Icon(Icons.lock, color: Colors.white),
                      duration: const Duration(seconds: 2),
                    ).show(context);
                    return;
                  }

                  final wasInWishlist = wishlistProvider.isInWishlist(book);

                  wishlistProvider.toggleWishlist(book);

                  Flushbar(
                    message: wasInWishlist
                    ? 'Proizvod je uklonjen iz wishlist-a' 
                    : 'Proizvod je dodat u wishlist',
                    icon: Icon(
                      wasInWishlist 
                      ? Icons.favorite_border 
                      : Icons.favorite, color: Colors.white,
                    ),
                    duration: const Duration(seconds: 2),
                  ).show(context);
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(book.imagePath, height: 220,fit: BoxFit.cover,),
            ),
            const SizedBox(height: 20),

            Text(
              book.title, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold,),
            ),
            const SizedBox(height: 8,),

            Text(
              'Autor: ${book.author}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8,),

            Text(
              'Cena: ${book.price} RSD',
              style: const TextStyle(fontSize: 18,),
            ),
            const SizedBox(height: 8,),

            const Text(
              'Opis:',
              style: TextStyle(fontSize: 18,),

            ),
            const SizedBox(height: 4),

            Text(
              book.description,
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 30,),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: (){
                final authProvider = Provider.of<AuthProvider>(context, listen: false);

                // ako je gost
                if (!authProvider.isAuthenticated || authProvider.isGuest) {
                  Flushbar(
                    message: 'Morate biti ulogovani da biste dodali u korpu',
                    icon: const Icon(Icons.lock, color: Colors.white),
                    duration: const Duration(seconds: 2),
                  ).show(context);
                  return;
                }

                Provider.of<CartProvider>(context, listen: false).addToCart(book);
                // porukica
                Flushbar(
                  message: 'Proizvod je dodat u korpu',
                  icon: const Icon(Icons.shopping_cart, color: Colors.white),
                  duration: const Duration(seconds: 2),
                ).show(context);
              }, child: const Text('Dodaj u korpu')),
            )
          ],
        ),
      ),
    );
  }
}