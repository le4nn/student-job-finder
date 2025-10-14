import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import '../config/api_config.dart';
import 'app_logger.dart';

@injectable
class NetworkChecker {
  final Dio _dio;
  final AppLogger _logger;

  NetworkChecker(this._dio, this._logger);

  Future<bool> checkNetworkConnection() async {
    try {
      _logger.info('🔍 Checking network connection...');
      final response = await _dio.get(ApiConfig.health);
      
      if (response.statusCode == 200) {
        _logger.info('✅ Network: Connected');
        return true;
      } else {
        _logger.logError('Network', 'Bad response: ${response.statusCode}');
        return false;
      }
    } on DioException catch (e) {
      _logNetworkError(e);
      return false;
    } catch (e) {
      _logger.logError('Network', 'Unexpected error: $e');
      return false;
    }
  }

  Future<void> simulateNetworkErrors() async {
    _logger.info('🧪 Testing network error handling...');
    
    try {
      await _dio.get('invalid-endpoint-12345');
    } on DioException catch (e) {
      _logger.info('Test 1 - Invalid endpoint:');
      _logNetworkError(e);
    }
    
    try {
      final testDio = Dio();
      testDio.options.connectTimeout = const Duration(milliseconds: 1);
      await testDio.get('https://httpbin.org/delay/5');
    } on DioException catch (e) {
      _logger.info('Test 2 - Timeout:');
      _logNetworkError(e);
    }
    
    _logger.info('🧪 Network error tests completed');
  }

  void _logNetworkError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        _logger.logError('Network', 'Connection timeout (${error.message})');
        break;
      case DioExceptionType.sendTimeout:
        _logger.logError('Network', 'Send timeout');
        break;
      case DioExceptionType.receiveTimeout:
        _logger.logError('Network', 'Receive timeout');
        break;
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 'unknown';
        final url = error.requestOptions.path;
        _logger.logError('Network', 'HTTP $statusCode on $url');
        break;
      case DioExceptionType.cancel:
        _logger.logError('Network', 'Request cancelled');
        break;
      case DioExceptionType.connectionError:
        _logger.logError('Network', 'No internet connection');
        break;
      case DioExceptionType.badCertificate:
        _logger.logError('Network', 'SSL certificate error');
        break;
      case DioExceptionType.unknown:
        _logger.logError('Network', 'Unknown network error: ${error.message}');
        break;
    }
  }
}
