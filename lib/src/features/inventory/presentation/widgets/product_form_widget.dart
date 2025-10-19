import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/domain/entities/product.dart';
import '../bloc/inventory_bloc.dart';
import '../bloc/inventory_event.dart';

class ProductFormWidget extends StatefulWidget {
  final Product? product;

  const ProductFormWidget({super.key, this.product});

  @override
  State<ProductFormWidget> createState() => _ProductFormWidgetState();
}

class _ProductFormWidgetState extends State<ProductFormWidget> {
  late final TextEditingController nameController;
  late final TextEditingController variantController;
  late final TextEditingController stockController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product?.name);
    variantController = TextEditingController(text: widget.product?.variant);
    stockController = TextEditingController(
      text: widget.product?.stock.toString() ?? '0',
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    variantController.dispose();
    stockController.dispose();
    super.dispose();
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      final newProduct = Product(
        id: widget.product?.id ?? 0, // 0 para nuevo producto
        name: nameController.text.trim(),
        variant: variantController.text.trim().isEmpty 
            ? null 
            : variantController.text.trim(),
        stock: int.tryParse(stockController.text) ?? 0,
        storeId: widget.product?.storeId,
        warehouseId: widget.product?.warehouseId,
        updatedAt: DateTime.now(),
      );

      print('💾 Guardando producto: ${newProduct.name}');

      if (widget.product == null) {
        // Agregar nuevo producto
        context.read<InventoryBloc>().add(AddProductEvent(newProduct));
      } else {
        // Actualizar producto existente
        context.read<InventoryBloc>().add(UpdateProductEvent(newProduct));
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a product name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: variantController,
            decoration: const InputDecoration(
              labelText: 'Variant (Optional)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: stockController,
            decoration: const InputDecoration(
              labelText: 'Stock',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter stock quantity';
              }
              if (int.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveProduct,
              child: Text(widget.product == null ? 'Add Product' : 'Update Product'),
            ),
          ),
        ],
      ),
    );
  }
}
