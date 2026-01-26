import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:knjizara/models/book_model.dart';
import 'package:knjizara/providers/auth_provider.dart';
import 'package:knjizara/providers/cart_provider.dart';
import 'package:knjizara/screens/book_details_screen.dart';
import 'package:provider/provider.dart';

class BookCard extends StatelessWidget {
  final BookModel book;

  const BookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context,MaterialPageRoute(builder: (_) => BookDetailsScreen(book: book),),);
      },
    
    child: Card(
      elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Slika knjige
            //Expanded(
              //flex: 7,
              //child: ClipRRect(
                //borderRadius: const BorderRadius.vertical(
                 // top: Radius.circular(16),
                //),
                //child: 
                Image.asset(
                  book.imagePath,
                  //ubaceno
                  height: 180, // fiksirana visina slike
                  width: double.infinity,
                  //
                  fit: BoxFit.cover,
                ) ,
              //),
            //),

            // Tekst pored
            Flexible(
              flex: 4,
              child: Padding(padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      book.author,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${book.price.toStringAsFixed(0)} RSD',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.redAccent,
                          ),
                        ),
                        // Dugme za dodavanje u korpu 
                        IconButton(
                          icon: const Icon(Icons.shopping_cart_outlined),
                            onPressed: () {
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
                              //poruka
                              Flushbar(
                                message: 'Proizvod je dodat u korpu',
                                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                                duration: const Duration(seconds: 2),
                              ).show(context);
                            }
                        ),
                      ],
                    ) 
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}