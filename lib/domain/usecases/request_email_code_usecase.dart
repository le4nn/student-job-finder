import 'package:injectable/injectable.dart';
import '../repositories/auth_repository.dart';

@injectable
class RequestEmailCodeUseCase {
  final AuthRepository _authRepository;

  RequestEmailCodeUseCase(this._authRepository);

  Future<void> call(String email) async {
    if (email.isEmpty) {
      throw ArgumentError('Email cannot be empty');
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      throw ArgumentError('Invalid email format');
    }

    return await _authRepository.requestEmailCode(email);
  }
}
