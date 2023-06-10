import 'dart:convert';
import 'package:bot_main_app/dependency_injection/injector.dart';
import 'package:bot_main_app/models/stop_model.dart';
import 'package:bot_main_app/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class StopRepository {
  //Get all stops data
  Future<List<StopModel>> getStops() async {
    //Forming string auth key for the api
    final token = await _getBearer();
    final apiUrl = Uri.parse('$kApiUrl/stops');

    try {
      final response =
          await http.get(apiUrl, headers: {'Authorization': token});

      final stopsMap = jsonDecode(response.body) as Map<String, dynamic>;
      final data = stopsMap['data'] as List;

      final stopsList = data
          .map((e) => StopModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return stopsList;
    } on FirebaseException catch (e) {
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }

  //Get auth code for the api calls
  Future<String> _getBearer() async {
    final bearer = await getIt<FirebaseAuth>().currentUser!.getIdToken();
    //Forming string auth key for the api
    return 'Bearer $bearer';
  }
}
