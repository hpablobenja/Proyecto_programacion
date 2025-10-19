import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/domain/usercases/auth/login_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;

  AuthBloc({required this.loginUseCase}) : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      print('📱 AuthBloc: Recibido LoginEvent');
      emit(AuthLoading());
      print('📱 AuthBloc: Estado cambiado a AuthLoading');
      
      try {
        print('📱 AuthBloc: Llamando a loginUseCase...');
        final employee = await loginUseCase(event.email, event.password)
            .timeout(
          const Duration(seconds: 30),
          onTimeout: () {
            print('⏱️ AuthBloc: Timeout alcanzado');
            throw Exception('Login timeout: La operación tardó demasiado');
          },
        );
        print('📱 AuthBloc: Login exitoso, emitiendo AuthAuthenticated');
        emit(AuthAuthenticated(employee));
      } catch (e) {
        print('📱 AuthBloc: Error capturado: $e');
        emit(AuthError(e.toString()));
      }
    });

    on<LogoutEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        // Llamar a logout si necesario
        emit(AuthUnauthenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<AuthCheckStatusEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        // Verificar si hay un usuario autenticado
        // Por ahora, asumimos que no hay usuario autenticado
        emit(AuthUnauthenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
  }
}
