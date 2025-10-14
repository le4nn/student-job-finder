import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_config.dart';
import '../utils/app_logger.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();

@module
abstract class RegisterModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @lazySingleton
  Dio get dio {
    final dio = Dio();
    dio.options.baseUrl = ApiConfig.baseUrl;
    dio.options.connectTimeout = ApiConfig.connectTimeout;
    dio.options.receiveTimeout = ApiConfig.receiveTimeout;
    dio.options.sendTimeout = ApiConfig.sendTimeout;
    dio.options.headers = ApiConfig.defaultHeaders;
    
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final logger = getIt<AppLogger>();
          logger.debug('🌐 ${options.method} ${options.path}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          final logger = getIt<AppLogger>();
          logger.debug('✅ ${response.statusCode} ${response.requestOptions.path}');
          handler.next(response);
        },
        onError: (error, handler) {
          final logger = getIt<AppLogger>();
          logger.error('❌ ${error.requestOptions.method} ${error.requestOptions.path}: ${error.message}');
          handler.next(error);
        },
      ),
    );
    
    return dio;
  }
}
