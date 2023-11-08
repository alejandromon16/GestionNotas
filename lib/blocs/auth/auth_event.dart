part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class AuthCheckRequested extends AuthEvent {
  @override
  List<Object> get props => [];
}

class AuthSignInWithEmailPassword extends AuthEvent {
  final String email;
  final String password;


  const AuthSignInWithEmailPassword({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class AuthSignOut extends AuthEvent {
  @override
  List<Object> get props => [];
}
