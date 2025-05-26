import 'package:byte_digital_test_case/utils/node.dart';

// Product model
class Product {
  final String id;
  final String title;
  final String description;
  final List<String> imageUrls;
  final String price;
  final String currencyCode;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrls,
    required this.price,
    required this.currencyCode,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? "N/A",
      title: json['title'] ?? "N/A",
      description: json['description'] ?? "N/A",
      imageUrls: json['images']?['edges'] != null ? List.of(json['images']['edges']).map((e) => Node<String>.fromJson(e, (node) => node['originalSrc']).value).toList() : [],
      price: json['priceRange']?['minVariantPrice']?['amount'] ?? '0.00',
      currencyCode: json['priceRange']?['minVariantPrice']?['currencyCode'] ?? 'TRY',
    );
  }
}
