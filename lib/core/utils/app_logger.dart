import 'package:logger/logger.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AppLogger {
  late final Logger _logger;

  AppLogger() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 2,
        lineLength: 80,
        colors: true,
        printEmojis: true,
        printTime: false,
      ),
    );
  }

  void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  void wtf(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }

  // Упрощенные методы логирования
  void logAuth(String action, {String? phone, String? error}) {
    if (error != null) {
      this.error('🔐 Auth: $action - $error');
    } else {
      info('🔐 Auth: $action${phone != null ? ' ($phone)' : ''}');
    }
  }

  void logNavigation(String to) {
    info('📍 → $to');
  }

  void logUserInput(String field, {bool valid = true}) {
    if (valid) {
      debug('✅ $field: valid');
    } else {
      warning('❌ $field: invalid');
    }
  }

  void logError(String context, String error) {
    this.error('💥 $context: $error');
  }
}
