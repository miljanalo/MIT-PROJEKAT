import 'package:flutter/material.dart';
import 'package:knjizara/data/books_data.dart';
import 'package:knjizara/models/book_model.dart';
import 'package:knjizara/widgets/book_card_list.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();

}  
class _SearchScreenState extends State<SearchScreen>{
  final TextEditingController _searchController = TextEditingController();
  List<BookModel> _filteredBooks =[];
  bool _hasSearched = false;

  void _searchBook(String query){
    final results = booksList.where((book){
      final titleLower = book.title.toLowerCase();
      final authorLower = book.author.toLowerCase();
      final searchLower = query.toLowerCase();

      return titleLower.contains(searchLower) || authorLower.contains(searchLower);
    }).toList();

    setState(() {
      _filteredBooks = results;
      _hasSearched = true;
    });
  }


  @override
  Widget build(BuildContext context) {
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
              onChanged: _searchBook,
              decoration: InputDecoration(
                hintText: 'Ptretražite po naslovu ili autoru',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)),
              ),
            )
          ),

          Expanded(
            child: !_hasSearched ? const Center(
              child: Text('Pretraga',
              style: TextStyle(fontSize: 16),
              ),
            )
            : _filteredBooks.isEmpty ? const Center(
              child: Text('Nema rezultata',
              style: TextStyle(fontSize: 16),),
            )
            : ListView.builder(
              itemCount: _filteredBooks.length,
              itemBuilder: (context, index){
                return BookListCard(
                  book: _filteredBooks[index],
                );
              },
            ),
          ),



        ],
      ),
        );
  }

}
  


