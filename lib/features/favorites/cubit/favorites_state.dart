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
  });

  factory FavoritesState.initial() {
    return const FavoritesState(
      favoritesList: [],
      favoritesStatus: FavoritesStatus.initial,
    );
  }
  final FavoritesStatus favoritesStatus;
  final List<String> favoritesList;

  FavoritesState copyWith({
    FavoritesStatus? favoritesStatus,
    List<String>? favoritesList,
  }) {
    return FavoritesState(
      favoritesStatus: favoritesStatus ?? this.favoritesStatus,
      favoritesList: favoritesList ?? this.favoritesList,
    );
  }

  @override
  String toString() =>
      'FavoritesState(favoritesStatus: $favoritesStatus, favoritesList: $favoritesList)';

  @override
  List<Object> get props => [favoritesStatus, favoritesList];
}
