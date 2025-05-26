import 'package:byte_digital_test_case/data/entities/product.dart';
import 'package:byte_digital_test_case/data/repository/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductListingState {
  final bool isLoading;
  final List<Product> products;
  final String? error;

  ProductListingState({
    this.isLoading = false,
    this.products = const [],
    this.error,
  });

  ProductListingState copyWith({
    bool? isLoading,
    List<Product>? products,
    String? error,
  }) {
    return ProductListingState(
      isLoading: isLoading ?? this.isLoading,
      products: products ?? this.products,
      error: error,
    );
  }
}

// The view controller using StateNotifier
class ProductViewController extends StateNotifier<ProductListingState> {
  final ProductRepository repository;

  ProductViewController(this.repository) : super(ProductListingState());

  Future<void> fetchProducts() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final products = await repository.fetchProducts();
      state = state.copyWith(isLoading: false, products: products..shuffle(), error: null);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}