import 'package:injectable/injectable.dart';
import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

@injectable
class VerifyCodeUseCase {
  final AuthRepository _authRepository;

  VerifyCodeUseCase(this._authRepository);

  Future<AuthSession> call(String phoneNumber, String code) async {
    if (phoneNumber.isEmpty) {
      throw ArgumentError('Phone number cannot be empty');
    }
    
    if (code.isEmpty || code.length != 6) {
      throw ArgumentError('Code must be 6 digits');
    }

    final session = await _authRepository.verifyCode(phoneNumber, code);
    
    await _authRepository.saveSession(session);
    
    return session;
  }
}
