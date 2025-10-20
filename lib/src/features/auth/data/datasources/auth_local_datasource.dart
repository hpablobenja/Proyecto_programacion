import 'package:drift/drift.dart';
import '../../../../core/data/datasources/local/app_database.dart';
import '../../../../core/domain/entities/employee.dart' as domain;

class AuthLocalDataSource {
  final AppDatabase database;

  AuthLocalDataSource(this.database);

  Future<void> cacheUser(
    domain.Employee employee, {
    String? rawPassword,
  }) async {
    try {
      print('💾 AuthLocalDataSource: Iniciando cacheUser');
      print(
        '💾 Datos del empleado: id=${employee.id}, email=${employee.email}',
      );

      await database
          .into(database.employees)
          .insertOnConflictUpdate(
            EmployeesCompanion(
              id: Value(employee.id),
              name: Value(employee.name),
              email: Value(employee.email),
              password: Value(rawPassword ?? ''),
              role: Value(employee.role),
              storeId: Value(employee.storeId),
              warehouseId: Value(employee.warehouseId),
              createdAt: Value(employee.createdAt),
              updatedAt: Value(employee.updatedAt ?? DateTime.now()),
            ),
          );
      print('💾 AuthLocalDataSource: Usuario cacheado exitosamente');
    } catch (e, stackTrace) {
      print('❌ AuthLocalDataSource: Error al cachear usuario: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<domain.Employee?> getCachedUser() async {
    final query = database.select(database.employees);
    final result = await query.getSingleOrNull();
    return result != null
        ? domain.Employee(
            id: result.id,
            name: result.name,
            email: result.email,
            role: result.role,
            phone: null, // TODO: Add phone field to generated table
            address: null, // TODO: Add address field to generated table
            storeId: result.storeId,
            warehouseId: result.warehouseId,
            createdAt: result.createdAt,
            updatedAt: result.updatedAt,
          )
        : null;
  }

  Future<domain.Employee?> loginOffline(String email, String password) async {
    final row = await (database.select(
      database.employees,
    )..where((tbl) => tbl.email.equals(email))).getSingleOrNull();
    if (row == null) return null;
    final storedPassword = row.password;
    if (storedPassword.isNotEmpty && storedPassword != password) {
      return null;
    }
    return domain.Employee(
      id: row.id,
      name: row.name,
      email: row.email,
      role: row.role,
      phone: null,
      address: null,
      storeId: row.storeId,
      warehouseId: row.warehouseId,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
