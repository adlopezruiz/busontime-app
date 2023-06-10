part of 'map_bloc.dart';

enum MapStatus {
  initial,
  stopsLoaded,
  userPermissionDenied,
  userPermissionAccepted,
  userPositionLoaded,
  loadingSchedule,
  stopsSchedulesLoaded,
  routesLoaded,
  error,
}

class MapState extends Equatable {
  const MapState({
    required this.stops,
    required this.mapStatus,
    this.userPosition,
    this.toJaenSchedule,
    this.toMartosSchedule,
    this.busRoute,
    this.customIcon,
    this.customUserMarker,
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
  final Set<Polyline>? busRoute;
  final BitmapDescriptor? customIcon;
  final BitmapDescriptor? customUserMarker;

  MapState copyWith({
    List<StopModel>? stops,
    MapStatus? mapStatus,
    LatLng? userPosition,
    List<dynamic>? toJaenSchedule,
    List<dynamic>? toMartosSchedule,
    Set<Polyline>? busRoute,
    BitmapDescriptor? customIcon,
    BitmapDescriptor? customUserMarker,
  }) {
    return MapState(
      stops: stops ?? this.stops,
      mapStatus: mapStatus ?? this.mapStatus,
      userPosition: userPosition,
      toJaenSchedule: toJaenSchedule,
      toMartosSchedule: toMartosSchedule,
      busRoute: busRoute,
      customIcon: customIcon,
      customUserMarker: customUserMarker,
    );
  }

  @override
  List<Object> get props => [
        stops,
        mapStatus,
        userPosition ?? const LatLng(0, 0),
        toJaenSchedule ?? [],
        toMartosSchedule ?? [],
        busRoute ?? {},
        customIcon ?? BitmapDescriptor.defaultMarker,
        customUserMarker ?? BitmapDescriptor.defaultMarker,
      ];

  @override
  String toString() {
    final stopsList = <String>[];
    for (final stop in stops) {
      stopsList.add(stop.databaseName);
    }
    return 'MapState(stops: $stopsList, mapStatus: $mapStatus, userPosition: $userPosition, toJaenSchedule: $toJaenSchedule, toMartosSchedule: $toMartosSchedule)';
  }
}
