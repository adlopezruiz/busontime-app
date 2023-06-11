import 'package:bot_main_app/repository/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.authRepository}) : super(AuthState.unknown()) {
    on<InitialCheckEvent>(
      (event, emit) => {
        if (event.currentUser != null)
          {add(AuthStateChangedEvent(user: event.currentUser))}
        else
          {add(const AuthStateChangedEvent())}
      },
    );

    on<AuthStateChangedEvent>((event, emit) {
      if (event.user != null) {
        emit(
          state.copyWith(
            authStatus: AuthStatus.authenticated,
            user: event.user,
          ),
        );
      } else {
        emit(
          state.copyWith(
            authStatus: AuthStatus.unauthenticated,
          ),
        );
      }
    });

    on<SignOutRequestedEvent>((event, emit) async {
      await authRepository.logout();
    });
  }

  final AuthRepository authRepository;
}
