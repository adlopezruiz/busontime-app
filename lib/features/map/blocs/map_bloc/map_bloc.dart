import 'package:bloc/bloc.dart';
import 'package:bot_main_app/dependency_injection/injector.dart';
import 'package:bot_main_app/models/stop_model.dart';
import 'package:bot_main_app/repository/auth_repository.dart';
import 'package:bot_main_app/repository/line_repository.dart';
import 'package:bot_main_app/repository/stop_repository.dart';
import 'package:bot_main_app/repository/user_repository.dart';
import 'package:equatable/equatable.dart';
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

      emit(state.copyWith(stops: stopsList, mapStatus: MapStatus.stopsLoaded));
    });

    //Request the user permission
    on<LocationPermissionRequest>(
      (event, emit) async {
        final permissionStatus = await Permission.location.request();
        //User app permissions
        if (permissionStatus.isGranted) {
          //Emit state and trigger user location get
          emit(state.copyWith(mapStatus: MapStatus.userPermissionAccepted));
          add(UpdateUserLocationRequest());
          add(BusStopsLoadRequest());
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
          //Filtering the lists to the actual device hour

          //Pushing to state data
          emit(
            state.copyWith(
              mapStatus: MapStatus.stopsSchedulesLoaded,
              toMartosSchedule: filterScheduleByActualHour(toMartosSchedule),
              toJaenSchedule: filterScheduleByActualHour(toJaenSchedule),
              userPosition: state.userPosition,
            ),
          );
        }
      },
    );
  }
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
