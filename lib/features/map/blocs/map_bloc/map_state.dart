part of 'map_bloc.dart';

enum MapStatus {
  initial,
  stopsLoaded,
  userPermissionDenied,
  userPermissionAccepted,
  userPositionLoaded,
  stopsSchedulesLoaded,
  error,
}

class MapState extends Equatable {
  const MapState({
    required this.stops,
    required this.mapStatus,
    this.userPosition,
    this.toJaenSchedule,
    this.toMartosSchedule,
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
  final List<dynamic>? toJaenSchedule;
  final List<dynamic>? toMartosSchedule;

  MapState copyWith({
    List<StopModel>? stops,
    MapStatus? mapStatus,
    LatLng? userPosition,
    List<dynamic>? toJaenSchedule,
    List<dynamic>? toMartosSchedule,
  }) {
    return MapState(
      stops: stops ?? this.stops,
      mapStatus: mapStatus ?? this.mapStatus,
      userPosition: userPosition,
      toJaenSchedule: toJaenSchedule,
      toMartosSchedule: toMartosSchedule,
    );
  }

  @override
  List<Object> get props => [
        stops,
        mapStatus,
        userPosition ?? const LatLng(0, 0),
        toJaenSchedule ?? [],
        toMartosSchedule ?? []
      ];

  @override
  String toString() {
    return 'MapState(stops: $stops, mapStatus: $mapStatus, userPosition: $userPosition, toJaenSchedule: $toJaenSchedule, toMartosSchedule: $toMartosSchedule)';
  }
}
