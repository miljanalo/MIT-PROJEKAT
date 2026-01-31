import 'package:flutter/material.dart';
import 'package:knjizara/providers/auth_provider.dart';
import 'package:knjizara/screens/admin/admin_dashboard_screen.dart';
import 'package:knjizara/screens/checkout/all_orders_screen.dart';
import 'package:knjizara/screens/wishlist_screen.dart';
import 'package:provider/provider.dart';
import 'package:knjizara/providers/theme_provider.dart';
import 'package:knjizara/consts/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final isGuest = authProvider.isGuest;
    final user = authProvider.user;
    
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

            Text(
              isGuest ? "Gost" : user?.name ?? "",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),),
            const SizedBox(height: 4),
            Text(
              isGuest ? "Niste prijavljeni" : (user?.email ?? ""),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),),
            const SizedBox(height: 32),

            // poruka za gosta
            
            if(isGuest)
            Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12)
              ),
              child: Row(
                  children: const [
                    Icon(Icons.info_outline, color: Colors.orange),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Ulogujte se ili registrujte da bi koristili wishlist, korpu i porudžbine.",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
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

            // Wishlist (ako nije gost)

            if(!authProvider.isGuest && !authProvider.isAdmin)
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

            // All Orders (ako nije gost)
            if(!authProvider.isGuest && !authProvider.isAdmin)
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.receipt_long_outlined),
                title: const Text("All Orders"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const OrdersScreen(),
                    ),
                  );
                },
              ),
            ),

            //panel za admina

            if (authProvider.isAdmin)
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.admin_panel_settings),
                title: const Text("Admin panel"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AdminDashboardScreen(),
                    ),
                  );
                },
              ),
            ),

            // Logout dugme

            if(!isGuest)
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

            //dugme koje vodi na login screen

            if (isGuest)
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.login),
                title: const Text("Prijavite se"),
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
