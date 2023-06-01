// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String profileImage;
  final int point;
  final String rank;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.point,
    required this.rank,
  });

  factory UserModel.fromDoc(DocumentSnapshot userDoc) {
    final userData = userDoc.data() as Map<String, dynamic>?;

    return UserModel(
      id: userDoc.id,
      name: userData!['name'] as String,
      email: userData['email'] as String,
      profileImage: userData['profileImage'] as String,
      point: userData['point'] as int,
      rank: userData['rank'] as String,
    );
  }

  factory UserModel.initialUser() {
    return const UserModel(
      id: '',
      name: '',
      email: '',
      profileImage: '',
      point: -1,
      rank: '',
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, profileImage: $profileImage, point: $point, rank: $rank,)';
  }

  @override
  List<Object> get props {
    return [
      id,
      name,
      email,
      profileImage,
      point,
      rank,
    ];
  }
}
