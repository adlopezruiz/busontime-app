// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String profileImage;
  final int createdAt;
  final LatLng? lastLocation;
  final List<String> favoriteStops;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.createdAt,
    required this.favoriteStops,
    this.lastLocation,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        createdAt: json['createdAt'] as int,
        name: json['name'] as String,
        lastLocation: json['lastLocation'] == null
            ? const LatLng(0, 0)
            : json['lastLocation'] as LatLng,
        favoriteStops: (json['favoriteStops'] as List<dynamic>)
            .map((item) => item.toString())
            .toList(),
        profileImage: json['profileImage'] as String,
        email: json['email'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt,
        'name': name,
        'lastLocation': lastLocation,
        'favoriteStops': List<dynamic>.from(favoriteStops.map((x) => x)),
        'profileImage': profileImage,
        'email': email,
      };

  factory UserModel.initialUser() {
    return UserModel(
      id: '',
      name: '',
      email: '',
      profileImage: '',
      createdAt: DateTime.now().millisecondsSinceEpoch,
      favoriteStops: const [],
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, profileImage: $profileImage, createdAt: $createdAt, favoriteStops: $favoriteStops, lastLocation: $lastLocation)';
  }

  @override
  List<Object> get props {
    return [
      id,
      name,
      email,
      profileImage,
      createdAt,
      favoriteStops,
      lastLocation ?? '',
    ];
  }
}
