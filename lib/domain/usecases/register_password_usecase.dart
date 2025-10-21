import 'package:injectable/injectable.dart';
import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

@injectable
class RegisterPasswordUseCase {
  final AuthRepository _authRepository;

  RegisterPasswordUseCase(this._authRepository);

  Future<AuthSession> call({
    String? email,
    String? phone,
    required String password,
    required String role,
  }) async {
    if (email == null && phone == null) {
      throw ArgumentError('Either email or phone must be provided');
    }
    
    if (password.isEmpty || password.length < 6) {
      throw ArgumentError('Password must be at least 6 characters');
    }
    
    if (role.isEmpty) {
      throw ArgumentError('Role is required');
    }

    return await _authRepository.registerPassword(
      email: email,
      phone: phone,
      password: password,
      role: role,
    );
  }
}
