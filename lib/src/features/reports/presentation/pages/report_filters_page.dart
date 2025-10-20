import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/domain/entities/store.dart';
import '../../../../core/domain/entities/warehouse.dart';
import '../../../../core/domain/usercases/stores/get_stores_usecase.dart';
import '../../../../core/domain/usercases/warehouses/get_warehouses_usecase.dart';
import '../bloc/reports_bloc.dart';
import '../bloc/reports_event.dart';

class ReportFiltersPage extends StatefulWidget {
  const ReportFiltersPage({super.key});

  @override
  State<ReportFiltersPage> createState() => _ReportFiltersPageState();
}

class _ReportFiltersPageState extends State<ReportFiltersPage> {
  final _formKey = GlobalKey<FormState>();

  // Filtros
  String _selectedReportType = 'sales';
  Store? _selectedStore;
  Warehouse? _selectedWarehouse;
  DateTime? _startDate;
  DateTime? _endDate;
  DateTime? _selectedDate;

  // Lists for dropdowns
  List<Store> _stores = [];
  List<Warehouse> _warehouses = [];

  // Loading states
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Load stores
      final getStoresUseCase = GetIt.instance<GetStoresUseCase>();
      final stores = await getStoresUseCase();

      // Load warehouses
      final getWarehousesUseCase = GetIt.instance<GetWarehousesUseCase>();
      final warehouses = await getWarehousesUseCase();

      setState(() {
        _stores = stores;
        _warehouses = warehouses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error al cargar los datos: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generar Reporte'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadData,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Tipo de Reporte
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tipo de Reporte',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: 'Seleccionar tipo de reporte *',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.assessment),
                              ),
                              value: _selectedReportType,
                              items: const [
                                DropdownMenuItem<String>(
                                  value: 'sales',
                                  child: Text('Reporte de Ventas'),
                                ),
                                DropdownMenuItem<String>(
                                  value: 'purchases',
                                  child: Text('Reporte de Compras'),
                                ),
                                DropdownMenuItem<String>(
                                  value: 'transfers',
                                  child: Text('Reporte de Transferencias'),
                                ),
                                DropdownMenuItem<String>(
                                  value: 'daily_sales',
                                  child: Text('Venta Global del Día'),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedReportType = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Filtros de Ubicación
                    if (_selectedReportType != 'daily_sales')
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Filtros de Ubicación',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Store Dropdown
                              DropdownButtonFormField<Store>(
                                decoration: const InputDecoration(
                                  labelText: 'Tienda',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.store),
                                ),
                                value: _selectedStore,
                                items: [
                                  const DropdownMenuItem<Store>(
                                    value: null,
                                    child: Text('Todas las tiendas'),
                                  ),
                                  ..._stores.map((store) {
                                    return DropdownMenuItem<Store>(
                                      value: store,
                                      child: Text(store.name),
                                    );
                                  }).toList(),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedStore = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 16),

                              // Warehouse Dropdown (solo para transferencias)
                              if (_selectedReportType == 'transfers')
                                DropdownButtonFormField<Warehouse>(
                                  decoration: const InputDecoration(
                                    labelText: 'Almacén',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.warehouse),
                                  ),
                                  value: _selectedWarehouse,
                                  items: [
                                    const DropdownMenuItem<Warehouse>(
                                      value: null,
                                      child: Text('Todos los almacenes'),
                                    ),
                                    ..._warehouses.map((warehouse) {
                                      return DropdownMenuItem<Warehouse>(
                                        value: warehouse,
                                        child: Text(warehouse.name),
                                      );
                                    }).toList(),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedWarehouse = value;
                                    });
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),

                    // Filtros de Fecha
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Filtros de Fecha',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),

                            if (_selectedReportType == 'daily_sales')
                              // Fecha específica para ventas diarias
                              ListTile(
                                leading: const Icon(Icons.calendar_today),
                                title: const Text('Fecha'),
                                subtitle: Text(
                                  _selectedDate != null
                                      ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                                      : 'Seleccionar fecha',
                                ),
                                onTap: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate:
                                        _selectedDate ?? DateTime.now(),
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime.now(),
                                  );
                                  if (date != null) {
                                    setState(() {
                                      _selectedDate = date;
                                    });
                                  }
                                },
                              )
                            else
                              // Rango de fechas para otros reportes
                              Column(
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.date_range),
                                    title: const Text('Fecha de Inicio'),
                                    subtitle: Text(
                                      _startDate != null
                                          ? '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'
                                          : 'Seleccionar fecha de inicio',
                                    ),
                                    onTap: () async {
                                      final date = await showDatePicker(
                                        context: context,
                                        initialDate:
                                            _startDate ??
                                            DateTime.now().subtract(
                                              const Duration(days: 30),
                                            ),
                                        firstDate: DateTime(2020),
                                        lastDate: DateTime.now(),
                                      );
                                      if (date != null) {
                                        setState(() {
                                          _startDate = date;
                                        });
                                      }
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.date_range),
                                    title: const Text('Fecha de Fin'),
                                    subtitle: Text(
                                      _endDate != null
                                          ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                                          : 'Seleccionar fecha de fin',
                                    ),
                                    onTap: () async {
                                      final date = await showDatePicker(
                                        context: context,
                                        initialDate: _endDate ?? DateTime.now(),
                                        firstDate: _startDate ?? DateTime(2020),
                                        lastDate: DateTime.now(),
                                      );
                                      if (date != null) {
                                        setState(() {
                                          _endDate = date;
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Generate Button
                    ElevatedButton.icon(
                      onPressed: _generateReport,
                      icon: const Icon(Icons.assessment),
                      label: const Text('Generar Reporte'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _generateReport() async {
    if (_formKey.currentState!.validate()) {
      try {
        switch (_selectedReportType) {
          case 'sales':
            context.read<ReportsBloc>().add(
              GenerateSalesReportEvent(
                storeId: _selectedStore?.id,
                startDate: _startDate,
                endDate: _endDate,
              ),
            );
            break;
          case 'purchases':
            context.read<ReportsBloc>().add(
              GeneratePurchasesReportEvent(
                storeId: _selectedStore?.id,
                startDate: _startDate,
                endDate: _endDate,
              ),
            );
            break;
          case 'transfers':
            context.read<ReportsBloc>().add(
              GenerateTransfersReportEvent(
                storeId: _selectedStore?.id,
                warehouseId: _selectedWarehouse?.id,
                startDate: _startDate,
                endDate: _endDate,
              ),
            );
            break;
          case 'daily_sales':
            context.read<ReportsBloc>().add(
              GenerateDailySalesReportEvent(date: _selectedDate),
            );
            break;
        }

        // Navegar a la página de reportes
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al generar reporte: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
