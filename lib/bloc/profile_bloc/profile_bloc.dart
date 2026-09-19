import 'package:chat_app/bloc/profile_bloc/profile_event.dart';
import 'package:chat_app/bloc/profile_bloc/profile_state.dart';
import 'package:chat_app/services/profile_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileIntialState()) {
    on<GetProfileEvent>(_getProfileEvent);
    on<ChangePasswordEvent>(_changePasswordEvent);
    on<ChangeUserNameEvent>(_changeUserNameEvent);
    on<LogOutEvent>(_logOutEvent);
  }
  final _profileService = ProfileService.instance;
  void _getProfileEvent(
    GetProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoadingState());
    try {
      final user = await _profileService.getUser();
      emit(ProfileSuccessState(user: user));
    } catch (e) {
      emit(ProfileErrorState(errorMessage: e.toString()));
    }
  }

  void _changePasswordEvent(
    ChangePasswordEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await _profileService.changePassword(
        currentPassword: event.currentPassword,
        newPassword: event.newPassword,
      );
      emit(ChangePasswordSuccessState());
    } catch (e) {
      emit(ProfileErrorState(errorMessage: e.toString()));
    }
  }

  void _changeUserNameEvent(
    ChangeUserNameEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoadingState());
    try {
      final user = await _profileService.changeUserName(
        username: event.username,
      );
      emit(ProfileSuccessState(user: user));
    } catch (e) {
      emit(ProfileErrorState(errorMessage: e.toString()));
    }
  }

  void _logOutEvent(LogOutEvent event, Emitter<ProfileState> emit) {
    try {
      _profileService.logout();
      emit(ProfileLogoutState());
    } catch (e) {
      emit(ProfileErrorState(errorMessage: e.toString()));
    }
  }
}
