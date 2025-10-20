import '../../../domain/entities/report.dart';
import '../../../domain/repositories/reports_repository.dart';
import '../../../domain/repositories/sales_repository.dart';
import '../../../domain/repositories/purchases_repository.dart';
import '../../../domain/repositories/transfers_repository.dart';
import '../../../domain/entities/sale.dart';

class ReportsRepositoryImpl implements ReportsRepository {
  final SalesRepository salesRepository;
  final PurchasesRepository purchasesRepository;
  final TransfersRepository transfersRepository;

  ReportsRepositoryImpl({
    required this.salesRepository,
    required this.purchasesRepository,
    required this.transfersRepository,
  });

  @override
  Future<Report> generateSalesReport({
    int? storeId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      print('🔍 Generando reporte de ventas...');
      print(
        '📊 Parámetros: storeId=$storeId, startDate=$startDate, endDate=$endDate',
      );

      // Obtener ventas con filtros
      final sales = await salesRepository.getSales(storeId, startDate, endDate);
      print('📈 Ventas obtenidas: ${sales.length}');

      // Filtrar ventas según los parámetros
      List<Sale> filteredSales = sales;

      if (storeId != null) {
        filteredSales = filteredSales
            .where((sale) => sale.storeId == storeId)
            .toList();
      }

      if (startDate != null) {
        filteredSales = filteredSales
            .where(
              (sale) =>
                  sale.createdAt.isAfter(startDate) ||
                  sale.createdAt.isAtSameMomentAs(startDate),
            )
            .toList();
      }

      if (endDate != null) {
        filteredSales = filteredSales
            .where(
              (sale) =>
                  sale.createdAt.isBefore(endDate) ||
                  sale.createdAt.isAtSameMomentAs(endDate),
            )
            .toList();
      }

      // Calcular estadísticas
      final totalSales = filteredSales.length;
      final totalRevenue = filteredSales.fold<double>(
        0.0,
        (sum, sale) => sum + (sale.totalPrice ?? 0.0),
      );
      final averageSaleValue = totalSales > 0 ? totalRevenue / totalSales : 0.0;

      print(
        '📊 Estadísticas: totalSales=$totalSales, totalRevenue=$totalRevenue, averageSaleValue=$averageSaleValue',
      );

      // Crear datos del reporte
      final reportData = {
        'total_sales': totalSales,
        'total_revenue': totalRevenue,
        'average_sale_value': averageSaleValue,
        'filtered_sales': filteredSales
            .map(
              (sale) => {
                'id': sale.id,
                'product_id': sale.productId,
                'quantity': sale.quantity,
                'total_price': sale.totalPrice,
                'customer_name': sale.customerName,
                'created_at': sale.createdAt.toIso8601String(),
              },
            )
            .toList(),
      };

      final report = Report(
        id: 'sales_${DateTime.now().millisecondsSinceEpoch}',
        type: 'sales',
        title: 'Reporte de Ventas',
        description: _generateSalesDescription(storeId, startDate, endDate),
        data: reportData,
        generatedAt: DateTime.now(),
        startDate: startDate,
        endDate: endDate,
        storeId: storeId,
      );

      print('✅ Reporte generado exitosamente: ${report.id}');
      return report;
    } catch (e) {
      throw Exception('Error al generar reporte de ventas: $e');
    }
  }

  @override
  Future<Report> generatePurchasesReport({
    int? storeId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      // Obtener compras con filtros
      final purchases = await purchasesRepository.getPurchases(
        storeId,
        null,
        startDate,
        endDate,
      );

      // Calcular estadísticas
      final totalPurchases = purchases.length;
      final totalCost = purchases.fold<double>(
        0.0,
        (sum, purchase) => sum + (purchase.totalPrice ?? 0.0),
      );
      final averagePurchaseValue = totalPurchases > 0
          ? totalCost / totalPurchases
          : 0.0;

      // Crear datos del reporte
      final reportData = {
        'total_purchases': totalPurchases,
        'total_cost': totalCost,
        'average_purchase_value': averagePurchaseValue,
        'filtered_purchases': purchases
            .map(
              (purchase) => {
                'id': purchase.id,
                'product_id': purchase.productId,
                'quantity': purchase.quantity,
                'total_price': purchase.totalPrice,
                'supplier_name': purchase.supplierName,
                'created_at': purchase.createdAt.toIso8601String(),
              },
            )
            .toList(),
      };

      return Report(
        id: 'purchases_${DateTime.now().millisecondsSinceEpoch}',
        type: 'purchases',
        title: 'Reporte de Compras',
        description: _generatePurchasesDescription(storeId, startDate, endDate),
        data: reportData,
        generatedAt: DateTime.now(),
        startDate: startDate,
        endDate: endDate,
        storeId: storeId,
      );
    } catch (e) {
      throw Exception('Error al generar reporte de compras: $e');
    }
  }

