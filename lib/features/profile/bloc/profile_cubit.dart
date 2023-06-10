import 'package:bot_main_app/dependency_injection/injector.dart';
import 'package:bot_main_app/models/user_model.dart';
import 'package:bot_main_app/repository/auth_repository.dart';
import 'package:bot_main_app/repository/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required this.profileRepository})
      : super(ProfileState.initial());
  final UserRepository profileRepository;

  //Get user profile and load to state
  Future<void> getProfile() async {
    final uid = getIt<AuthRepository>().currentUser!.uid;
    emit(
      state.copyWith(
        profileStatus: ProfileStatus.loading,
        previusState: state.profileStatus,
      ),
    );

    try {
      final user = await profileRepository.getProfile(uid: uid);
      emit(
        state.copyWith(
          profileStatus: ProfileStatus.loaded,
          user: user,
          previusState: state.profileStatus,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          profileStatus: ProfileStatus.error,
          previusState: state.profileStatus,
        ),
      );
      throw Exception(e);
    }
  }

  //Set login out state
  void logOut() {
    emit(state.copyWith(previusState: ProfileStatus.loggedOut));
  }
}
