part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthStateChangedEvent extends AuthEvent {
  const AuthStateChangedEvent({
    this.user,
  });
  final fb_auth.User? user;

  @override
  List<Object?> get props => [user];
}

class SignOutRequestedEvent extends AuthEvent {}

class InitialCheckEvent extends AuthEvent {
  const InitialCheckEvent({
    this.currentUser,
  });
  final fb_auth.User? currentUser;

  @override
  List<Object?> get props => [currentUser];
}
