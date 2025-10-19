import 'package:flutter/material.dart';
import '../widgets/product_form_widget.dart';
import '../../../../core/domain/entities/product.dart';

class ProductDetailPage extends StatelessWidget {
  final Product? product;

  const ProductDetailPage({super.key, this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product == null ? 'Add Product' : 'Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ProductFormWidget(product: product),
      ),
    );
  }
}
