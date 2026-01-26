import 'package:flutter/material.dart';
import 'package:knjizara/providers/auth_provider.dart';
import 'package:knjizara/screens/auth/register_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prijava'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 40),

              // Email
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email je obavezan';
                  }
                  if (!_isValidEmail(value)) {
                    return 'Unesite validan email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Lozinka
              TextFormField(
                controller: passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Lozinka',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lozinka je obavezna';
                  }
                  if (value.length < 6) {
                    return 'Lozinka mora imati najmanje 6 karaktera';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Provider.of<AuthProvider>(context, listen: false).login(
                        email: emailController.text,
                        password: passwordController.text,
                        );
                    }
                  },
                  child: const Text('Prijavi se'),
                ),
              ),

              const SizedBox(height: 16),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RegisterScreen(),
                    ),
                  );
                },
                child: const Text('Nemaš nalog? Registruj se'),
              ),

              TextButton(
                onPressed: (){
                  Provider.of<AuthProvider>(context, listen: false).loginAsGuest();
                },
                child: const Text('Nastavi kao gost'),
              ),



            ],
          ),
        ),
      ),
    );
  }
}
