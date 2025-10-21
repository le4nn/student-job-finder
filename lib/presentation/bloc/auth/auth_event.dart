import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthRequestCodeRequested extends AuthEvent {
  final String phoneNumber;
  final String role;

  const AuthRequestCodeRequested(this.phoneNumber, this.role);

  @override
  List<Object?> get props => [phoneNumber, role];
}

class AuthVerifyCodeRequested extends AuthEvent {
  final String phoneNumber;
  final String code;

  const AuthVerifyCodeRequested(this.phoneNumber, this.code);

  @override
  List<Object> get props => [phoneNumber, code];
}

class AuthRegisterPasswordRequested extends AuthEvent {
  final String? email;
  final String? phone;
  final String password;
  final String role;

  const AuthRegisterPasswordRequested({
    this.email,
    this.phone,
    required this.password,
    required this.role,
  });

  @override
  List<Object?> get props => [email, phone, password, role];
}

class AuthLoginPasswordRequested extends AuthEvent {
  final String identifier;
  final String password;

  const AuthLoginPasswordRequested({
    required this.identifier,
    required this.password,
  });

  @override
  List<Object> get props => [identifier, password];
}

class AuthRequestEmailCodeRequested extends AuthEvent {
  final String email;

  const AuthRequestEmailCodeRequested(this.email);

  @override
  List<Object> get props => [email];
}

class AuthVerifyEmailCodeRequested extends AuthEvent {
  final String email;
  final String code;

  const AuthVerifyEmailCodeRequested(this.email, this.code);

  @override
  List<Object> get props => [email, code];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthSessionCheckRequested extends AuthEvent {
  const AuthSessionCheckRequested();
}
