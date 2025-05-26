import 'dart:convert';

import 'package:http/http.dart' as http;
import '../entities/product.dart';

class ShopifyService {
  static const String _storeName = 'mahmourad';
  static const String _storefrontAccessToken = 'YOUR_STOREFRONT_ACCESS_TOKEN';
  static const String _apiVersion = '2023-10';

  static String get _baseUrl => 'https://$_storeName.myshopify.com/api/$_apiVersion/graphql.json';

  static const String _productsQuery = '''
    query getProducts(\$first: Int!) {
      products(first: \$first) {
        edges {
          node {
            id
            title
            description
            images(first: 1) {
              edges {
                node {
                  originalSrc
                  altText
                }
              }
            }
            priceRange {
              minVariantPrice {
                amount
                currencyCode
              }
            }
            compareAtPriceRange {
              minVariantPrice {
                amount
                currencyCode
              }
            }
          }
        }
      }
    }
  ''';

  static Future<List<Product>> fetchProducts({int count = 10}) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'X-Shopify-Storefront-Access-Token': _storefrontAccessToken,
      },
      body: json.encode({
        'query': _productsQuery,
        'variables': {
          'first': count
        },
      }),
    );

    if (response.statusCode == 200) {
      final data = Map.of(json.decode(response.body)).cast<String, dynamic>();
      final products = List.of(data['data']['products']['edges']).cast<Map<String, dynamic>>();
      return products.map((edge) => Product.fromJson(edge['node'])).toList();
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }
}