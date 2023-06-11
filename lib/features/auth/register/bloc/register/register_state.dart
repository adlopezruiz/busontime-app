part of 'register_cubit.dart';

enum RegisterStatus {
  initial,
  stagged,
  submitting,
  success,
  verificationSent,
  verified,
  error,
}

class RegisterState extends Equatable {
  const RegisterState({
    required this.registerStatus,
    required this.error,
  });

  factory RegisterState.initial() {
    return const RegisterState(
      registerStatus: RegisterStatus.initial,
      error: CustomError(),
    );
  }
  final RegisterStatus registerStatus;
  final CustomError error;

  RegisterState copyWith({
    RegisterStatus? registerStatus,
    CustomError? error,
  }) {
    return RegisterState(
      registerStatus: registerStatus ?? this.registerStatus,
      error: error ?? this.error,
    );
  }

  @override
  String toString() =>
      'RegisterState(registerStatus: $registerStatus, error: $error)';

  @override
  List<Object> get props => [registerStatus, error];
}
