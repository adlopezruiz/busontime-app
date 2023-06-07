part of 'map_bloc.dart';

enum MapStatus {
  initial,
  stopsLoaded,
  userPermissionDenied,
  userPermissionAccepted,
  userPositionLoaded,
  error,
}

class MapState extends Equatable {
  const MapState({
    required this.stops,
    required this.mapStatus,
    this.userPosition,
  });

  factory MapState.initial() {
    return const MapState(
      stops: [],
      mapStatus: MapStatus.initial,
    );
  }
  final List<StopModel> stops;
  final MapStatus mapStatus;
  final LatLng? userPosition;

  MapState copyWith({List<StopModel>? stops, MapStatus? mapStatus}) {
    return MapState(
      stops: stops ?? this.stops,
      mapStatus: mapStatus ?? this.mapStatus,
    );
  }

  @override
  List<Object> get props => [stops, mapStatus];

  @override
  String toString() =>
      'MapState(stops: $stops, mapStatus: $mapStatus, userPosition: $userPosition)';
}
