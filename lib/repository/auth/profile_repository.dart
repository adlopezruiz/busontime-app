import 'dart:convert';

import 'package:bot_main_app/models/custom_error.dart';
import 'package:bot_main_app/models/user_model.dart';
import 'package:bot_main_app/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:http/http.dart' as http;

class ProfileRepository {
  ProfileRepository({
    required this.firebaseFirestore,
  });
  final FirebaseFirestore firebaseFirestore;

  Future<UserModel> getProfile({required String uid}) async {
    final bearer = await FirebaseAuth.instance.currentUser!.getIdToken();
    print('Bearer: ${bearer.toString()}');
    final token = 'Bearer $bearer';

    final apiUrl = Uri.parse('http://10.0.2.2:3000/users');

    final response = await http.get(apiUrl, headers: {'Authorization': token});

    final responseJson = jsonDecode(response.body);
    print('Response: $responseJson');

    try {
      //TODO REFACTOR USE API TO GET USER DATA
      final DocumentSnapshot userDoc = await userRef.doc(uid).get();

      if (userDoc.exists) {
        final currentUser = UserModel.fromDoc(userDoc);
        return currentUser;
      }

      throw 'User not found';
    } on FirebaseException catch (e) {
      throw CustomError(code: e.code, message: e.message!, plugin: e.plugin);
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server/server_error',
      );
    }
  }
}
