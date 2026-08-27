import 'package:chat_app/models/user_model.dart';
import 'package:hive_ce/hive.dart';

class UserService {
  UserService._internal();

  static final UserService instance = UserService._internal();

  static const String boxName = "user";

  Future<void> saveUser(UserModel user) async {
    final box = Hive.box<UserModel>(boxName);
    await box.put("user", user);
  }

  Future<UserModel?> getUser() async {
    final box = Hive.box<UserModel>(boxName);
    return box.get("user");
  }

  Future<void> clearUser() async {
    final box = Hive.box<UserModel>(boxName);
    await box.delete("user");
  }
}
