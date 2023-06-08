import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolilyneRepository {
  PolilyneRepository();

  Future<List<LatLng>> getPolylineCoordinates({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final polylinePoints = PolylinePoints();
    final apiKey = dotenv.env['MAPSAPIKEY'] ?? '';
    final result = await polylinePoints.getRouteBetweenCoordinates(
      apiKey,
      PointLatLng(origin.latitude, origin.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );

    //Parsing to latln
    final polyLineCoordinates = <LatLng>[];

    for (final point in result.points) {
      polyLineCoordinates.add(LatLng(point.latitude, point.longitude));
    }

    return polyLineCoordinates;
  }
}
