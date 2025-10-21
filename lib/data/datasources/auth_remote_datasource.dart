import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';

import '../../core/config/api_config.dart';
import '../../core/utils/app_logger.dart';
import '../../domain/entities/user.dart';
import '../models/auth_session_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthSessionModel> registerPassword({
    String? email,
    String? phone,
    required String password,
    required String role,
  });
  Future<AuthSessionModel> loginPassword({
    required String identifier,
    required String password,
  });
  
  Future<void> requestCode(String phoneNumber, String role);
  Future<AuthSessionModel> verifyCode(String phoneNumber, String code);
  
  Future<void> requestEmailCode(String email);
  Future<AuthSessionModel> verifyEmailCode(String email, String code);
  
  Future<AuthSessionModel> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  });
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;
  final AppLogger _logger;

  AuthRemoteDataSourceImpl(this._dio, this._logger);

  @override
  Future<void> requestCode(String phoneNumber, String role) async {
    try {
      _logger.info('📡 API: Requesting code...');

      final response = await _dio.post(
        ApiConfig.requestCode,
        data: {'phone': phoneNumber, 'role': role},
      );

      _logger.info('📡 API: Response ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        _logger.info('✅ Code requested successfully');
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleDioError('Request Code', e);
      rethrow;
    } catch (e) {
      _logger.logError('API', 'Unexpected error: $e');
      rethrow;
    }
  }

  @override
  Future<AuthSessionModel> verifyCode(String phoneNumber, String code) async {
    try {
      _logger.info('📡 API: Verifying code...');

      final response = await _dio.post(
        ApiConfig.verifyCode,
        data: {'phone': phoneNumber, 'code': code},
      );

      _logger.info('📡 API: Response ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        _logger.info('✅ Code verified successfully');

        final responseData = response.data;
        return AuthSessionModel.fromJson(responseData);
      } else {
        throw Exception('Invalid code');
      }
    } on DioException catch (e) {
      _handleDioError('Verify Code', e);
      rethrow;
    } catch (e) {
      _logger.logError('API', 'Verify Code unexpected error: $e');
      rethrow;
    }
  }

  @override
  Future<AuthSessionModel> registerPassword({
    String? email,
    String? phone,
    required String password,
    required String role,
  }) async {
    try {
      _logger.info('📡 API: Registering with password...');

      final response = await _dio.post(
        ApiConfig.registerPassword,
        data: {
          if (email != null) 'email': email,
          if (phone != null) 'phone': phone,
          'password': password,
          'role': role,
        },
      );

      _logger.info('📡 API: Response ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        _logger.info('✅ Registered successfully');
        return AuthSessionModel.fromJson(response.data);
      } else {
        throw Exception('Registration failed');
      }
    } on DioException catch (e) {
      _handleDioError('Register Password', e);
      rethrow;
    }
  }

  @override
  Future<AuthSessionModel> loginPassword({
    required String identifier,
    required String password,
  }) async {
    try {
      _logger.info('📡 API: Logging in with password...');

      final response = await _dio.post(
        ApiConfig.loginPassword,
        data: {
          'identifier': identifier,
          'password': password,
        },
      );

      _logger.info('📡 API: Response ${response.statusCode}');

      if (response.statusCode == 200) {
        _logger.info('✅ Logged in successfully');
        return AuthSessionModel.fromJson(response.data);
      } else {
        throw Exception('Login failed');
      }
    } on DioException catch (e) {
      _handleDioError('Login Password', e);
      rethrow;
    }
  }

  @override
  Future<void> requestEmailCode(String email) async {
    try {
      _logger.info('📡 API: Requesting email code...');

      final response = await _dio.post(
        ApiConfig.requestEmailCode,
        data: {'email': email},
      );

      _logger.info('📡 API: Response ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        _logger.info('✅ Email code requested successfully');
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleDioError('Request Email Code', e);
      rethrow;
    }
  }

  @override
  Future<AuthSessionModel> verifyEmailCode(String email, String code) async {
    try {
      _logger.info('📡 API: Verifying email code...');

      final response = await _dio.post(
        ApiConfig.verifyEmailCode,
        data: {'email': email, 'code': code},
      );

      _logger.info('📡 API: Response ${response.statusCode}');

      if (response.statusCode == 200) {
        _logger.info('✅ Email code verified successfully');
        return AuthSessionModel.fromJson(response.data);
      } else {
        throw Exception('Invalid code');
      }
    } on DioException catch (e) {
      _handleDioError('Verify Email Code', e);
      rethrow;
    }
  }

  @override
  Future<AuthSessionModel> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    try {
      _logger.info('📡 API: Registering user...');

      final response = await _dio.post(
        ApiConfig.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'role': role.value,
        },
      );

      _logger.info('📡 API: Response ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        _logger.info('✅ User registered successfully');
        final responseData = response.data;
        return AuthSessionModel.fromJson(responseData);
      } else {
        throw Exception('Registration failed');
      }
    } on DioException catch (e) {
      _handleDioError('Register', e);
      rethrow;
    } catch (e) {
      _logger.logError('API', 'Registration unexpected error: $e');
      rethrow;
    }
  }

  void _handleDioError(String operation, DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        _logger.logError('Network', '$operation: Connection timeout');
        break;
      case DioExceptionType.sendTimeout:
        _logger.logError('Network', '$operation: Send timeout');
        break;
      case DioExceptionType.receiveTimeout:
        _logger.logError('Network', '$operation: Receive timeout');
        break;
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 'unknown';
        _logger.logError('Network', '$operation: Bad response ($statusCode)');
        break;
      case DioExceptionType.cancel:
        _logger.logError('Network', '$operation: Request cancelled');
        break;
      case DioExceptionType.connectionError:
        _logger.logError('Network', '$operation: No internet connection');
        break;
      case DioExceptionType.badCertificate:
        _logger.logError('Network', '$operation: SSL certificate error');
        break;
      case DioExceptionType.unknown:
        _logger.logError('Network', '$operation: Unknown error');
        break;
    }
  }
}
