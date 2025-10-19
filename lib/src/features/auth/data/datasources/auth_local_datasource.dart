import 'package:drift/drift.dart';
import '../../../../core/data/datasources/local/app_database.dart';
import '../../../../core/domain/entities/employee.dart' as domain;

class AuthLocalDataSource {
  final AppDatabase database;

  AuthLocalDataSource(this.database);

  Future<void> cacheUser(domain.Employee employee) async {
    try {
      print('💾 AuthLocalDataSource: Iniciando cacheUser');
      print('💾 Datos del empleado: id=${employee.id}, email=${employee.email}');
      
      await database.into(database.employees).insertOnConflictUpdate(
            EmployeesCompanion(
              id: Value(employee.id),
              name: Value(employee.name),
              email: Value(employee.email),
              password: const Value(''),
              role: Value(employee.role),
              storeId: Value(employee.storeId),
              warehouseId: Value(employee.warehouseId),
              createdAt: Value(DateTime.now()),
              updatedAt: Value(DateTime.now()),
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
            storeId: result.storeId,
            warehouseId: result.warehouseId,
          )
        : null;
  }
}
