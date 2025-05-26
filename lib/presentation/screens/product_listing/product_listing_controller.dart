import 'package:byte_digital_test_case/data/entities/product.dart';
import 'package:byte_digital_test_case/data/repository/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// State class to represent loading, data, and error states
class ProductState {
  final bool isLoading;
  final List<Product> products;
  final String? error;

  ProductState({
    this.isLoading = false,
    this.products = const [],
    this.error,
  });

  ProductState copyWith({
    bool? isLoading,
    List<Product>? products,
    String? error,
  }) {
    return ProductState(
      isLoading: isLoading ?? this.isLoading,
      products: products ?? this.products,
      error: error,
    );
  }
}

// The view controller using StateNotifier
class ProductViewController extends StateNotifier<ProductState> {
  final ProductRepository repository;

  ProductViewController(this.repository) : super(ProductState());

  Future<void> fetchProducts() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final products = await repository.fetchProducts();
      state = state.copyWith(isLoading: false, products: products, error: null);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}