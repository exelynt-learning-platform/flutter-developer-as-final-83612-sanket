import 'package:equatable/equatable.dart';

// WHAT: A base class for all errors in the app.
// WHY: So our repositories can return a standard "Failure" object to the UI instead of throwing raw Exceptions.
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}