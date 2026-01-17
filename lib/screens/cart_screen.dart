import 'package:flutter/material.dart';
import 'package:knjizara/providers/cart_provider.dart';
import 'package:knjizara/widgets/cart_item_card.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Korpa'),
        centerTitle: true,
      ),
      body: cartProvider.isEmpty ? const Center(
        child: Text('Korpa je prazna', style: TextStyle(fontSize: 16),)
      ) :
        Column(children: [
          Expanded(child: ListView.builder(
            itemCount: cartProvider.items.length,
            itemBuilder: (context, index){
              
              return CartItemCard(
                item: cartProvider.items[index],
              );
            },
          ),),
          
        ],),
    );
  }
}