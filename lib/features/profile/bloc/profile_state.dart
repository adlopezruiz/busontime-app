part of 'profile_cubit.dart';

enum ProfileStatus {
  initial,
  loading,
  loaded,
  error,
}

class ProfileState extends Equatable {
  const ProfileState({
    required this.profileStatus,
    required this.user,
  });

  factory ProfileState.initial() {
    return ProfileState(
      profileStatus: ProfileStatus.initial,
      user: UserModel.initialUser(),
    );
  }
  final ProfileStatus profileStatus;
  final UserModel user;

  @override
  String toString() =>
      'ProfileState(profileStatus: $profileStatus, user: $user)';

  @override
  List<Object> get props => [profileStatus, user];

  ProfileState copyWith({
    ProfileStatus? profileStatus,
    UserModel? user,
  }) {
    return ProfileState(
      profileStatus: profileStatus ?? this.profileStatus,
      user: user ?? this.user,
    );
  }
}
