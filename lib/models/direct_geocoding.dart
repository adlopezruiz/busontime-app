// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class DirectGeocoding extends Equatable {
  final String name;
  final double lat;
  final double lon;
  final String country;

  const DirectGeocoding({
    required this.name,
    required this.lat,
    required this.lon,
    required this.country,
  });

  factory DirectGeocoding.fromJson(List<dynamic> json) {
    final data = json[0] as Map<String, dynamic>;

    return DirectGeocoding(
      name: data['name'] as String,
      lat: data['lat'] as double,
      lon: data['lon'] as double,
      country: data['country'] as String,
    );
  }

  @override
  List<Object> get props => [name, lat, lon, country];

  @override
  bool get stringify => true;
}
