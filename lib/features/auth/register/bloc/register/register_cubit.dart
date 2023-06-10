import 'dart:async';

import 'package:bot_main_app/dependency_injection/injector.dart';
import 'package:bot_main_app/models/custom_error.dart';
import 'package:bot_main_app/repository/auth_repository.dart';
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

    emit(state.copyWith(registerStatus: RegisterStatus.stagged));
  }

  //Register user and go to imagepicker
  Future<void> register() async {
    emit(state.copyWith(registerStatus: RegisterStatus.submitting));

    try {
      await authRepository.register(
        name: userStagedData['name'] as String,
        email: userStagedData['email'] as String,
        password: userStagedData['password'] as String,
      );
      emit(state.copyWith(registerStatus: RegisterStatus.success));
      //Send verification email
      await verifyUserEmail();
    } on CustomError catch (e) {
      emit(state.copyWith(registerStatus: RegisterStatus.error, error: e));
      throw Exception(e);
    }
  }

  //Send verify email
  Future<void> verifyUserEmail() async {
    final currentUser = getIt<AuthRepository>().currentUser;

    if (currentUser != null) {
      try {
        await currentUser.sendEmailVerification();
        emit(state.copyWith(registerStatus: RegisterStatus.verificationSent));
        //Navigate to verification screen
        getIt<GoRouter>().go('/emailVerification');

        await startCheckingUserVerified();
      } catch (e) {
        throw Exception(e);
      }
    }
  }

  //Setter to the state
  void setVerificationSentState() {
    emit(state.copyWith(registerStatus: RegisterStatus.verificationSent));
    startCheckingUserVerified();
  }

  Timer? _timer;
  //Check if user is verified
  Future<void> startCheckingUserVerified() async {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      final currentUser = getIt<AuthRepository>().currentUser;

      if (currentUser != null) {
        print('Checking isVerified!');
        await currentUser.reload();
        if (currentUser.emailVerified) {
          emit(state.copyWith(registerStatus: RegisterStatus.verified));
          stopCheckingUserVerified();
        }
        //If max ticks...
        if (_timer != null) {
          //Tick is the maximun ticks, preventing loop to firebase
          if (_timer!.tick > 60) {
            stopCheckingUserVerified();
            getIt<GoRouter>().go('/login');
          }
        }
      }
    });
  }

  void stopCheckingUserVerified() {
    _timer?.cancel();
    _timer = null;
  }
}
