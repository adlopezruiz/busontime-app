import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppColors {
  static const primaryGreen = Color.fromRGBO(66, 155, 103, 1);
  static const primaryGrey = Color.fromRGBO(141, 149, 171, 1);
  static const secondaryGrey = Color.fromRGBO(212, 216, 219, 1);
  static const primaryBlack = Color.fromRGBO(0, 0, 0, 1);
}

//Firebase constants
final userRef = FirebaseFirestore.instance.collection('users');
const kGoogleMapsApi = 'AIzaSyCQY900CUko2JTQV2idWz2SeUZuTSaCeyo';
const storageBucket = 'gs://fb-auth-bloc-d1201.appspot.com';

//My API constants
const kApiUrl = 'http://10.0.2.2:3000/api/v1';
