import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:knjizara/models/book_model.dart';
import 'package:knjizara/providers/books_provider.dart';

class BookFormScreen extends StatefulWidget {
  final BookModel? book;
  const BookFormScreen({super.key, this.book});

  @override
  State<BookFormScreen> createState() => _BookFormScreenState();
}

class _BookFormScreenState extends State<BookFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController authorController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  late TextEditingController imageController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.book?.title ?? '');
    authorController = TextEditingController(text: widget.book?.author ?? '');
    descriptionController = TextEditingController(text: widget.book?.description ?? '');
    priceController =
        TextEditingController(text: widget.book?.price.toString() ?? '');
    imageController =
        TextEditingController(text: widget.book?.imagePath ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final booksProvider = Provider.of<BooksProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book == null ? 'Add Book' : 'Edit Book'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: authorController,
                decoration: const InputDecoration(labelText: 'Author'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Opis knjige'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: imageController,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newBook = BookModel(
                      id: widget.book?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                      title: titleController.text,
                      author: authorController.text,
                      description: descriptionController.text,
                      price: double.tryParse(priceController.text) ?? 0,
                      imagePath: imageController.text,
                    );

                    if (widget.book == null) {
                      booksProvider.addBook(newBook);
                    } else {
                      booksProvider.updateBook(widget.book!.id, newBook);
                    }

                    Navigator.pop(context);
                  }
                },
                child: Text(widget.book == null ? 'Add Book' : 'Save Changes'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
