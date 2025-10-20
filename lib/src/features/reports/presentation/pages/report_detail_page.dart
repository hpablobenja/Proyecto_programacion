import 'package:flutter/material.dart';
import '../../../../core/domain/entities/report.dart';

class ReportDetailPage extends StatelessWidget {
  final Report report;

  const ReportDetailPage({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(report.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Implementar compartir reporte
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Función de compartir en desarrollo'),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información del Reporte
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      report.description,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          _getReportIcon(report.type),
                          color: _getReportColor(report.type),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _getReportTypeName(report.type),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _getReportColor(report.type),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Generado: ${_formatDate(report.generatedAt)}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Filtros Aplicados
            if (report.startDate != null ||
                report.endDate != null ||
                report.storeId != null ||
                report.warehouseId != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Filtros Aplicados',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (report.startDate != null)
                        _buildFilterItem(
                          'Fecha de Inicio',
                          _formatDate(report.startDate!),
                        ),
                      if (report.endDate != null)
                        _buildFilterItem(
                          'Fecha de Fin',
                          _formatDate(report.endDate!),
                        ),
                      if (report.storeId != null)
                        _buildFilterItem(
                          'Tienda ID',
                          report.storeId.toString(),
                        ),
                      if (report.warehouseId != null)
                        _buildFilterItem(
                          'Almacén ID',
                          report.warehouseId.toString(),
                        ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // Datos del Reporte
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Datos del Reporte',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildReportData(report.data),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildReportData(Map<String, dynamic> data) {
    if (data.isEmpty) {
      return const Text(
        'No hay datos disponibles para este reporte.',
        style: TextStyle(color: Colors.grey),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 150,
                child: Text(
                  '${entry.key}:',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Text(
                  entry.value.toString(),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Color _getReportColor(String type) {
    switch (type) {
      case 'sales':
        return Colors.green;
      case 'purchases':
        return Colors.blue;
      case 'transfers':
        return Colors.orange;
      case 'daily_sales':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getReportIcon(String type) {
    switch (type) {
      case 'sales':
        return Icons.shopping_cart;
      case 'purchases':
        return Icons.shopping_bag;
      case 'transfers':
        return Icons.swap_horiz;
      case 'daily_sales':
        return Icons.trending_up;
      default:
        return Icons.assessment;
    }
  }

  String _getReportTypeName(String type) {
    switch (type) {
      case 'sales':
        return 'Reporte de Ventas';
      case 'purchases':
        return 'Reporte de Compras';
      case 'transfers':
        return 'Reporte de Transferencias';
      case 'daily_sales':
        return 'Venta Global del Día';
      default:
        return 'Reporte';
    }
  }

  String _formatDate(DateTime date) {
    return '${_twoDigits(date.day)}/${_twoDigits(date.month)}/${date.year} ${_twoDigits(date.hour)}:${_twoDigits(date.minute)}';
  }

  String _twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }
}
