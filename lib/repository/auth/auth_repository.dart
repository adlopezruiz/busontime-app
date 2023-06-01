// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bot_main_app/models/custom_error.dart';
import 'package:bot_main_app/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

class AuthRepository {
  final FirebaseFirestore firebaseFirestore;
  final fb_auth.FirebaseAuth firebaseAuth;
  AuthRepository({
    required this.firebaseFirestore,
    required this.firebaseAuth,
  });

  //FirebaseAuth has a userChanges method that we can listen to act depending on user status
  Stream<fb_auth.User?> get user => firebaseAuth.userChanges();

  //Register function
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      //Creating new user to firebase
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      //Saving new user signed in credentials, if signed up -> Automatically signin, we can access to user data
      final signedInUser = userCredential.user!;

      //Creating firestore user instance to store extra data
      await userRef.doc(signedInUser.uid).set({
        'name': name,
        'email': email,
        'profileImage': 'https://picsum.photos/300',
        'favoriteStops': <String>[],
        'lastLocation': '', //TODO get user location
      });
    } on fb_auth.FirebaseAuthException catch (e) {
      throw CustomError(
        code: e.code,
        message: e.message!,
        plugin: e.plugin,
      );
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }

  //Signin function
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      //Signing user in
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on fb_auth.FirebaseAuthException catch (e) {
      throw CustomError(
        code: e.code,
        message: e.message!,
        plugin: e.plugin,
      );
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }

  //Signout
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }
}
