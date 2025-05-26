import 'package:byte_digital_test_case/data/repository/product_repository.dart';
import 'package:byte_digital_test_case/main_app.dart';

import 'product_listing_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/product_card.dart';
import '../profile/profile_screen.dart';

final productViewControllerProvider = StateNotifierProvider<ProductViewController, ProductListingState>((ref) {
  final repository = ProductRepository();
  return ProductViewController(repository);
});

class ProductListingScreen extends ConsumerStatefulWidget {
  const ProductListingScreen({super.key});

  @override ConsumerState<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends ConsumerState<ProductListingScreen> {

  @override void initState() {
    super.initState();
    // Fetch products when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productViewControllerProvider.notifier).fetchProducts();
    });
  }

  @override Widget build(BuildContext context) {
    final state = ref.watch(productViewControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Products', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, size: 40, color: Colors.grey),
            onPressed: () {
              navigatorKey.currentState!.push(
                MaterialPageRoute(builder: (_) => UserAccountScreen()),
              );
            },
          ),
        ],
      ),
      body: Builder(
        builder: (_) {
          if(state.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if(state.error != null) {
            return Center(
              child: Text(
                'Error: ${state.error}',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else if(state.products.isEmpty) {
            return Center(
              child: Text(
                'No products available!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products.elementAt(index);
                return ProductCard(
                  title: product.title,
                  description: product.description,
                  price: product.price,
                  currencyCode: product.currencyCode,
                  imageUrls: product.imageUrls,
                );
              },
            );
          }
        },
      ),
    );
  }
}