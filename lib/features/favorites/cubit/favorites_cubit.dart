import 'package:bloc/bloc.dart';
import 'package:bot_main_app/dependency_injection/injector.dart';
import 'package:bot_main_app/models/stop_model.dart';
import 'package:bot_main_app/models/user_model.dart';
import 'package:bot_main_app/repository/auth_repository.dart';
import 'package:bot_main_app/repository/stop_repository.dart';
import 'package:bot_main_app/repository/user_repository.dart';
import 'package:equatable/equatable.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit() : super(FavoritesState.initial()) {
    getUserFavoritesAndSchedules();
  }

  //Reload state
  void reloadState() {
    getUserFavoritesAndSchedules();
  }

  //Add to favorites
  Future<void> addToFavorites(String stopName) async {
    emit(state.copyWith(favoritesStatus: FavoritesStatus.loading));
    final stopToAddId = await _getStopId(stopName);
    final actualList = List<String>.from(state.favoritesList)..add(stopToAddId);
    emit(
      state.copyWith(
        favoritesList: actualList,
        favoritesStatus: FavoritesStatus.elementAdded,
      ),
    );
    //Update user data trigger
    await updateUserData();
  }

  //Remove from favorites
  Future<void> deleteFromFavorites(String databaseName) async {
    emit(state.copyWith(favoritesStatus: FavoritesStatus.loading));
    //Search the stop in the actual list and remove it
    final stopId = await _getStopId(databaseName);
    final updatedList = List<String>.from(state.favoritesList)..remove(stopId);

    emit(
      state.copyWith(
        favoritesList: updatedList,
        favoritesStatus: FavoritesStatus.elementDeleted,
      ),
    );
    //Update user data trigger
    await updateUserData();
  }

  //Update user function
  Future<void> updateUserData() async {
    final userData = await getUser;
    if (userData != null) {
      await getIt<UserRepository>().updateUserData(
        newUser: userData.copyWith(favoriteStops: state.favoritesList),
      );
    }
  }

  //Fetch user favorites
  Future<void> getUserFavoritesAndSchedules() async {
    emit(state.copyWith(favoritesStatus: FavoritesStatus.loading));
    final userData = await getUser;
    if (userData == null) {
      emit(state.copyWith(favoritesStatus: FavoritesStatus.error));
    } else {
      final stopsRepo = getIt<StopRepository>();
      final stopsData = <StopModel>[];

      for (final stop in userData.favoriteStops) {
        final stopData = await stopsRepo.getStopById(stop);
        stopsData.add(stopData);
      }

      emit(
        state.copyWith(
          favoritesList: userData.favoriteStops,
          favoritesStatus: FavoritesStatus.loaded,
          stopsData: stopsData,
        ),
      );
    }
  }

  //Just a function
  Future<UserModel>? get getUser async {
    final userUid = getIt<AuthRepository>().currentUser?.uid ?? '';
    final userData = await getIt<UserRepository>().getProfile(uid: userUid);
    return userData;
  }
}

//Get stop id by passing databasename
Future<String> _getStopId(String stopName) async {
  //Call to stops repository and return the stop id
  final stopsRepo = getIt<StopRepository>();

  final stopsList = await stopsRepo.getStops();

  //Return the first element ID that matches the passed stopName
  return stopsList.firstWhere((stop) => stop.databaseName == stopName).id;
}
