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
  final String? photoUrl;

  UserModel({
    required this.username,
    this.email,
    required this.uid,
    this.photoUrl,
  });

  factory UserModel.fromJson(Map<dynamic, dynamic> map) {
    return UserModel(
      username: map['username'] ?? "",
      email: map['email'] ?? "",
      uid: map['uid'] ?? "",
      photoUrl: map['photoUrl'],
    );
  }

  factory UserModel.empty() {
    return UserModel(username: '', email: null, uid: '', photoUrl: null);
  }

  /// Model -> Map
  Map<String, dynamic> toJson() {
    return {'username': username, 'email': email, 'uid': uid, 'photoUrl': photoUrl};
  }

  UserModel copyWith({
    String? username,
    String? email,
    String? uid,
    String? photoUrl,
  }) {
    return UserModel(
      username: username ?? this.username,
      email: email ?? this.email,
      uid: uid ?? this.uid,
      photoUrl: photoUrl ?? this.photoUrl,
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
      photoUrl: user.photoURL,
    );
  }
}
