import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthBloc() : super(AuthInitial()) {
    on<AuthCheckRequested>(onAuthCheckRequested);
    on<AuthSignInWithEmailPassword>(onSignInWithEmailPassword);
    on<AuthSignOut>(onSignOut);
  }

  void onAuthCheckRequested(AuthCheckRequested event, Emitter<AuthState> emit) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  void onSignInWithEmailPassword(
    AuthSignInWithEmailPassword event, Emitter<AuthState> emit) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      if (result.user != null) {
        emit(AuthAuthenticated(user: result.user!));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  void onSignOut(
    AuthSignOut event, Emitter<AuthState> emit
  ) async {
    try {
      await _auth.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

}
