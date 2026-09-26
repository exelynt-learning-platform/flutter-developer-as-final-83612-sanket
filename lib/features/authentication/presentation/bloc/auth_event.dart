

import 'package:equatable/equatable.dart';

// WHAT: Defines all the actions a user can take regarding authentication.
// WHY: We use Equatable so BLoC can compare events efficiently.
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

// Triggered when the app opens to check if the user is already logged in
class AuthCheckRequested extends AuthEvent {}

// Triggered when the user submits the login form
class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

// Triggered when the user submits the registration form
class RegisterRequested extends AuthEvent {
  final String email;
  final String password;

  const RegisterRequested(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

// Triggered when the user clicks the Google Sign-In button
class GoogleSignInRequested extends AuthEvent {}

// Triggered when the user clicks Logout in the dashboard
class LogoutRequested extends AuthEvent {}
