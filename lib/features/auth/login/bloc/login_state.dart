// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'login_cubit.dart';

enum LoginStatus {
  initial,
  submittingEmail,
  submittingGoogle,
  submittingApple,
  success,
  error,
}

class LoginState extends Equatable {
  final LoginStatus loginStatus;

  const LoginState({
    required this.loginStatus,
  });

  factory LoginState.initial() {
    return const LoginState(
      loginStatus: LoginStatus.initial,
    );
  }

  @override
  String toString() => 'LoginState(loginStatus: $loginStatus)';

  @override
  List<Object> get props => [loginStatus];

  LoginState copyWith({
    LoginStatus? loginStatus,
  }) {
    return LoginState(
      loginStatus: loginStatus ?? this.loginStatus,
    );
  }
}
