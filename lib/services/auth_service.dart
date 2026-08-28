import 'package:chat_app/core/constants/firebase_constants.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  AuthService._internal();

  static final AuthService instance = AuthService._internal();

  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _userService = UserService.instance;
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user == null) throw "Something went wrong";
      final user = UserModel.fromUserCredential(credential);
      await _userService.saveUser(user);
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        throw 'Email or password is incorrect';
      }
      if (e.code == 'user-not-found') throw "No user found for that email";
      if (e.code == 'wrong-password') {
        throw "Wrong password provided for that user";
      }
      throw "Something went wrong";
    }
  }

  Future<UserModel> signup({
    required String email,
    required String password,
    required String username,
    required String photoUrl,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user == null) throw "Something went wrong";

      final user = UserModel.fromUserCredential(credential);
      await _firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(credential.user!.uid)
          .set(user.toJson());

      await _userService.saveUser(user);

      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw 'The password provided is too weak';
      }
      if (e.code == 'email-already-in-use') {
        throw "The account already exists for that email";
      }
      throw "Something went wrong";
    }
  }

  Future<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;
      googleSignIn.initialize();
      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      if (userCredential.user == null) throw "Something went wrong";
      final user = UserModel.fromUserCredential(userCredential);
      await _firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(user.uid)
          .set(user.toJson());
      await _userService.saveUser(user);
      return user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Something went wrong";
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw "Google sign in was canceled";
      }
      throw e.toString();
    } catch (e) {
      throw e.toString();
    }
  }


  Future<void> logout() async {
    try {
      final isGoogleUser =
          _firebaseAuth.currentUser?.providerData.any(
            (provider) => provider.providerId == 'google.com',
          ) ??
          false;

      if (isGoogleUser) {
        await GoogleSignIn.instance.signOut();
      }

      await _firebaseAuth.signOut();
      await _userService.clearUser();
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Something went wrong";
    } catch (e) {
      throw e.toString();
    }
  }
}
