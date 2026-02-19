import 'package:flutter/material.dart';
import 'package:knjizara/models/book_model.dart';
import 'package:knjizara/providers/books_provider.dart';
import 'package:knjizara/widgets/book_card_list.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>{
  final TextEditingController _searchController = TextEditingController();

  String _query = '';

  @override
  Widget build(BuildContext context) {

    final booksProvider = Provider.of<BooksProvider>(context, listen: false);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pretraga'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: (value){
                setState(() {
                  _query = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Ptretražite po naslovu ili autoru',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)),
              ),
            )
          ),

          Expanded(
            child: StreamBuilder<List<BookModel>>(
              stream: booksProvider.booksStream,
              builder: (context, snapshot){

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child:
                      CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child:
                      Text('Nema dostupnih knjiga'),
                  );
                }

                final allBooks = snapshot.data!;

                final filteredBooks = allBooks.where((book) {
                  final title = book.title.toLowerCase();
                  final author = book.author.toLowerCase();
                  return title.contains(_query) ||
                      author.contains(_query);
                }
                ).toList();
            
                if (_query.isEmpty){
                  return const Center(
                    child: Text('Pretraga',
                      style: TextStyle(fontSize: 16),
                    )
                  );
                }
              
                if(filteredBooks.isEmpty){
                  return const Center(
                    child: Text('Nema rezultata',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }
            
                return ListView.builder(
                  itemCount: filteredBooks.length,
                  itemBuilder: (context, index) {
                    return BookListCard(
                      book: filteredBooks[index],
                    );
                  },
                );
              }
            ),
          )
        ],
      ),
    );
  }
}
  


