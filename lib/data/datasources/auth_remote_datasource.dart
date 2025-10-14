import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';

import '../../core/config/api_config.dart';
import '../../core/utils/app_logger.dart';
import '../../domain/entities/user.dart';
import '../models/auth_session_model.dart';

abstract class AuthRemoteDataSource {
  Future<void> sendOtp(String phoneNumber);
  Future<AuthSessionModel> verifyOtp(String phoneNumber, String code);
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
  Future<void> sendOtp(String phoneNumber) async {
    try {
      _logger.info('📡 API: Sending OTP request...');
      
      final response = await _dio.post(ApiConfig.sendOtp, data: {
        'phone': phoneNumber,
      });

      _logger.info('📡 API: Response ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        _logger.info('✅ OTP sent successfully');
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleDioError('Send OTP', e);
      rethrow;
    } catch (e) {
      _logger.logError('API', 'Unexpected error: $e');
      rethrow;
    }
  }

  @override
  Future<AuthSessionModel> verifyOtp(String phoneNumber, String code) async {
    try {
      _logger.info('📡 API: Verifying OTP...');
      
      final response = await _dio.post(ApiConfig.verifyOtp, data: {
        'phone': phoneNumber,
        'code': code,
      });

      _logger.info('📡 API: Response ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        _logger.info('✅ OTP verified successfully');
        
        // Парсим реальный ответ от API
        final responseData = response.data;
        return AuthSessionModel.fromJson(responseData);
      } else {
        throw Exception('Invalid OTP code');
      }
    } on DioException catch (e) {
      _handleDioError('Verify OTP', e);
      rethrow;
    } catch (e) {
      _logger.logError('API', 'Verify OTP unexpected error: $e');
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
      
      final response = await _dio.post(ApiConfig.register, data: {
        'name': name,
        'email': email,
        'password': password,
        'role': role.value,
      });

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
