import 'package:bot_main_app/dependency_injection/injector.dart';
import 'package:bot_main_app/features/navbar/bloc/navbar_cubit/navbar_cubit.dart';
import 'package:bot_main_app/features/profile/bloc/profile_cubit.dart';
import 'package:bot_main_app/models/custom_error.dart';
import 'package:bot_main_app/repository/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required this.authRepository}) : super(LoginState.initial());
  final AuthRepository authRepository;

  //Login with mail and pw
  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    //Emit state while its submitting for progress indicator or smth
    emit(state.copyWith(loginStatus: LoginStatus.submittingEmail));

    try {
      //Doing signin and emiting success state
      await authRepository.loginWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(state.copyWith(loginStatus: LoginStatus.success));
      if (authRepository.currentUser?.emailVerified ?? false) {
        if (getIt<ProfileCubit>().state.previusState ==
            ProfileStatus.loggedOut) {
          getIt<NavbarCubit>().changePage(0);
        }
        getIt<GoRouter>().go('/home');
      } else {
        getIt<GoRouter>().go('/emailVerification');
      }
    } on CustomError catch (e) {
      //on signin error emit error status with custom error
      emit(state.copyWith(loginStatus: LoginStatus.error, error: e));
    }
  }

  //Google login
  Future<void> loginWithGoogle() async {
    emit(state.copyWith(loginStatus: LoginStatus.submittingGoogle));
    try {
      await authRepository.signInWithGoogle();
      emit(
        state.copyWith(
          loginStatus: LoginStatus.success,
        ),
      );

      if (getIt<ProfileCubit>().state.previusState == ProfileStatus.loggedOut) {
        getIt<NavbarCubit>().changePage(0);
      }

      getIt<GoRouter>().go('/home');
    } catch (e) {
      throw Exception(e);
    }
  }
}
