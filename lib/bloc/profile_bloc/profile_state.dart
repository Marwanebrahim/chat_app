import 'package:chat_app/models/user_model.dart';
import 'package:equatable/equatable.dart';

sealed class ProfileState extends Equatable {}

class ProfileIntialState extends ProfileState {
  @override
  List<Object?> get props => [];
}

class ProfileLoadingState extends ProfileState {
  @override
  List<Object?> get props => [];
}

class ProfileSuccessState extends ProfileState {
  final UserModel user;
  ProfileSuccessState({required this.user});
  @override
  List<Object?> get props => [user];
}

class ProfileErrorState extends ProfileState {
  final String errorMessage;
  ProfileErrorState({required this.errorMessage});
  @override
  List<Object?> get props => [errorMessage];
}

class ProfileLogoutState extends ProfileState {
  @override
  List<Object?> get props => [];
}

class ChangePasswordSuccessState extends ProfileState {
  ChangePasswordSuccessState();
  @override
  List<Object?> get props => [];
}


