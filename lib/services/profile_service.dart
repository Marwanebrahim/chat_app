import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/user_service.dart';

class ProfileService {
  ProfileService._internal();

  static final ProfileService instance = ProfileService._internal();

  final _userService = UserService.instance;
  final _authService = AuthService.instance;
  Future<UserModel> getUser() async {
    try {
      final user = await _userService.getUser();
      if (user == null) throw "No user found";
      return user;
    } catch (e) {
      throw Exception("Failed to get user: $e");
    }
  }

  Future<void> logout() async {
    try {
      await _userService.clearUser();
      await _authService.logout();
    } catch (e) {
      throw Exception("Failed to logout: $e");
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _authService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
    } catch (e) {
      throw Exception("Failed to change password: $e");
    }
  }

  Future<UserModel> changeUserName({required String username}) async {
    try {
      return await _authService.changeUserName(username: username);
    } catch (e) {
      throw Exception("Failed to change username: $e");
    }
  }
}
