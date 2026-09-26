

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

// WHAT: The logic class that maps AuthEvents to AuthStates.
// HOW: It intercepts an event (e.g., LoginRequested), emits a Loading state, calls the Repository, and then emits either Authenticated or AuthError based on the result.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(AuthInitial()) {
    // Registering event handlers
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // Listen to the Firebase Auth stream to see if a user is currently logged in
      await emit.forEach(
        _authRepository.authStateChanges,
        onData: (user) {
          if (user != null) {
            return Authenticated(user);
          } else {
            return Unauthenticated();
          }
        },
        onError: (error, stackTrace) => AuthError(error.toString()),
      );
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signInWithEmail(
        event.email,
        event.password,
      );
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(const AuthError('Login failed. Please try again.'));
      }
    } catch (e) {
      // We strip the generic "Exception:" prefix if it exists to show cleaner UI messages
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.registerWithEmail(
        event.email,
        event.password,
      );
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(const AuthError('Registration failed. Please try again.'));
      }
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onGoogleSignInRequested(
    GoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signInWithGoogle();
      if (user != null) {
        emit(Authenticated(user));
      } else {
        // If user is null, they likely aborted the Google sign-in dialog
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.signOut();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError('Failed to logout.'));
    }
  }
}
