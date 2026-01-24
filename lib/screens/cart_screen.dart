import 'package:flutter/material.dart';
import 'package:knjizara/providers/cart_provider.dart';
import 'package:knjizara/screens/checkout/checkout_screen.dart';
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

          // 🧾 UKUPNA CENA
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ukupno:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${cartProvider.totalPrice.toStringAsFixed(0)} RSD',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // ✅ CHECKOUT DUGME
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: cartProvider.isEmpty
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const CheckoutScreen(),
                                ),
                              );
                            },
                      child: const Text('Checkout'),
                    ),
                  ),
                )
          
        ],),
        
    );
    
  }
}