part of 'profile_cubit.dart';

enum ProfileStatus {
  initial,
  loading,
  loaded,
  loggedOut,
  error,
}

class ProfileState extends Equatable {
  const ProfileState({
    required this.profileStatus,
    required this.user,
    required this.previusState,
  });

  factory ProfileState.initial() {
    return ProfileState(
      profileStatus: ProfileStatus.initial,
      user: UserModel.initialUser(),
      previusState: ProfileStatus.initial,
    );
  }
  final ProfileStatus profileStatus;
  final UserModel user;
  final ProfileStatus previusState;

  ProfileState copyWith({
    ProfileStatus? profileStatus,
    UserModel? user,
    ProfileStatus? previusState,
  }) {
    return ProfileState(
      profileStatus: profileStatus ?? this.profileStatus,
      user: user ?? this.user,
      previusState: previusState ?? this.previusState,
    );
  }

  @override
  String toString() =>
      'ProfileState(profileStatus: $profileStatus, user: $user, previusState: $previusState)';

  @override
  List<Object> get props => [profileStatus, user, previusState];
}
