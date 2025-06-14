// ignore_for_file: constant_identifier_names
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:byte_digital_test_case/utils/data/repository_helper.dart';
import 'package:http/http.dart' as http;

import '../entities/product.dart';

class ProductRepository with RepositoryHelper {
  static const String FETCH_PRODUCT_MUTATION = '''
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

  Future<List<Product>> fetchProducts({int count = 10}) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'X-Shopify-Storefront-Access-Token': storefrontAccessToken,
      },
      body: json.encode({
        'query': FETCH_PRODUCT_MUTATION,
        'variables': {
          'first': count
        },
      }),
    );

    if (response.statusCode == HttpStatus.ok && response.body.isNotEmpty) {
      final data = Map.of(json.decode(response.body)).cast<String, dynamic>();

      if (data['errors'] != null) {
        throw Exception('GraphQL Error: ${data['errors']}');
      }

      dev.log('product fetching success.', name: "Product Repo - fetchProducts()",);
      final nodes = List.of(data['data']['products']['edges']);
      final products = nodes.map((e) => Node<Product>.fromJson(e, (node) => Product.fromJson(node)).value).toList();
      return products;
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }
}