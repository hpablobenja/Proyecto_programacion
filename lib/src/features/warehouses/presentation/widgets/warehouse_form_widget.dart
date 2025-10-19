import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/domain/entities/warehouse.dart';
import '../bloc/warehouses_bloc.dart';
import '../bloc/warehouses_event.dart';

class WarehouseFormWidget extends StatefulWidget {
  final Warehouse? warehouse;

  const WarehouseFormWidget({super.key, this.warehouse});

  @override
  State<WarehouseFormWidget> createState() => _WarehouseFormWidgetState();
}

class _WarehouseFormWidgetState extends State<WarehouseFormWidget> {
  late final TextEditingController nameController;
  late final TextEditingController addressController;
  late final TextEditingController phoneController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.warehouse?.name);
    addressController = TextEditingController(text: widget.warehouse?.address);
    phoneController = TextEditingController(text: widget.warehouse?.phone);
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _saveWarehouse() {
    if (_formKey.currentState!.validate()) {
      final newWarehouse = Warehouse(
        id: widget.warehouse?.id ?? 0,
        name: nameController.text.trim(),
        address: addressController.text.trim(),
        phone: phoneController.text.trim().isEmpty 
            ? null 
            : phoneController.text.trim(),
        createdAt: widget.warehouse?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      print('💾 Guardando almacén: ${newWarehouse.name}');

      if (widget.warehouse == null) {
        context.read<WarehousesBloc>().add(AddWarehouseEvent(newWarehouse));
      } else {
        context.read<WarehousesBloc>().add(UpdateWarehouseEvent(newWarehouse));
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre del Almacén',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.warehouse),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Por favor ingrese el nombre del almacén';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'Dirección',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
              maxLines: 2,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Por favor ingrese la dirección';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Teléfono (Opcional)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _saveWarehouse,
              icon: Icon(widget.warehouse == null ? Icons.add : Icons.save),
              label: Text(
                widget.warehouse == null ? 'Agregar Almacén' : 'Actualizar Almacén',
                style: const TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
