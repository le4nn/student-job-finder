import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthSendOtpRequested extends AuthEvent {
  final String phoneNumber;

  const AuthSendOtpRequested(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class AuthVerifyOtpRequested extends AuthEvent {
  final String phoneNumber;
  final String code;

  const AuthVerifyOtpRequested(this.phoneNumber, this.code);

  @override
  List<Object?> get props => [phoneNumber, code];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthSessionCheckRequested extends AuthEvent {
  const AuthSessionCheckRequested();
}
