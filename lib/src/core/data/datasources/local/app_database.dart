import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// Cola de sincronización para operaciones offline
class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entityType =>
      text()(); // product, sale, purchase, transfer, employee, etc.
  TextColumn get operation => text()(); // create, update, delete
  TextColumn get payload => text()(); // JSON serializado
  IntColumn get priority =>
      integer().withDefault(const Constant(5))(); // 1 alta, 9 baja
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

// Registro de conflictos durante la sincronización
class SyncConflicts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entityType => text()();
  IntColumn get localId => integer().nullable()();
  TextColumn get remoteId => text().nullable()();
  TextColumn get localPayload => text()(); // JSON
  TextColumn get remotePayload => text().nullable()(); // JSON
  TextColumn get resolution =>
      text().nullable()(); // chosen_local, chosen_remote, merged
  DateTimeColumn get createdAt => dateTime()();
}

// Sesión de autenticación local para trabajo offline
class AuthSession extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get employeeId => integer().references(Employees, #id)();
  TextColumn get role => text()();
  IntColumn get storeId => integer().nullable()();
  IntColumn get warehouseId => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get variant => text().nullable()();
  IntColumn get stock => integer()();
  IntColumn get storeId => integer().nullable()();
  IntColumn get warehouseId => integer().nullable()();
  DateTimeColumn get updatedAt => dateTime()();
}

class Employees extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get email => text()();
  TextColumn get password => text()();
  TextColumn get role => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get address => text().nullable()();
  IntColumn get storeId => integer().nullable()();
  IntColumn get warehouseId => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}

class Stores extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get address => text()();
  TextColumn get phone => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

class Warehouses extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get address => text()();
  TextColumn get phone => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

// Tabla para ventas (compatible con Supabase)
class Sales extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get productId => integer().references(Products, #id)();
  IntColumn get quantity => integer()();
  RealColumn get unitPrice => real().nullable()();
  RealColumn get totalPrice => real().nullable()();
  IntColumn get employeeId => integer().references(Employees, #id)();
  IntColumn get storeId => integer().nullable()();
  TextColumn get customerName => text().nullable()();
  TextColumn get customerPhone => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
}

// Tabla para compras (compatible con Supabase)
class Purchases extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get productId => integer().references(Products, #id)();
  IntColumn get quantity => integer()();
  RealColumn get unitPrice => real().nullable()();
  RealColumn get totalPrice => real().nullable()();
  IntColumn get employeeId => integer().references(Employees, #id)();
  IntColumn get storeId => integer().nullable()();
  IntColumn get warehouseId => integer().nullable()();
  TextColumn get supplierName => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
}

// Tabla para transferencias (compatible con Supabase)
class Transfers extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get productId => integer().references(Products, #id)();
  IntColumn get quantity => integer()();
  IntColumn get employeeId => integer().references(Employees, #id)();
  TextColumn get fromLocationType =>
      text().withLength(min: 1, max: 20)(); // 'store' or 'warehouse'
  IntColumn get fromLocationId => integer()();
  TextColumn get toLocationType =>
      text().withLength(min: 1, max: 20)(); // 'store' or 'warehouse'
  IntColumn get toLocationId => integer()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
}

// Tabla de transacciones unificada (para compatibilidad local)
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type =>
      text().withLength(min: 1, max: 20)(); // purchase, sale, transfer
  IntColumn get productId => integer().references(Products, #id)();
  IntColumn get quantity => integer()();
  IntColumn get employeeId => integer().references(Employees, #id)();
  IntColumn get storeId => integer().nullable()();
  IntColumn get warehouseId => integer().nullable()();
  IntColumn get fromLocationId => integer().nullable()();
  IntColumn get toLocationId => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
}

@DriftDatabase(
  tables: [
    Products,
    Employees,
    Stores,
    Warehouses,
    Sales,
    Purchases,
    Transfers,
    Transactions,
    SyncQueue,
    SyncConflicts,
    AuthSession,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_database.sqlite'));
    return NativeDatabase(file);
  });
}
