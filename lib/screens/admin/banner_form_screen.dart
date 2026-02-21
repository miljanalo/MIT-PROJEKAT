import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:knjizara/models/banner_model.dart';
import 'package:knjizara/providers/banner_provider.dart';
import 'package:provider/provider.dart';
import 'package:knjizara/models/book_model.dart';
import 'package:knjizara/providers/books_provider.dart';
import 'package:knjizara/services/cloudinary_service.dart';

class BannerFormScreen extends StatefulWidget {
  final BannerItem? banner;
  const BannerFormScreen({super.key, this.banner});

  @override
  State<BannerFormScreen> createState() => _BannerFormScreenState();
}

class _BannerFormScreenState extends State<BannerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController subtitleController;
  late TextEditingController orderController;

  BannerType? selectedType;
  String? selectedBookId;
  File? _pickedImage;
  bool _isActive = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.banner?.title ?? '');
    subtitleController = TextEditingController(text: widget.banner?.subtitle ?? '');
    orderController = TextEditingController(
      text: widget.banner?.order.toString() ?? '0',
    );
    selectedType = widget.banner?.type ?? BannerType.promo;
    selectedBookId = widget.banner?.bookId;
    _isActive = widget.banner?.isActive ?? true;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _pickedImage = File(picked.path));
  }

  @override
  Widget build(BuildContext context) {
    final bannersProvider = Provider.of<BannerProvider>(context, listen: false);
    final booksProvider = Provider.of<BooksProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.banner == null ? 'Add Banner' : 'Edit Banner'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Naslov'),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: subtitleController,
                decoration: const InputDecoration(labelText: 'Podnaslov'),
              ),

              const SizedBox(height: 12),

              DropdownButtonFormField<BannerType>(
                value: selectedType,
                items: BannerType.values
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type.toString().split('.').last),
                        ))
                    .toList(),
                onChanged: (val) => setState(() => selectedType = val),
                decoration: const InputDecoration(labelText: 'Tip banera'),
              ),

              const SizedBox(height: 12),

              if (selectedType == BannerType.book)
                StreamBuilder<List<BookModel>>(
                  stream: booksProvider.booksStream,
                  builder: (context, snapshot) {
                    final books = snapshot.data ?? [];
                    return DropdownButtonFormField<String>(
                      value: selectedBookId,
                      items: books
                          .map((b) => DropdownMenuItem(
                                value: b.id,
                                child: Text(b.title),
                              ))
                          .toList(),
                      onChanged: (val) => setState(() => selectedBookId = val),
                      decoration: const InputDecoration(labelText: 'Odabir knjige'),
                      validator: (v) {
                        if (selectedType == BannerType.book && (v == null || v.isEmpty)) {
                          return 'Required';
                        }
                        return null;
                      },
                    );
                  },
                ),
              

              const SizedBox(height: 12),

              TextFormField(
                controller: orderController,
                decoration: const InputDecoration(labelText: 'Redosled'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Obavezno polje';
                  if (int.tryParse(v) == null) return 'Unos mora biti broj';
                  return null;
                },
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Aktivan'),
                  Switch(
                    value: _isActive,
                    onChanged: (val) => setState(() => _isActive = val),
                  ),
                ],
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
                          child: Image.file(_pickedImage!, fit: BoxFit.cover),
                        )
                      : widget.banner != null && widget.banner!.imagePath.isNotEmpty
                        ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                widget.banner!.imagePath,
                                fit: BoxFit.cover
                              ),
                        )
                        : const Center(child: Text('Tap to select image')),
                ),
              ),

              const SizedBox(height: 20),

              if (_isLoading) const Center(child: CircularProgressIndicator()),
              
              const SizedBox(height: 12),
              
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  if (_pickedImage == null && widget.banner == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Izaberi sliku')
                      ),
                    );
                    return;
                  }

                  try {
                    setState(() => _isLoading = true);

                    String imageUrl = widget.banner?.imagePath ?? '';

                    if (_pickedImage != null) {
                      imageUrl = await CloudinaryService.uploadImage(_pickedImage!);
                    }

                    final newBanner = BannerItem(
                      id: widget.banner?.id ?? '', 
                      title: titleController.text,
                      subtitle: subtitleController.text,
                      type: selectedType!,
                      imagePath: imageUrl,
                      bookId: selectedBookId,
                      isActive: _isActive,
                      order: int.tryParse(orderController.text) ?? 0,
                    );

                    if (widget.banner == null) {
                      await bannersProvider.addBanner(newBanner);
                    } else {
                      await bannersProvider.updateBanner(newBanner);
                    }

                    if (!mounted) return;
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  } finally {
                    setState(() => _isLoading = false);
                  }
                },
                child: Text(widget.banner == null ? 'Add Banner' : 'Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}