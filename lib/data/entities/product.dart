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

class Node<T> {
  T value;
  Node(this.value);

  factory Node.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) converter,) {
    return Node<T>(converter(Map.of(json['node']).cast<String, dynamic>()));
  }
}