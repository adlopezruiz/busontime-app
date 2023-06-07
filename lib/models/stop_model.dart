// To parse this JSON data, do
//
//     final stopModel = stopModelFromJson(jsonString);

import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';

StopModel stopModelFromJson(String str) =>
    StopModel.fromJson(json.decode(str) as Map<String, dynamic>);

String stopModelToJson(StopModel data) => json.encode(data.toJson());

class StopModel {
  StopModel({
    required this.id,
    required this.street,
    required this.name,
    required this.location,
    required this.line,
  });

  factory StopModel.fromJson(Map<String, dynamic> json) => StopModel(
        id: json['id'] as String,
        street: json['street'] as String,
        name: json['name'] as String,
        location: LatLng(
          (json['location'] as Map<String, dynamic>)['_latitude'] as double,
          (json['location'] as Map<String, dynamic>)['_longitude'] as double,
        ),
        line: json['line'] as String,
      );
  final String id;
  final String street;
  final String name;
  final LatLng location;
  final String line;

  StopModel copyWith({
    String? id,
    String? street,
    String? name,
    LatLng? location,
    String? line,
  }) =>
      StopModel(
        id: id ?? this.id,
        street: street ?? this.street,
        name: name ?? this.name,
        location: location ?? this.location,
        line: line ?? this.line,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'street': street,
        'name': name,
        'location': location.toJson(),
        'line': line,
      };
}
