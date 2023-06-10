import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bot_main_app/dependency_injection/injector.dart';
import 'package:bot_main_app/models/stop_model.dart';
import 'package:bot_main_app/models/user_model.dart';
import 'package:bot_main_app/repository/auth_repository.dart';
import 'package:bot_main_app/repository/stop_repository.dart';
import 'package:bot_main_app/repository/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:go_router/go_router.dart';

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
  Future<void> addToFavorites(String stopId) async {
    emit(state.copyWith(favoritesStatus: FavoritesStatus.loading));

    final actualList = List<String>.from(state.favoritesList)..add(stopId);
    emit(
      state.copyWith(
        favoritesList: actualList,
        favoritesStatus: FavoritesStatus.elementAdded,
      ),
    );
  }

  //Remove from favorites
  Future<void> deleteFromFavorites(String stopId) async {
    //Search the stop in the actual list and remove it
    final updatedStringList = List<String>.from(state.favoritesList)
      ..remove(stopId);
    //Also delete from stopData
    final foundStop =
        state.stopsData!.firstWhere((element) => element.id == stopId);

    final updatedStopDataList = List<StopModel>.from(state.stopsData!)
      ..remove(foundStop);

    emit(
      state.copyWith(
        favoritesList: updatedStringList,
        favoritesStatus: FavoritesStatus.elementDeleted,
        stopsData: updatedStopDataList,
      ),
    );
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
