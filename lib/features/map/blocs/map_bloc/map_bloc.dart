import 'dart:ui' as ui;

import 'package:bot_main_app/dependency_injection/injector.dart';
import 'package:bot_main_app/models/stop_model.dart';
import 'package:bot_main_app/repository/auth_repository.dart';
import 'package:bot_main_app/repository/line_repository.dart';
import 'package:bot_main_app/repository/polyline_repository.dart';
import 'package:bot_main_app/repository/stop_repository.dart';
import 'package:bot_main_app/repository/user_repository.dart';
import 'package:bot_main_app/utils/constants.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapState.initial()) {
    //Load stops on state event
    on<BusStopsLoadRequest>((event, emit) async {
      final stopsList = await getIt<StopRepository>().getStops();

      if (stopsList.isEmpty) {
        emit(state.copyWith(mapStatus: MapStatus.error));
      }

      emit(
        state.copyWith(
          stops: stopsList,
          mapStatus: MapStatus.stopsLoaded,
          userPosition: state.userPosition,
        ),
      );
      //Now we load the bus route
      add(BusRouteRequest());
    });

    //Request the user permission
    on<LocationPermissionRequest>(
      (event, emit) async {
        final permissionStatus = await Permission.location.request();
        //User app permissions
        if (permissionStatus.isGranted) {
          //Emit state and trigger user location get
          emit(state.copyWith(mapStatus: MapStatus.userPermissionAccepted));
          //Setup now all the map things!
          add(UpdateUserLocationRequest());
        } else if (permissionStatus.isDenied) {
          emit(state.copyWith(mapStatus: MapStatus.userPermissionDenied));
          add(LocationPermissionDenied());
        } else {
          emit(state.copyWith(mapStatus: MapStatus.userPermissionDenied));
          add(LocationPermissionDenied());
        }
      },
    );

    //Get user location if permissions are granted
    on<UpdateUserLocationRequest>(
      (event, emit) async {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        final userLocation = LatLng(position.latitude, position.longitude);

        final userRepo = getIt<UserRepository>();
        //Getting logged user
        final loggedUser = await userRepo.getProfile(
          uid: getIt<AuthRepository>().currentUser!.uid,
        );
        //Updating user
        await userRepo.updateUserData(
          newUser: loggedUser.copyWith(
            lastLocation: userLocation,
          ),
        );

        emit(
          state.copyWith(
            mapStatus: MapStatus.userPositionLoaded,
            userPosition: userLocation,
          ),
        );
        add(BusStopsLoadRequest());
      },
    );

    on<LocationPermissionDenied>(
      (event, emit) {
        emit(
          state.copyWith(
            mapStatus: MapStatus.userPermissionDenied,
          ),
        );
      },
    );

    //Load schedules to bottom dialog screen data
    on<StopSchedulesRequest>(
      (event, emit) async {
        emit(
          state.copyWith(
            mapStatus: MapStatus.loadingSchedule,
            userPosition: state.userPosition,
            busRoute: state.busRoute,
            customIcon: state.customIcon,
            customUserMarker: state.customUserMarker,
          ),
        );
        final lineRepo = getIt<LineRepository>();
        final toMartosSchedule =
            await lineRepo.getTodayScheduleByStop(event.stopName, 'martos');
        final toJaenSchedule =
            await lineRepo.getTodayScheduleByStop(event.stopName, 'jaen');
        if (toMartosSchedule.isEmpty || toJaenSchedule.isEmpty) {
          emit(
            state.copyWith(
              mapStatus: MapStatus.error,
            ),
          );
        } else {
          //Pushing to state data
          emit(
            state.copyWith(
              mapStatus: MapStatus.stopsSchedulesLoaded,
              toMartosSchedule: filterScheduleByActualHour(toMartosSchedule),
              toJaenSchedule: filterScheduleByActualHour(toJaenSchedule),
              userPosition: state.userPosition,
              busRoute: state.busRoute,
              customIcon: state.customIcon,
              customUserMarker: state.customUserMarker,
            ),
          );
        }
      },
    );

    //Put in state the set of polylines routes to draw the bus route
    on<BusRouteRequest>(
      (event, emit) async {
        //Get all the latlng arrays between the bus stops
        //From martos to torredonjimeno
        final fromMartosToToxiria =
            await getIt<PolilyneRepository>().getPolylineCoordinates(
          origin: state.stops[1].location,
          destination: state.stops[3].location,
        );
        //From torredonjimeno to torredelcampo
        final fromToxiriaToTorrecampo =
            await getIt<PolilyneRepository>().getPolylineCoordinates(
          origin: state.stops[3].location,
          destination: state.stops[2].location,
        );
        //From torrecampo to jaen
        final fromTorrecampoToJaen =
            await getIt<PolilyneRepository>().getPolylineCoordinates(
          origin: state.stops[2].location,
          destination: state.stops[0].location,
        );

        //Generating polylines objects now
        final polylines = <Polyline>{};

        final martosPolyline = Polyline(
          polylineId: const PolylineId('martos'),
          points: fromMartosToToxiria,
          color: AppColors.primaryGreen,
        );
        polylines.add(martosPolyline);
        final toxiriaTorrecampoPolyline = Polyline(
          polylineId: const PolylineId('toxiria'),
          points: fromToxiriaToTorrecampo,
          color: AppColors.primaryGreen,
        );
        polylines.add(toxiriaTorrecampoPolyline);
        final jaenPolilyne = Polyline(
          polylineId: const PolylineId('jaen'),
          points: fromTorrecampoToJaen,
          color: AppColors.primaryGreen,
        );
        polylines.add(jaenPolilyne);

        //Emit final state with route
        emit(
          state.copyWith(
            mapStatus: MapStatus.routesLoaded,
            toMartosSchedule: state.toMartosSchedule,
            toJaenSchedule: state.toJaenSchedule,
            userPosition: state.userPosition,
            busRoute: polylines,
            customIcon: await getBitmapDescriptorFromAssetBytes(
              'assets/images/bus_stop_200.png',
              150,
            ),
            customUserMarker: await getBitmapDescriptorFromAssetBytes(
              'assets/images/user-marker.png',
              150,
            ),
          ),
        );
      },
    );
  }

//Filtering function by hour
  List<dynamic> filterScheduleByActualHour(List<dynamic> schedule) {
    final now = DateTime.now();
    final currentHour = now.hour;
    final currentMinute = now.minute;
    final filteredSchedule = schedule.where((hour) {
      final hourValue = int.tryParse(hour.split(':')[0].toString());
      final minuteValue = int.tryParse(hour.split(':')[1].toString());
      if (hourValue != null && minuteValue != null) {
        if (hourValue > currentHour) {
          return true;
        } else if (hourValue == currentHour && minuteValue >= currentMinute) {
          return true;
        }
      }
      return false;
    }).toList();
    return filteredSchedule;
  }
}

//Image methods to transform from URSL and Assets to bytes for markers
Future<Uint8List> getBytesFromAsset(String path, int width) async {
  final data = await rootBundle.load(path);
  final codec = await ui.instantiateImageCodec(
    data.buffer.asUint8List(),
    targetWidth: width,
  );
  final fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer
      .asUint8List();
}

//From asset
Future<BitmapDescriptor> getBitmapDescriptorFromAssetBytes(
  String path,
  int width,
) async {
  final imageData = await getBytesFromAsset(path, width);
  return BitmapDescriptor.fromBytes(imageData);
}
