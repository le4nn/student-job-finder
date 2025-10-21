import '../entities/auth_session.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<void> requestCode(String phoneNumber, String role);
  Future<AuthSession> verifyCode(String phoneNumber, String code);
  Future<AuthSession> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  });
  Future<void> logout();
  Future<AuthSession?> getCurrentSession();
  Future<void> saveSession(AuthSession session);
  Future<void> clearSession();
}
