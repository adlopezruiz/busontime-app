import 'package:bloc/bloc.dart';
import 'package:bot_main_app/dependency_injection/injector.dart';
import 'package:bot_main_app/models/user_model.dart';
import 'package:bot_main_app/repository/auth_repository.dart';
import 'package:bot_main_app/repository/user_repository.dart';
import 'package:equatable/equatable.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit() : super(FavoritesState.initial()) {
    _getUserFavorites();
  }

  //Add to favorites
  Future<void> addToFavorites(Map<String, dynamic> newStopData) async {
    final actualList = List<Map<String, dynamic>>.from(state.favoritesList)
      ..add(newStopData);
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
  Future<void> deleteFromFavorites(Map<String, dynamic> stopData) async {
    final actualList = List<Map<String, dynamic>>.from(state.favoritesList);

    //Search the stop in the actual list and remove it
    for (final element in actualList) {
      if (element['stopId'] == stopData['stopId']) {
        if (element['hour'] == stopData['hour']) {
          actualList.remove(element);
        }
      }
    }
    emit(
      state.copyWith(
        favoritesList: actualList,
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
  Future<void> _getUserFavorites() async {
    emit(state.copyWith(favoritesStatus: FavoritesStatus.loading));
    final userData = await getUser;
    if (userData == null) {
      emit(state.copyWith(favoritesStatus: FavoritesStatus.error));
    } else {
      emit(
        state.copyWith(
          favoritesList: userData.favoriteStops,
          favoritesStatus: FavoritesStatus.loaded,
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
