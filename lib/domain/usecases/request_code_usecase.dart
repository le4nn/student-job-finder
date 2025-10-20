import 'package:injectable/injectable.dart';
import '../repositories/auth_repository.dart';

@injectable
class RequestCodeUseCase {
  final AuthRepository _authRepository;

  RequestCodeUseCase(this._authRepository);

  Future<void> call(String phoneNumber) async {
    if (phoneNumber.isEmpty) {
      throw ArgumentError('Phone number cannot be empty');
    }
    
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    if (cleanPhone.length < 10) {
      throw ArgumentError('Invalid phone number format');
    }

    return await _authRepository.requestCode(phoneNumber);
  }
}