  @override
  Future<Report> generateTransfersReport({
    int? storeId,
    int? warehouseId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      // Obtener transferencias con filtros
      final transfers = await transfersRepository.getTransfers(
        storeId,
        warehouseId,
        startDate,
        endDate,
      );

      // Calcular estadísticas
      final totalTransfers = transfers.length;
      final totalQuantity = transfers.fold<int>(
        0,
        (sum, transfer) => sum + transfer.quantity,
      );

      // Crear datos del reporte
      final reportData = {
        'total_transfers': totalTransfers,
        'total_quantity': totalQuantity,
        'filtered_transfers': transfers
            .map(
              (transfer) => {
                'id': transfer.id,
                'product_id': transfer.productId,
                'quantity': transfer.quantity,
                'from_location_type': transfer.fromLocationType,
                'from_location_id': transfer.fromLocationId,
                'to_location_type': transfer.toLocationType,
                'to_location_id': transfer.toLocationId,
                'created_at': transfer.createdAt.toIso8601String(),
              },
            )
            .toList(),
      };

      return Report(
        id: 'transfers_${DateTime.now().millisecondsSinceEpoch}',
        type: 'transfers',
        title: 'Reporte de Transferencias',
        description: _generateTransfersDescription(
          storeId,
          warehouseId,
          startDate,
          endDate,
        ),
        data: reportData,
        generatedAt: DateTime.now(),
        startDate: startDate,
        endDate: endDate,
        storeId: storeId,
        warehouseId: warehouseId,
      );
    } catch (e) {
      throw Exception('Error al generar reporte de transferencias: $e');
    }
  }

  @override
  Future<Report> generateDailySalesReport({DateTime? date}) async {
    try {
      final targetDate = date ?? DateTime.now();
      final startOfDay = DateTime(
        targetDate.year,
        targetDate.month,
        targetDate.day,
      );
      final endOfDay = startOfDay.add(const Duration(days: 1));

      // Obtener todas las ventas del día
      final sales = await salesRepository.getSales(null, startOfDay, endOfDay);
      final dailySales = sales
          .where(
            (sale) =>
                sale.createdAt.isAfter(startOfDay) &&
                sale.createdAt.isBefore(endOfDay),
          )
          .toList();

      // Calcular estadísticas globales
      final totalSales = dailySales.length;
      final totalRevenue = dailySales.fold<double>(
        0.0,
        (sum, sale) => sum + (sale.totalPrice ?? 0.0),
      );
      final averageSaleValue = totalSales > 0 ? totalRevenue / totalSales : 0.0;

      // Agrupar por tienda
      final salesByStore = <int, List<Sale>>{};
      for (final sale in dailySales) {
        if (sale.storeId != null) {
          salesByStore.putIfAbsent(sale.storeId!, () => []).add(sale);
        }
      }

      // Crear datos del reporte
      final reportData = {
        'date': targetDate.toIso8601String(),
        'total_sales': totalSales,
        'total_revenue': totalRevenue,
        'average_sale_value': averageSaleValue,
        'sales_by_store': salesByStore.map(
          (storeId, storeSales) => MapEntry(storeId.toString(), {
            'store_id': storeId,
            'sales_count': storeSales.length,
            'revenue': storeSales.fold<double>(
              0.0,
              (sum, sale) => sum + (sale.totalPrice ?? 0.0),
            ),
          }),
        ),
        'daily_sales': dailySales
            .map(
              (sale) => {
                'id': sale.id,
                'product_id': sale.productId,
                'quantity': sale.quantity,
                'total_price': sale.totalPrice,
                'store_id': sale.storeId,
                'customer_name': sale.customerName,
                'created_at': sale.createdAt.toIso8601String(),
              },
            )
            .toList(),
      };

      return Report(
        id: 'daily_sales_${DateTime.now().millisecondsSinceEpoch}',
        type: 'daily_sales',
        title: 'Venta Global del Día',
        description:
            'Reporte de ventas globales del ${_formatDate(targetDate)}',
        data: reportData,
        generatedAt: DateTime.now(),
        startDate: startOfDay,
        endDate: endOfDay,
      );
    } catch (e) {
      throw Exception('Error al generar reporte de ventas diarias: $e');
    }
  }

  @override
  Future<List<Report>> getReportHistory() async {
    // TODO: Implementar almacenamiento de historial de reportes
    // Por ahora retornar lista vacía
    return [];
  }

  String _generateSalesDescription(
    int? storeId,
    DateTime? startDate,
    DateTime? endDate,
  ) {
    String description = 'Reporte de ventas';

    if (storeId != null) {
      description += ' de la tienda $storeId';
    }

    if (startDate != null && endDate != null) {
      description +=
          ' del ${_formatDate(startDate)} al ${_formatDate(endDate)}';
    } else if (startDate != null) {
      description += ' desde ${_formatDate(startDate)}';
    } else if (endDate != null) {
      description += ' hasta ${_formatDate(endDate)}';
    }

    return description;
  }

  String _generatePurchasesDescription(
    int? storeId,
    DateTime? startDate,
    DateTime? endDate,
  ) {
    String description = 'Reporte de compras';

    if (storeId != null) {
      description += ' de la tienda $storeId';
    }

    if (startDate != null && endDate != null) {
      description +=
          ' del ${_formatDate(startDate)} al ${_formatDate(endDate)}';
    } else if (startDate != null) {
      description += ' desde ${_formatDate(startDate)}';
    } else if (endDate != null) {
      description += ' hasta ${_formatDate(endDate)}';
    }

    return description;
  }

  String _generateTransfersDescription(
    int? storeId,
    int? warehouseId,
    DateTime? startDate,
    DateTime? endDate,
  ) {
    String description = 'Reporte de transferencias';

    if (storeId != null) {
      description += ' de la tienda $storeId';
    }

    if (warehouseId != null) {
      description += ' del almacén $warehouseId';
    }

    if (startDate != null && endDate != null) {
      description +=
          ' del ${_formatDate(startDate)} al ${_formatDate(endDate)}';
    } else if (startDate != null) {
      description += ' desde ${_formatDate(startDate)}';
    } else if (endDate != null) {
      description += ' hasta ${_formatDate(endDate)}';
    }

    return description;
  }

  String _formatDate(DateTime date) {
    return '${_twoDigits(date.day)}/${_twoDigits(date.month)}/${date.year}';
  }

  String _twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }
}
