import 'package:bot_main_app/dependency_injection/injector.dart';
import 'package:bot_main_app/models/custom_error.dart';
import 'package:bot_main_app/repository/auth/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit({required this.authRepository})
      : super(RegisterState.initial());

  Map<String, dynamic> userStagedData = {};
  final AuthRepository authRepository;

  void stageUserData({
    required String name,
    required String email,
    required String password,
  }) {
    userStagedData['name'] = name;
    userStagedData['email'] = email;
    userStagedData['password'] = password;

    print('User data stagged -> $userStagedData');
  }

  Future<void> register() async {
    emit(state.copyWith(registerStatus: RegisterStatus.submitting));

    try {
      await authRepository.register(
        name: userStagedData['name'] as String,
        email: userStagedData['name'] as String,
        password: userStagedData['name'] as String,
      );

      emit(state.copyWith(registerStatus: RegisterStatus.success));
      getIt<GoRouter>().go('/home');
    } on CustomError catch (e) {
      emit(state.copyWith(registerStatus: RegisterStatus.error, error: e));
    }
  }
}
