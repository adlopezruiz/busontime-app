// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:bot_main_app/models/custom_error.dart';
import 'package:bot_main_app/models/direct_geocoding.dart';
import 'package:bot_main_app/models/weather.dart';
import 'package:bot_main_app/utils/constants.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

class WeatherRepository {
  Future<DirectGeocoding> getDirectGeocoding(String city) async {
    final uri = Uri(
      scheme: 'https',
      host: kApiHost,
      path: '/geo/1.0/direct',
      queryParameters: {
        'q': city,
        'limit': kLimit,
        'appid': dotenv.env['APPID'],
      },
    );
    try {
      final response = await get(uri);

      if (response.statusCode != 200) {
        throw Exception(response.body);
      }

      final responseBody = json.decode(response.body);

      if (responseBody == null) {
        throw Exception('Cannot get the location of $city');
      }

      final directGeocoding =
          DirectGeocoding.fromJson(responseBody as List<dynamic>);

      return directGeocoding;
    } catch (e) {
      rethrow;
    }
  }

  Future<Weather> getWeather(DirectGeocoding directGeocoding) async {
    final uri = Uri(
      scheme: 'https',
      host: kApiHost,
      path: '/data/2.5/weather',
      queryParameters: {
        'lat': '${directGeocoding.lat}',
        'lon': '${directGeocoding.lon}',
        'units': kUnit,
        'appid': dotenv.env['APPID'],
      },
    );

    try {
      final response = await get(uri);

      if (response.statusCode != 200) {
        throw Exception(response.body);
      }

      final weatherJson = json.decode(response.body);

      final weather = Weather.fromJson(weatherJson as Map<String, dynamic>);

      return weather;
    } catch (e) {
      rethrow;
    }
  }

  Future<Weather> fetchWeather(String city) async {
    try {
      final directGeocoding = await getDirectGeocoding(city);

      final tempWeather = await getWeather(directGeocoding);

      final weather = tempWeather.copyWith(
        name: directGeocoding.name,
        country: directGeocoding.country,
      );

      return weather;
    } catch (e) {
      throw CustomError(message: e.toString());
    }
  }
}
