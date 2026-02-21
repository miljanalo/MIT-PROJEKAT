import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:knjizara/consts/theme_data.dart';
import 'package:knjizara/providers/auth_provider.dart';
import 'package:knjizara/providers/banner_provider.dart';
import 'package:knjizara/providers/books_provider.dart';
import 'package:knjizara/providers/cart_provider.dart';
import 'package:knjizara/providers/orders_provider.dart';
import 'package:knjizara/providers/theme_provider.dart';
import 'package:knjizara/providers/wishlist_provider.dart';
import 'package:knjizara/screens/auth/login_screen.dart';
import 'package:knjizara/screens/root_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          return ThemeProvider();
        }),
        ChangeNotifierProvider(create: (_) {
          return CartProvider();
        }),
        ChangeNotifierProvider(
          create: (_) => WishlistProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrdersProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => BooksProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider()..initAuth(),
        ),
        ChangeNotifierProvider(
          create: (_) => BannerProvider(),
        ),
      ],
      child: Consumer2<ThemeProvider, AuthProvider>(
        builder: (context, themeProvider, authProvider, child) {
        return MaterialApp(
          key: ValueKey(authProvider.isAuthenticated),
          title: 'BookStore',
          theme: Styles.themeData(
              isDarkTheme: themeProvider.getIsDarkTheme,
              context: context
          ),
          home: authProvider.isAuthenticated ? RootScreen() : LoginScreen(),
        );
      }),
    );
  }
}