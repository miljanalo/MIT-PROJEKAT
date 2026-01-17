import 'package:flutter/material.dart';
import 'package:knjizara/models/book_model.dart';
import 'package:knjizara/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class BookDetailsScreen extends StatelessWidget{
  final BookModel book;

  const BookDetailsScreen({super.key, required this.book});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalji knjige'),
        centerTitle: true,
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
                Provider.of<CartProvider>(context, listen: false).addToCart(book);
              }, child: const Text('Dodaj u korpu')),
            )


          ],
        ),
      ),
    );
  }



}