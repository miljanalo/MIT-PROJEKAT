import 'package:flutter/material.dart';
import 'package:knjizara/data/books_data.dart';
import 'package:knjizara/widgets/book_card.dart';
import 'package:knjizara/widgets/home_banner.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Store'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
            // baner

            const SizedBox(height: 12),
            const HomeBanner(),

            const Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: Text(
                'Top Picks',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),


            //grid prvi pokusaj

            GridView.builder(
              //padding: const EdgeInsets.all(12),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.60,
              ),
              itemCount: booksList.length,
              itemBuilder: (context, index) => SizedBox(
                height: 300,  // 
                child: BookCard(book: booksList[index]),
              )
              /*itemBuilder: (contex, index){
                return BookCard(book: booksList[index]);
              },*/
            ),
          ]
        ),
      )
    );
  }
}