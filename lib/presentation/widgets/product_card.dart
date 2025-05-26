import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String title, description, price, currencyCode;
  final List<String> imageUrls;

  const ProductCard({super.key, required this.title, required this.description, required this.price, required this.currencyCode, this.imageUrls = const []});

  @override Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            imageUrls.isNotEmpty ? Image.network(
              imageUrls.first,
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ) : Placeholder(
              fallbackHeight: 80,
              fallbackWidth: 80,
            ), // Placeholder for product image
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$price $currencyCode',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.shopping_cart, color: Colors.blue),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}