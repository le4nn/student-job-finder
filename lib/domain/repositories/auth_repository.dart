import '../entities/auth_session.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<AuthSession> registerPassword({
    String? email,
    String? phone,
    required String password,
    required String role,
  });
  Future<AuthSession> loginPassword({
    required String identifier,
    required String password,
  });

  Future<void> requestPhoneCode(String phoneNumber, String role);
  Future<AuthSession> verifyPhoneCode(String phoneNumber, String code);

  Future<void> requestEmailCode(String email);
  Future<AuthSession> verifyEmailCode(String email, String code);
  
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
