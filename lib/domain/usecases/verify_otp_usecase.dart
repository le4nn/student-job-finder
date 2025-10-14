import 'package:injectable/injectable.dart';
import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

@injectable
class VerifyOtpUseCase {
  final AuthRepository _authRepository;

  VerifyOtpUseCase(this._authRepository);

  Future<AuthSession> call(String phoneNumber, String code) async {
    if (phoneNumber.isEmpty) {
      throw ArgumentError('Phone number cannot be empty');
    }
    
    if (code.isEmpty || code.length != 4) {
      throw ArgumentError('Code must be 4 digits');
    }

    final session = await _authRepository.verifyOtp(phoneNumber, code);
    
    await _authRepository.saveSession(session);
    
    return session;
  }
}
