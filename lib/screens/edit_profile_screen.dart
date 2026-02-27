import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:knjizara/services/cloudinary_service.dart';
import 'package:provider/provider.dart';
import 'package:knjizara/providers/auth_provider.dart' as app_auth;

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  bool _isLoading = false;
  String? _imageUrl;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    final user =
        Provider.of<app_auth.AuthProvider>(context, listen: false).user;

    nameController.text = user!.name;
    _imageUrl = user.profileImage;
  }

  Future<void> _pickImage() async {
    final picked =
        await _picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() => _isLoading = true);

      try {
        final imageUrl = await CloudinaryService.uploadImage(File(picked.path));
        final String uid = FirebaseAuth.instance.currentUser!.uid;
        await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({
            'profileImage': imageUrl
          });

        setState(() {
          _imageUrl = imageUrl;
        });

        await context.read<app_auth.AuthProvider>().initAuth();

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Greška pri uploadu")),
        );
      }

      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Izmena profila'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 70,
                backgroundImage: _imageUrl != null
                    ? NetworkImage(_imageUrl!)
                    : null,
                child: _imageUrl == null
                    ? const Icon(Icons.person, size: 70)
                    : null,
              ),
            ),

            const SizedBox(height: 12,),
            const Text("Tap to select image"),

            const SizedBox(height: 30),

            Form(
              key: _formKey,
              child: Column(
                children: [

                  const SizedBox(height: 24),

                  // ime
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Ime i prezime',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ime i prezime su obavezni';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ElevatedButton(
                        onPressed: () async {

                          if (!_formKey.currentState!.validate()) return;

                          setState(() {
                            _isLoading = true;
                          });

                          try {

                            await Provider.of<app_auth.AuthProvider>(
                              context,
                              listen: false,
                            ).updateUser(
                                name: nameController.text.trim(),
                                email: context
                                  .read<app_auth.AuthProvider>()
                                  .user!
                                  .email,                              
                                profileImage: _imageUrl,
                            );

                            if(!mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Podaci uspešno ažurirani'),
                              ),
                            );

                            Navigator.pop(context);

                          } catch (e) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              SnackBar(
                                content: Text(e.toString()),
                              ),
                            );

                          } finally {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        },
                        child: const Text('Sačuvaj izmene'),
                      ),
                  ),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}