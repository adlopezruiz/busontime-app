// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bot_main_app/dependency_injection/injector.dart';
import 'package:bot_main_app/features/auth/bloc/auth_bloc.dart';
import 'package:bot_main_app/models/custom_error.dart';
import 'package:bot_main_app/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseFirestore firebaseFirestore;
  final fb_auth.FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;
  AuthRepository({
    required this.firebaseFirestore,
    required this.firebaseAuth,
    required this.googleSignIn,
  });

  //FirebaseAuth has a currentUser variable that we can get
  fb_auth.User? get currentUser => firebaseAuth.currentUser;

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
        'createdAt': DateTime.now().millisecondsSinceEpoch,
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
        plugin: 'Register error',
      );
    }
  }

  //Signin function
  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      //Signing user in
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw CustomError(
        code: e.code,
        message: e.message!,
        plugin: e.plugin,
      );
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'Login error',
      );
    }
  }

  //Google sign in
  Future<bool> signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser;
      try {
        googleUser = await getIt<GoogleSignIn>().signIn();
      } on PlatformException catch (e) {
        return false;
      }

      //Check null... if user null means user not selected in google login
      if (googleUser == null) {
        return false;
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result =
          await getIt<FirebaseAuth>().signInWithCredential(credential);

      if (result.additionalUserInfo!.isNewUser) {
        final userData = result.additionalUserInfo!.profile;
        await userRef.doc(result.user!.uid).set({
          'name': userData!['name'],
          'email': userData['email'],
          'profileImage': userData['picture'],
          'favoriteStops': <String>[],
          'createdAt': DateTime.now().millisecondsSinceEpoch,
        });
        getIt<AuthBloc>().add(AuthStateChangedEvent(user: currentUser));
      }
      return true;
    } on FirebaseAuthException catch (e) {
      throw CustomError(
        code: e.code,
        message: e.message!,
        plugin: e.plugin,
      );
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'Login error',
      );
    }
  }

  //Reset password
  Future<void> resetUserPassword(String email) async {
    try {
      await getIt<FirebaseAuth>().sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception(e);
    }
  }

  //Signout
  Future<void> logout() async {
    await firebaseAuth.signOut();
    getIt<GoRouter>().go('/login');
  }
}
