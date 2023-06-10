import 'package:bot_main_app/dependency_injection/injector.dart';
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
        getIt<GoRouter>().go('/home');
      } else {
        getIt<GoRouter>().go('/emailVerification');
      }
    } catch (e) {
      //on signin error emit error status with custom error
      emit(state.copyWith(loginStatus: LoginStatus.error));
      throw Exception(e);
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

      getIt<GoRouter>().go('/home');
    } catch (e) {
      throw Exception(e);
    }
  }
}
