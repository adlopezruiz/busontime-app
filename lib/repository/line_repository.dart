import 'dart:convert';

import 'package:bot_main_app/dependency_injection/injector.dart';
import 'package:bot_main_app/models/custom_error.dart';
import 'package:bot_main_app/models/line_model.dart';
import 'package:bot_main_app/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class LineRepository {
  //Get line full data
  Future<LineModel> getLineData() async {
    //Forming string auth key for the api
    final token = await _getBearer();
    final apiUrl = Uri.parse('$kApiUrl/lines/$kLineId');

    try {
      final response =
          await http.get(apiUrl, headers: {'Authorization': token});
      final lineObject = LineModel.fromJson(
        (jsonDecode(response.body) as Map<String, dynamic>)['data']
            as Map<String, dynamic>,
      );

      return lineObject;
    } on FirebaseException catch (e) {
      throw CustomError(code: e.code, message: e.message!, plugin: e.plugin);
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'Get full line data method in repo',
      );
    }
  }

  //Get today line schedule by position, stopName and direction
  //Get line full data
  Future<List<dynamic>> getTodayScheduleByStop(
    String stopName,
    String direction,
  ) async {
    //Forming string auth key for the api
    final token = await _getBearer();
    //Declare query parameters
    final queryParameters = {
      'lineId': kLineId,
      'stopName': stopName,
      'direction': direction
    };
    final apiUrl =
        Uri.https(kHttpsApiUrl, '/api/v1/lines/todaySchedule', queryParameters);

    try {
      final response =
          await http.get(apiUrl, headers: {'Authorization': token});

      return (jsonDecode(response.body) as Map<String, dynamic>)['data']
          as List<dynamic>;
    } on FirebaseException catch (e) {
      throw CustomError(code: e.code, message: e.message!, plugin: e.plugin);
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'Get full line data method in repo',
      );
    }
  }

  //Get auth code for the api calls
  Future<String> _getBearer() async {
    final bearer = await getIt<FirebaseAuth>().currentUser!.getIdToken();
    //Forming string auth key for the api
    return 'Bearer $bearer';
  }
}
