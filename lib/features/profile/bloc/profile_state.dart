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
    required this.customError,
  });

  factory ProfileState.initial() {
    return ProfileState(
      profileStatus: ProfileStatus.initial,
      user: UserModel.initialUser(),
      customError: const CustomError(),
    );
  }
  final ProfileStatus profileStatus;
  final UserModel user;
  final CustomError customError;

  @override
  String toString() =>
      'ProfileState(profileStatus: $profileStatus, user: $user, customError: $customError)';

  @override
  List<Object> get props => [profileStatus, user, customError];

  ProfileState copyWith({
    ProfileStatus? profileStatus,
    UserModel? user,
    CustomError? customError,
  }) {
    return ProfileState(
      profileStatus: profileStatus ?? this.profileStatus,
      user: user ?? this.user,
      customError: customError ?? this.customError,
    );
  }
}
