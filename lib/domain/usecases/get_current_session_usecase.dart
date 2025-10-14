import 'package:injectable/injectable.dart';
import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

@injectable
class GetCurrentSessionUseCase {
  final AuthRepository _authRepository;

  GetCurrentSessionUseCase(this._authRepository);

  Future<AuthSession?> call() async {
    final session = await _authRepository.getCurrentSession();
    
    if (session != null && session.isExpired) {
      await _authRepository.clearSession();
      return null;
    }
    
    return session;
  }
}
