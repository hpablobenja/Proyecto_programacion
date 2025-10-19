import 'package:drift/drift.dart';
import '../../../../core/data/datasources/local/app_database.dart';
import '../../../../core/data/models/product_model.dart';
import '../../../../core/domain/entities/product.dart' as domain;

class InventoryLocalDataSource {
  final AppDatabase database;

  InventoryLocalDataSource(this.database);

  Future<List<domain.Product>> getProducts(int? storeId, int? warehouseId) async {
    final query = database.select(database.products)
      ..where(
        (tbl) => storeId != null
            ? tbl.storeId.equals(storeId)
            : tbl.warehouseId.equals(warehouseId!),
      );
    final result = await query.get();
    return result
        .map(
          (row) => ProductModel(
            id: row.id,
            name: row.name,
            variant: row.variant,
            stock: row.stock,
            storeId: row.storeId,
            warehouseId: row.warehouseId,
            updatedAt: row.updatedAt,
          ).toEntity(),
        )
        .toList();
  }

  Future<void> saveProducts(List<domain.Product> products) async {
    for (var product in products) {
      await database
          .into(database.products)
          .insertOnConflictUpdate(
            ProductsCompanion(
              id: Value(product.id),
              name: Value(product.name),
              variant: Value(product.variant),
              stock: Value(product.stock),
              storeId: Value(product.storeId),
              warehouseId: Value(product.warehouseId),
              updatedAt: Value(product.updatedAt),
            ),
          );
    }
  }

  Future<void> addProduct(domain.Product product) async {
    await database
        .into(database.products)
        .insert(
          ProductsCompanion(
            id: Value(product.id),
            name: Value(product.name),
            variant: Value(product.variant),
            stock: Value(product.stock),
            storeId: Value(product.storeId),
            warehouseId: Value(product.warehouseId),
            updatedAt: Value(product.updatedAt),
          ),
        );
  }

  Future<void> updateProduct(domain.Product product) async {
    await (database.update(
      database.products,
    )..where((tbl) => tbl.id.equals(product.id))).write(
      ProductsCompanion(
        name: Value(product.name),
        variant: Value(product.variant),
        stock: Value(product.stock),
        storeId: Value(product.storeId),
        warehouseId: Value(product.warehouseId),
        updatedAt: Value(product.updatedAt),
      ),
    );
  }

  Future<void> deleteProduct(int id) async {
    await (database.delete(
      database.products,
    )..where((tbl) => tbl.id.equals(id))).go();
  }
}
