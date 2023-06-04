import 'dart:convert';

import 'package:bot_main_app/models/custom_error.dart';
import 'package:bot_main_app/models/user_model.dart';
import 'package:bot_main_app/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:http/http.dart' as http;

class UserRepository {
  UserRepository({
    required this.firebaseFirestore,
  });
  final FirebaseFirestore firebaseFirestore;

  //Get user profile
  Future<UserModel> getProfile({required String uid}) async {
    final bearer = await FirebaseAuth.instance.currentUser!.getIdToken();
    //Forming string auth key for the api
    final token = 'Bearer $bearer';

    final apiUrl = Uri.parse('$kApiUrl/users/$uid');

    try {
      final response =
          await http.get(apiUrl, headers: {'Authorization': token});
      final jsonResponseObject =
          (jsonDecode(response.body) as Map<String, dynamic>)['data'];

      return UserModel.fromJson(jsonResponseObject as Map<String, dynamic>);
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

  //Update user data
  Future<UserModel> updateUserData(UserModel newUser) async {
    final bearer = await FirebaseAuth.instance.currentUser!.getIdToken();
    //Forming string auth key for the api
    final token = 'Bearer $bearer';

    final apiUrl = Uri.parse('$kApiUrl/users/${newUser.id}');

    try {
      final response = await http.put(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
        body: jsonEncode(newUser.toJson()),
      );

      final jsonResponseObject =
          (jsonDecode(response.body) as Map<String?, dynamic>)['data'];

      return UserModel.fromJson(jsonResponseObject as Map<String, dynamic>);
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
