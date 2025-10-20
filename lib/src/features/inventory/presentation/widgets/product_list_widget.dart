import 'package:flutter/material.dart';
import '../../../../core/domain/entities/product.dart';

class ProductListWidget extends StatelessWidget {
  final List<Product> products;

  const ProductListWidget({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No hay productos disponibles',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Agrega tu primer producto',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getStockColor(product.stock),
              child: Text(
                '${product.stock}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (product.variant != null)
                  Text('Variante: ${product.variant}'),
                Text('Stock: ${product.stock} unidades'),
                if (product.storeId != null)
                  Text(
                    'Tienda ID: ${product.storeId}',
                    style: const TextStyle(fontSize: 12, color: Colors.blue),
                  ),
                if (product.warehouseId != null)
                  Text(
                    'Almacén ID: ${product.warehouseId}',
                    style: const TextStyle(fontSize: 12, color: Colors.green),
                  ),
                Text(
                  'Actualizado: ${_formatDate(product.updatedAt)}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Navigator.pushNamed(
              context,
              '/product_detail',
              arguments: product,
            ),
          ),
        );
      },
    );
  }

  Color _getStockColor(int stock) {
    if (stock == 0) return Colors.red;
    if (stock < 10) return Colors.orange;
    return Colors.green;
  }

  String _formatDate(DateTime date) {
    return '${_twoDigits(date.day)}/${_twoDigits(date.month)}/${date.year}';
  }

  String _twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }
}
