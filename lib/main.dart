import 'package:flutter/material.dart';
import 'package:knjizara/consts/theme_data.dart';
import 'package:knjizara/providers/cart_provider.dart';
import 'package:knjizara/providers/theme_provider.dart';
import 'package:knjizara/providers/wishlist_provider.dart';
import 'package:knjizara/screens/root_screen.dart';
import 'package:provider/provider.dart';

void main() {
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
      ],
      child: Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'BookStore',
          theme: Styles.themeData(
              isDarkTheme: themeProvider.getIsDarkTheme, context: context),
          home: const RootScreen(),
        );
      }),
    );
  }
}