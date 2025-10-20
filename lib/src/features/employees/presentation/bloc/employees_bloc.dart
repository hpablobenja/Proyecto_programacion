import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/domain/usercases/employees/get_employees_usecase.dart';
import '../../../../core/domain/usercases/employees/add_employee_usecase.dart';
import '../../../../core/domain/usercases/employees/update_employee_usecase.dart';
import '../../../../core/domain/usercases/employees/delete_employee_usecase.dart';
import 'employees_event.dart';
import 'employees_state.dart';

class EmployeesBloc extends Bloc<EmployeesEvent, EmployeesState> {
  final GetEmployeesUseCase getEmployeesUseCase;
  final AddEmployeeUseCase addEmployeeUseCase;
  final UpdateEmployeeUseCase updateEmployeeUseCase;
  final DeleteEmployeeUseCase deleteEmployeeUseCase;

  EmployeesBloc({
    required this.getEmployeesUseCase,
    required this.addEmployeeUseCase,
    required this.updateEmployeeUseCase,
    required this.deleteEmployeeUseCase,
  }) : super(EmployeesInitial()) {
    on<LoadEmployeesEvent>(_onLoadEmployees);
    on<CreateEmployeeEvent>(_onCreateEmployee);
    on<UpdateEmployeeEvent>(_onUpdateEmployee);
    on<DeleteEmployeeEvent>(_onDeleteEmployee);
  }

  Future<void> _onLoadEmployees(
    LoadEmployeesEvent event,
    Emitter<EmployeesState> emit,
  ) async {
    emit(EmployeesLoading());
    try {
      final employees = await getEmployeesUseCase();
      emit(EmployeesLoaded(employees));
    } catch (e) {
      emit(EmployeesError('Error al cargar empleados: $e'));
    }
  }

  Future<void> _onCreateEmployee(
    CreateEmployeeEvent event,
    Emitter<EmployeesState> emit,
  ) async {
    emit(EmployeesLoading());
    try {
      final employee = await addEmployeeUseCase(event.employee);
      emit(EmployeeCreated(employee));
    } catch (e) {
      emit(EmployeesError('Error al crear empleado: $e'));
    }
  }

  Future<void> _onUpdateEmployee(
    UpdateEmployeeEvent event,
    Emitter<EmployeesState> emit,
  ) async {
    emit(EmployeesLoading());
    try {
      final employee = await updateEmployeeUseCase(event.employee);
      emit(EmployeeUpdated(employee));
    } catch (e) {
      emit(EmployeesError('Error al actualizar empleado: $e'));
    }
  }

  Future<void> _onDeleteEmployee(
    DeleteEmployeeEvent event,
    Emitter<EmployeesState> emit,
  ) async {
    emit(EmployeesLoading());
    try {
      await deleteEmployeeUseCase(event.employeeId);
      emit(EmployeeDeleted(event.employeeId));
    } catch (e) {
      emit(EmployeesError('Error al eliminar empleado: $e'));
    }
  }
}
