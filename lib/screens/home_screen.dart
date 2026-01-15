import 'package:flutter/material.dart';
import 'package:knjizara/data/books_data.dart';
import 'package:knjizara/widgets/book_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Store'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: booksList.length,
        itemBuilder: (context, index){
          return BookCard(
            book: booksList[index],
          );
        }
      )
        );
  }
}