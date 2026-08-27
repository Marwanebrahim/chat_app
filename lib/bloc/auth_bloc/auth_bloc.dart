import 'package:chat_app/bloc/auth_bloc/auth_event.dart';
import 'package:chat_app/bloc/auth_bloc/auth_state.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthIntialState()) {
    on<AuthLoginEvent>(_authLoginEvent);
    on<AuthSignupEvent>(_authSignupEvent);
    on<AuthGoogleSignupEvent>(_authGoogleSignupEvent);
    on<AuthLogoutEvent>(_authLogoutEvent);
  }
  final AuthService _authService = AuthService.instance;

  Future<void> _authLoginEvent(
    AuthLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final result = await _authService.login(
        email: event.email,
        password: event.password,
      );
      emit(AuthSuccessState(user: result));
    } catch (e) {
      emit(AuthFailureState(errorMessage: e.toString()));
    }
  }

  Future<void> _authSignupEvent(
    AuthSignupEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final result = await _authService.signup(
        email: event.email,
        password: event.password,
        username: event.username,
        emoji: "👨‍💼",
      );
      emit(AuthSuccessState(user: result));
    } catch (e) {
      emit(AuthFailureState(errorMessage: e.toString()));
    }
  }

  Future<void> _authGoogleSignupEvent(
    AuthGoogleSignupEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final result = await _authService.signInWithGoogle();
      emit(AuthSuccessState(user: result));
    } catch (e) {
      emit(AuthFailureState(errorMessage: e.toString()));
    }
  }

  Future<void> _authLogoutEvent(
    AuthLogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      await _authService.logout();
      emit(AuthLogoutState());
    } catch (e) {
      emit(AuthFailureState(errorMessage: e.toString()));
    }
  }
}
