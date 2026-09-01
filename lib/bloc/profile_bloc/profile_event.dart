import 'package:equatable/equatable.dart';

sealed class ProfileEvent extends Equatable{}

class GetProfileEvent extends ProfileEvent {
  @override
  List<Object?> get props => [];
}

  class ChangePasswordEvent extends ProfileEvent {
  final String currentPassword;
  final String newPassword;
  ChangePasswordEvent({required this.currentPassword, required this.newPassword});
  @override
  List<Object?> get props => [currentPassword, newPassword];
}

class ChangeUserNameEvent extends ProfileEvent {
  final String username;
  ChangeUserNameEvent({required this.username});
  @override
  List<Object?> get props => [username];
}

class LogOutEvent extends ProfileEvent {
  @override
  List<Object?> get props => [];
}
