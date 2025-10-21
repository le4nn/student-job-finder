import 'package:injectable/injectable.dart';
import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

@injectable
class LoginPasswordUseCase {
  final AuthRepository _authRepository;

  LoginPasswordUseCase(this._authRepository);

  Future<AuthSession> call({
    required String identifier,
    required String password,
  }) async {
    if (identifier.isEmpty) {
      throw ArgumentError('Email or phone is required');
    }
    
    if (password.isEmpty) {
      throw ArgumentError('Password is required');
    }

    return await _authRepository.loginPassword(
      identifier: identifier,
      password: password,
    );
  }
}
