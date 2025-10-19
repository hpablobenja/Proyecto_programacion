import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/domain/usercases/employees/get_employees_usecase.dart';
import '../../../../core/domain/usercases/employees/update_employee_usecase.dart';
import 'employees_event.dart';
import 'employees_state.dart';

class EmployeesBloc extends Bloc<EmployeesEvent, EmployeesState> {
  final GetEmployeesUseCase getEmployeesUseCase;
  final UpdateEmployeeUseCase updateEmployeeUseCase;

  EmployeesBloc({
    required this.getEmployeesUseCase,
    required this.updateEmployeeUseCase,
  }) : super(EmployeesInitial()) {
    on<LoadEmployeesEvent>((event, emit) async {
      emit(EmployeesLoading());
      try {
        final employees = await getEmployeesUseCase();
        emit(EmployeesLoaded(employees));
      } catch (e) {
        emit(EmployeesError(e.toString()));
      }
    });

    on<CreateEmployeeEvent>((event, emit) async {
      emit(EmployeesLoading());
      try {
        // TODO: Implement create employee use case
        emit(EmployeesLoaded([]));
      } catch (e) {
        emit(EmployeesError(e.toString()));
      }
    });
  }
}
