import 'package:injectable/injectable.dart';
import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

@injectable
class VerifyEmailCodeUseCase {
  final AuthRepository _authRepository;

  VerifyEmailCodeUseCase(this._authRepository);

  Future<AuthSession> call(String email, String code) async {
    if (email.isEmpty) {
      throw ArgumentError('Email cannot be empty');
    }
    
    if (code.isEmpty || code.length != 6) {
      throw ArgumentError('Code must be 6 digits');
    }

    return await _authRepository.verifyEmailCode(email, code);
  }
}
