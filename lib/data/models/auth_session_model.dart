import '../../domain/entities/auth_session.dart';
import 'user_model.dart';

class AuthSessionModel extends AuthSession {
  const AuthSessionModel({
    required super.token,
    required super.user,
    required super.expiresAt,
  });

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    return AuthSessionModel(
      token: json['token'] ?? '',
      user: UserModel.fromJson(json['user'] ?? json),
      expiresAt: json['expiresAt'] != null 
          ? DateTime.parse(json['expiresAt'])
          : DateTime.now().add(const Duration(days: 30)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user': (user as UserModel).toJson(),
      'expiresAt': expiresAt.toIso8601String(),
    };
  }

  AuthSession toEntity() {
    return AuthSession(
      token: token,
      user: user,
      expiresAt: expiresAt,
    );
  }
}
