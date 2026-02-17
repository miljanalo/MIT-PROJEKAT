import 'package:flutter/material.dart';
import 'package:knjizara/models/book_model.dart';
import 'package:knjizara/providers/books_provider.dart';
import 'package:knjizara/widgets/book_card_grid.dart';
import 'package:knjizara/widgets/home_banner.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final booksProvider = Provider.of<BooksProvider>(context, listen: false);
    
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

            StreamBuilder<List<BookModel>>(
              stream: booksProvider.booksStream,
              builder: (context, snapshot) {

                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if(!snapshot.hasData || snapshot.data!.isEmpty){
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                      child: Text('Nema dostupnih knjiga'),
                    ),
                  );
                }

                final books = snapshot.data!;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.60,
                  ),
                  itemCount: books.length,
                  itemBuilder: (context, index) => 
                  SizedBox(
                    height: 300,  // 
                    child: BookCard(
                      book: books[index]
                    ),
                  )
                );
              }
            ),
          ]
        ),
      )
    );
  }
}