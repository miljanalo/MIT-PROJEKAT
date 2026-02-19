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
      body: StreamBuilder(
        stream: cartProvider.cartStream,
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }

          if(!snapshot.hasData || snapshot.data!.isEmpty){
            return const Center(
              child: Text('Korpa je prazna', style: TextStyle(fontSize: 16),)
            );
          }

          final items = snapshot.data!;

          double total = 0;
          for(var item in items){
            total+= item.book.price *item.quantity;
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index){
                    return CartItemCard(
                      item: items[index],
                    );
                  }
                )
              ),
          
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
                      '${total.toStringAsFixed(0)} RSD',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]
                )
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
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
              ),
            ]
          );
        }  
      ),
    ); 
  }
}