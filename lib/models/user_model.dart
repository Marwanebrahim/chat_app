import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_ce/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  final String username;

  @HiveField(1)
  final String? email;

  @HiveField(2)
  final String uid;

  @HiveField(3)
  final String? emoji;

  UserModel({
    required this.username,
    this.email,
    required this.uid,
    this.emoji,
  });

  factory UserModel.fromJson(Map<dynamic, dynamic> map) {
    return UserModel(
      username: map['username'] ?? "",
      email: map['email'] ?? "",
      uid: map['uid'] ?? "",
      emoji: map['emoji'],
    );
  }

  factory UserModel.empty() {
    return UserModel(username: '', email: null, uid: '', emoji: null);
  }

  /// Model -> Map
  Map<String, dynamic> toJson() {
    return {'username': username, 'email': email, 'uid': uid, 'emoji': emoji};
  }

  UserModel copyWith({
    String? username,
    String? email,
    String? uid,
    String? emoji,
  }) {
    return UserModel(
      username: username ?? this.username,
      email: email ?? this.email,
      uid: uid ?? this.uid,
      emoji: emoji ?? this.emoji,
    );
  }

  factory UserModel.fromUserCredential(UserCredential credential) {
    final user = credential.user;
    if (user == null) {
      throw Exception("User is null");
    }
    return UserModel(
      username: user.displayName ?? "",
      email: user.email ?? "",
      uid: user.uid,
      emoji: user.photoURL,
    );
  }
}
