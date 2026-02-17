import 'package:flutter/material.dart';
import 'package:knjizara/models/book_model.dart';
import 'package:knjizara/screens/admin/book_form_screen.dart';
import 'package:provider/provider.dart';
import 'package:knjizara/providers/books_provider.dart';

class AdminBooksScreen extends StatelessWidget {
  const AdminBooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final booksProvider = Provider.of<BooksProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Books'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BookFormScreen(),
                ),
              );
            },
          )
        ],
      ),
      body: StreamBuilder<List<BookModel>>(
        stream: booksProvider.booksStream,
        builder: (context, snapshot) {
          
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if(!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Nema knjiga'),
            );
          }

          final books = snapshot.data!;
          
          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index){
              final book = books[index];
          
             return Card(
               margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
               child: ListTile(
                 title: Text(book.title),
                 subtitle: Text('${book.author} • ${book.price} RSD'),
                 trailing: Row(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     IconButton(
                       icon: const Icon(Icons.edit, color: Colors.blue),
                       onPressed: () {
                         Navigator.push(
                           context,
                           MaterialPageRoute(
                             builder: (_) => BookFormScreen(book: book),
                           ),
                          );
                        },
                      ),
                     IconButton(
                       icon: const Icon(Icons.delete, color: Colors.red),
                       onPressed: () {
                         booksProvider.removeBook(book.id);
                       },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      )
    );
  }
}
