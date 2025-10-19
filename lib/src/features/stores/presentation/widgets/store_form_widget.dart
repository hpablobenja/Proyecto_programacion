import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/domain/entities/store.dart';
import '../bloc/stores_bloc.dart';
import '../bloc/stores_event.dart';

class StoreFormWidget extends StatefulWidget {
  final Store? store;

  const StoreFormWidget({super.key, this.store});

  @override
  State<StoreFormWidget> createState() => _StoreFormWidgetState();
}

class _StoreFormWidgetState extends State<StoreFormWidget> {
  late final TextEditingController nameController;
  late final TextEditingController addressController;
  late final TextEditingController phoneController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.store?.name);
    addressController = TextEditingController(text: widget.store?.address);
    phoneController = TextEditingController(text: widget.store?.phone);
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _saveStore() {
    if (_formKey.currentState!.validate()) {
      final newStore = Store(
        id: widget.store?.id ?? 0,
        name: nameController.text.trim(),
        address: addressController.text.trim(),
        phone: phoneController.text.trim().isEmpty 
            ? null 
            : phoneController.text.trim(),
        createdAt: widget.store?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      print('💾 Guardando tienda: ${newStore.name}');

      if (widget.store == null) {
        context.read<StoresBloc>().add(AddStoreEvent(newStore));
      } else {
        context.read<StoresBloc>().add(UpdateStoreEvent(newStore));
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
                labelText: 'Nombre de la Tienda',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.store),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Por favor ingrese el nombre de la tienda';
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
              onPressed: _saveStore,
              icon: Icon(widget.store == null ? Icons.add : Icons.save),
              label: Text(
                widget.store == null ? 'Agregar Tienda' : 'Actualizar Tienda',
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
