import 'dart:convert';

// Product model
class Product {
  final String id;
  final String title;
  final String description;
  final List<String> imageUrl;
  final String price;
  final String compareAtPrice;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.compareAtPrice,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final priceRange = json['priceRange']['minVariantPrice'];
    final compareAtPriceRange = json['compareAtPriceRange']['minVariantPrice'];

    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      imageUrl: json['images']?['edges'] != null ? List.of(json['images']['edges']).map((e) => (e as Map)['node']['url'] as String).toList() : [],
      price: '${priceRange['currencyCode']} ${priceRange['amount']}',
      compareAtPrice: compareAtPriceRange != null
          ? '${compareAtPriceRange['currencyCode']} ${compareAtPriceRange['amount']}'
          : '',
    );
  }
}