import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable {}

class AuthLoginEvent extends AuthEvent {
  final String email;
  final String password;

  AuthLoginEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthSignupEvent extends AuthEvent {
  final String email;
  final String password;
  final String username;

  AuthSignupEvent({
    required this.email,
    required this.password,
    required this.username,
  });

  @override
  List<Object?> get props => [email, password, username];
}

class AuthGoogleSignupEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class AuthLogoutEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}
