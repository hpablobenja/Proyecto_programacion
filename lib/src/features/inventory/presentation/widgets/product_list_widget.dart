import 'package:flutter/material.dart';
import '../../../../core/domain/entities/product.dart';

class ProductListWidget extends StatelessWidget {
  final List<Product> products;

  const ProductListWidget({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ListTile(
          title: Text(product.name),
          subtitle: Text('Stock: ${product.stock} ${product.variant ?? ''}'),
          onTap: () => Navigator.pushNamed(
            context,
            '/product_detail',
            arguments: product,
          ),
        );
      },
    );
  }
}
