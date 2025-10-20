import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthRequestCodeRequested extends AuthEvent {
  final String phoneNumber;

  const AuthRequestCodeRequested(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class AuthVerifyCodeRequested extends AuthEvent {
  final String phoneNumber;
  final String code;

  const AuthVerifyCodeRequested(this.phoneNumber, this.code);

  @override
  List<Object?> get props => [phoneNumber, code];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthSessionCheckRequested extends AuthEvent {
  const AuthSessionCheckRequested();
}
