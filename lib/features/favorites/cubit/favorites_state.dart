part of 'favorites_cubit.dart';

enum FavoritesStatus {
  initial,
  loading,
  loaded,
  elementAdded,
  elementDeleted,
  error,
}

class FavoritesState extends Equatable {
  const FavoritesState({
    required this.favoritesStatus,
    required this.favoritesList,
    this.stopsData,
  });

  factory FavoritesState.initial() {
    return const FavoritesState(
      favoritesList: [],
      favoritesStatus: FavoritesStatus.initial,
    );
  }
  final FavoritesStatus favoritesStatus;
  final List<String> favoritesList;
  final List<StopModel>? stopsData;

  FavoritesState copyWith({
    FavoritesStatus? favoritesStatus,
    List<String>? favoritesList,
    List<StopModel>? stopsData,
  }) {
    return FavoritesState(
      favoritesStatus: favoritesStatus ?? this.favoritesStatus,
      favoritesList: favoritesList ?? this.favoritesList,
      stopsData: stopsData ?? this.stopsData,
    );
  }

  @override
  List<Object> get props {
    return [
      favoritesStatus,
      favoritesList,
      stopsData ?? [],
    ];
  }

  @override
  String toString() {
    return 'FavoritesState(favoritesStatus: $favoritesStatus, favoritesList: $favoritesList, stopsData: $stopsData,)';
  }
}
