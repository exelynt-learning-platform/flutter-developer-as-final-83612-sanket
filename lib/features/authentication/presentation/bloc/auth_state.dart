import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

// WHAT: Defines all the possible states the UI can be in during authentication.
// WHY: The UI will listen to these states to show loaders, error snackbars, or navigate to the dashboard.
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final User user;

  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
