import 'package:chat_app/core/constants/firebase_constants.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserSearchService {
  UserSearchService._();
  static final UserSearchService instance = UserSearchService._();

  final _firestore = FirebaseFirestore.instance;

  Future<List<UserModel>> searchUsers(String query) async {
    try {
      final lowerQuery = query.toLowerCase();

      final snapshot = await _firestore
          .collection(FirebaseConstants.usersCollection)
          .where('usernameLowercase', isGreaterThanOrEqualTo: lowerQuery)
          .where('usernameLowercase', isLessThanOrEqualTo: '$lowerQuery\uf8ff')
          .limit(20)
          .get();

      return snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable' || e.code == 'network-request-failed') {
        throw "No internet connection. Please check your network and try again";
      }
      throw "Something went wrong while searching";
    }
  }
}
