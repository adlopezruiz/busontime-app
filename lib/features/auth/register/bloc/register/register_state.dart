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
  });

  factory RegisterState.initial() {
    return const RegisterState(
      registerStatus: RegisterStatus.initial,
    );
  }
  final RegisterStatus registerStatus;

  @override
  String toString() => 'RegisterState(registerStatus: $registerStatus)';

  @override
  List<Object> get props => [registerStatus];

  RegisterState copyWith({
    RegisterStatus? registerStatus,
  }) {
    return RegisterState(
      registerStatus: registerStatus ?? this.registerStatus,
    );
  }
}
