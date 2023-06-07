// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String profileImage;
  final int createdAt;
  final int? updatedAt;
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
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        createdAt: json['createdAt'] as int,
        updatedAt: json['updatedAt'] == null
            ? DateTime.now().millisecondsSinceEpoch
            : json['updatedAt'] as int,
        name: json['name'] as String,
        lastLocation: json['lastLocation'] == null
            ? const LatLng(0, 0)
            : LatLng(
                ((json['lastLocation'] as List<dynamic>)[0] as int).toDouble(),
                ((json['lastLocation'] as List<dynamic>)[0] as int).toDouble(),
              ),
        favoriteStops: (json['favoriteStops'] as List<dynamic>)
            .map((item) => item.toString())
            .toList(),
        profileImage: json['profileImage'] as String,
        email: json['email'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt,
        'updatedAt': updatedAt ?? DateTime.now().millisecondsSinceEpoch,
        'name': name,
        'lastLocation': lastLocation ?? const LatLng(0, 0),
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

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImage,
    int? createdAt,
    int? updatedAt,
    LatLng? lastLocation,
    List<String>? favoriteStops,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLocation: lastLocation ?? this.lastLocation,
      favoriteStops: favoriteStops ?? this.favoriteStops,
    );
  }
}
