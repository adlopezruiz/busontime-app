import 'package:bot_main_app/models/custom_error.dart';
import 'package:bot_main_app/repository/auth/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit({required this.authRepository})
      : super(RegisterState.initial());
  final AuthRepository authRepository;

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(registerStatus: RegisterStatus.submitting));

    try {
      await authRepository.register(
        name: name,
        email: email,
        password: password,
      );

      emit(state.copyWith(registerStatus: RegisterStatus.success));
    } on CustomError catch (e) {
      emit(state.copyWith(registerStatus: RegisterStatus.error, error: e));
    }
  }
}
