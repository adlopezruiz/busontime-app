import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppColors {
  static const primaryGreen = Color.fromRGBO(66, 155, 103, 1);
  static const primaryGrey = Color.fromRGBO(141, 149, 171, 1);
  static const secondaryGrey = Color.fromRGBO(212, 216, 219, 1);
  static const primaryBlack = Color.fromRGBO(0, 0, 0, 1);
}

//Firebase constants
final userRef = FirebaseFirestore.instance.collection('users');
final kGoogleMapsApi = dotenv.env['MAPSAPIKEY'];
final storageBucket = dotenv.env['STORAGEBUCKET'];

//My API constants
const kApiUrl = 'https://busontime-api.vercel.app/api/v1';

//Weather api
const String kApiHost = 'api.openweathermap.org';
const String kIconHost = 'www.openweathermap.org';
const String kUnit = 'metric';
const kLimit = '1';
const int kWarmOrNot = 20;
