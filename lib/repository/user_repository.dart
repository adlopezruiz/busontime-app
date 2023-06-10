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
    //Forming string auth key for the api
    final token = await _getBearer();
    final apiUrl = Uri.parse('$kApiUrl/users/$uid');

    try {
      final response =
          await http.get(apiUrl, headers: {'Authorization': token});

      final userMap = (jsonDecode(response.body)
          as Map<String, dynamic>)['data'] as Map<String, dynamic>;

      final user = UserModel.fromJson(userMap);

      return user;
    } on FirebaseException catch (e) {
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }

  //Update user data
  Future<UserModel> updateUserData({required UserModel newUser}) async {
    final token = await _getBearer();
    final apiUrl = Uri.parse('$kApiUrl/users/${newUser.id}');

    print(newUser);

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
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }

  //Delete user from
  Future<void> deleteUser({required String uid}) async {
    final token = await _getBearer();
    try {
      final apiUrl = Uri.parse('$kApiUrl/users/$uid');
      await http.delete(
        apiUrl,
        headers: {
          'Authorization': token,
        },
      );
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'User repository',
      );
    }
  }

  //Getting auth key
  Future<String> _getBearer() async {
    final bearer = await FirebaseAuth.instance.currentUser!.getIdToken();
    //Forming string auth key for the api
    print(bearer);
    return 'Bearer $bearer';
  }
}
