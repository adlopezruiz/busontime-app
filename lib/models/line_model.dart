// To parse this JSON data, do
//
//     final lineModel = lineModelFromJson(jsonString);

import 'dart:convert';

LineModel lineModelFromJson(String str) => LineModel.fromJson(
      (json.decode(str) as Map<String, dynamic>)['data']
          as Map<String, dynamic>,
    );

String lineModelToJson(LineModel data) => json.encode(data.toJson());

class LineModel {
  LineModel({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.schedule,
  });

  factory LineModel.fromJson(Map<String, dynamic> json) => LineModel(
        id: json['id'] as String,
        createdAt: json['createdAt'] as int,
        name: json['name'] as String,
        schedule: json['schedule'] as Map<String, dynamic>,
      );
  final String id;
  final int createdAt;
  final String name;
  final Map<String, dynamic> schedule;

  LineModel copyWith({
    String? id,
    int? createdAt,
    String? name,
    Map<String, dynamic>? schedule,
  }) =>
      LineModel(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        name: name ?? this.name,
        schedule: schedule ?? this.schedule,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt,
        'name': name,
        'schedule': schedule,
      };
}
