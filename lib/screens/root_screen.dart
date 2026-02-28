import 'package:flutter/material.dart';
import 'package:knjizara/providers/cart_provider.dart';
import 'package:knjizara/screens/cart_screen.dart';
import 'package:knjizara/screens/home_screen.dart';
import 'package:knjizara/screens/profile_screen.dart';
import 'package:knjizara/screens/search_screen.dart';
import 'package:provider/provider.dart';



class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  late List<Widget> screens;
  int currentScreen = 0;
  late PageController controller;

  @override
  void initState() {
    super.initState();

    screens = [
      HomeScreen(),
      SearchScreen(),
      CartScreen(),
      ProfileScreen(),
    ];
    controller = PageController(initialPage: currentScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        height: kBottomNavigationBarHeight,
        selectedIndex: currentScreen,
        onDestinationSelected: (index) {
          setState(() {
            currentScreen = index;
          });
          controller.jumpToPage(currentScreen);
        },
        destinations: [
          const NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: "Početna",
          ),
          const NavigationDestination(
            selectedIcon: Icon(Icons.search),
            icon: Icon(Icons.search_outlined),
            label: "Pretraga",
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.shopping_basket),
            icon: StreamBuilder(
              stream: context.read<CartProvider>().cartStream,
              builder: (context, snapshot){

                if(!snapshot.hasData){
                  return const Icon(Icons.shopping_basket_outlined);
                }

                final items = snapshot.data!;
                int totalItems = 0;

                for(var item in items) {
                  totalItems += item.quantity;
                }

                return Badge(
                  isLabelVisible: totalItems > 0,
                  label: Text(totalItems.toString()),
                  child: const Icon(Icons.shopping_basket_outlined),
                );
              },
            ),
            label: "Korpa",
          ),
          const NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outline),
            label: "Profil",
          )
        ],
      ),
    );
  }
}