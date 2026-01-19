import 'package:flutter/material.dart';
import 'package:knjizara/providers/auth_provider.dart';
import 'package:knjizara/screens/wishlist_screen.dart';
import 'package:provider/provider.dart';
import 'package:knjizara/providers/theme_provider.dart';
import 'package:knjizara/consts/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Korisnički info
            CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.lightPrimary,
              child: const Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Miljana", // placeholder ime
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              "miljana@email.com", // placeholder email
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),

            // Dark mode toggle
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: SwitchListTile(
                title: Text(themeProvider.modeText), // Dinamički tekst
                value: themeProvider.getIsDarkTheme,
                onChanged: (value) => themeProvider.setDarkTheme(themeValue: value),
                secondary: const Icon(Icons.dark_mode),
              ),
            ),

            // Wishlist
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.favorite, color: Colors.red),
                title: const Text("Wishlist"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const WishlistScreen(),
                    ),
                  );
                },
              ),
            ),

            // Logout dugme
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                 Provider.of<AuthProvider>(context, listen: false).logout();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
