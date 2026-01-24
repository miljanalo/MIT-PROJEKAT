import 'package:flutter/material.dart';
import 'package:knjizara/providers/cart_provider.dart';
import 'package:knjizara/providers/orders_provider.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();

  String paymentMethod = 'Pouzećem';

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: true,
      ),
      body: cartProvider.isEmpty
          ? const Center(child: Text('Korpa je prazna'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // 🛒 REZIME
                    const Text(
                      'Rezime porudžbine',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    ...cartProvider.items.map(
                      (item) => ListTile(
                        title: Text(item.book.title),
                        subtitle: Text('x${item.quantity}'),
                        trailing: Text(
                          '${(item.book.price * item.quantity).toStringAsFixed(0)} RSD',
                        ),
                      ),
                    ),

                    const Divider(),

                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Ukupno: ${cartProvider.totalPrice.toStringAsFixed(0)} RSD',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // unos podataka
                    const Text(
                      'Podaci za isporuku',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Ime i prezime'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Obavezno polje' : null,
                    ),

                    const SizedBox(height: 12),

                    TextFormField(
                      controller: addressController,
                      decoration: const InputDecoration(labelText: 'Adresa'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Obavezno polje' : null,
                    ),

                    const SizedBox(height: 12),

                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(labelText: 'Telefon'),
                      validator: (value) =>
                          value == null || value.length < 6 ? 'Nevalidan telefon' : null,
                    ),

                    const SizedBox(height: 24),

                    // placanje
                    const Text(
                      'Način plaćanja',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),

                    RadioListTile(
                      title: const Text('Pouzećem'),
                      value: 'Pouzećem',
                      groupValue: paymentMethod,
                      onChanged: (value) {
                        setState(() {
                          paymentMethod = value!;
                        });
                      },
                    ),

                    RadioListTile(
                      title: const Text('Kartica'),
                      value: 'Kartica',
                      groupValue: paymentMethod,
                      onChanged: (value) {
                        setState(() {
                          paymentMethod = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 24),

                    // potvrda porudzbine
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final ordersProvider =
                              Provider.of<OrdersProvider>(context, listen: false);

                              // cuvanje porudzbine
                              ordersProvider.addOrder(
                                items: cartProvider.items,
                                totalPrice: cartProvider.totalPrice,
                              );

                              // brisanje korpe
                              cartProvider.clearCart();

                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Uspešno'),
                                content: const Text(
                                  'Uspešno ste izvršili porudžbinu! 🎉',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('OK'),
                                  )
                                ],
                              ),
                            );
                          }
                        },
                        child: const Text('Potvrdi porudžbinu'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
