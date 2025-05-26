import 'package:flutter/material.dart';
import '../widgets/product_card.dart';
import 'user_account_screen.dart';

class ProductListingScreen extends StatelessWidget {
  // Sample product data for UI demonstration
  final List<Map<String, String>> products = List.generate(
    20, (index) => {'name': 'Product ${index + 1}', 'price': '\$${(index + 1) * 10}'},
  );

  ProductListingScreen({super.key});

  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserAccountScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ProductCard(
            name: products[index]['name']!,
            price: products[index]['price']!,
          );
        },
      ),
    );
  }
}