part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class BusStopsLoadRequest extends MapEvent {}

class UpdateUserLocationRequest extends MapEvent {}

class LocationPermissionRequest extends MapEvent {}

class LocationPermissionDenied extends MapEvent {}
