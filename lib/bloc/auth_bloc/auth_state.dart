import 'package:chat_app/models/user_model.dart';
import 'package:equatable/equatable.dart';

sealed class AuthState extends Equatable {}

class AuthIntialState extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthLoadingState extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthSuccessState extends AuthState {
  final UserModel user;

  AuthSuccessState({required this.user});
  @override
  List<Object?> get props => [user];
}

class AuthFailureState extends AuthState {
  final String errorMessage;

  AuthFailureState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class AuthLogoutState extends AuthState {
  @override
  List<Object?> get props => [];
}
