import 'package:bot_main_app/models/custom_error.dart';
import 'package:bot_main_app/repository/auth/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required this.authRepository}) : super(LoginState.initial());
  final AuthRepository authRepository;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    //Emit state while its submitting for progress indicator or smth
    emit(state.copyWith(loginStatus: LoginStatus.submitting));

    try {
      //Doing signin and emiting success state
      await authRepository.login(email: email, password: password);
      emit(state.copyWith(loginStatus: LoginStatus.success));
    } on CustomError catch (e) {
      //on signin error emit error status with custom error
      emit(state.copyWith(loginStatus: LoginStatus.error, error: e));
    }
  }
}
