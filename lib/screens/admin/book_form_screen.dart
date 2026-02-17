import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:knjizara/services/cloudinary_service.dart';
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
  
  File? _pickedImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.book?.title ?? '');
    authorController = TextEditingController(text: widget.book?.author ?? '');
    descriptionController = TextEditingController(text: widget.book?.description ?? '');
    priceController =
        TextEditingController(text: widget.book?.price.toString() ?? '');
  }

  Future<void> _pickImage() async{
    final picker = ImagePicker();

    final picked = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if(picked != null){
      setState(() {
        _pickedImage = File(picked.path);
      });
    }
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

              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _pickedImage != null
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _pickedImage!,
                        fit: BoxFit.cover,
                      ),
                    )
                      : widget.book != null && widget.book!.imagePath.isNotEmpty
                      ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          widget.book!.imagePath,
                          fit: BoxFit.cover,
                        ),
                      )
                      : const Center(child: Text("Tap to select image"),
                    ),
                ),
              ),

              const SizedBox(height:20),

              if (_isLoading)
                const Center(child: CircularProgressIndicator()),
              
              const SizedBox(height: 12),

              ElevatedButton(
                onPressed: () async {
                  if(!_formKey.currentState!.validate()) return;

                  if (_pickedImage == null && widget.book == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Izaberi sliku"),
                      ),
                    );
                    return;
                  }

                  try {
                    setState(() => _isLoading = true); 
                      
                    String imageUrl = widget.book?.imagePath ?? '';

                    if(_pickedImage!=null){
                      imageUrl = await CloudinaryService.uploadImage(_pickedImage!);
                    }

                    final newBook = BookModel(
                      id: widget.book?.id ?? '',
                      title: titleController.text,
                      author: authorController.text,
                      description: descriptionController.text,
                      price: double.tryParse(priceController.text) ?? 0,
                      imagePath: imageUrl,
                    );

                    if (widget.book == null) {
                      booksProvider.addBook(newBook);
                    } else {
                      booksProvider.updateBook(widget.book!.id, newBook);
                    }

                    if (!mounted) return;
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  } finally{
                    setState(() => _isLoading = false);
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
