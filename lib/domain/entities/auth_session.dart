import 'package:equatable/equatable.dart';
import 'user.dart';

class AuthSession extends Equatable {
  final String token;
  final User user;
  final DateTime expiresAt;

  const AuthSession({
    required this.token,
    required this.user,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  @override
  List<Object?> get props => [token, user, expiresAt];
}
