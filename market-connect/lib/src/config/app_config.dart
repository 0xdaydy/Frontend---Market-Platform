import '../imports/core_imports.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../core/api/auth_interceptor.dart';

class AppConfig {
  AppConfig._();
  static late final Dio dio;

  static String get baseUrl => _getBaseUrl();

  static Future<void> init() async {
    dio = Dio(
      BaseOptions(
        baseUrl: _getBaseUrl(),
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Auth interceptor FIRST (so it can attach token before logging)
    dio.interceptors.add(AuthInterceptor());

    // Logging interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final hasAuth = options.headers.containsKey('Authorization');
          AppLogger.info('🌐 [DIO] REQUEST[${options.method}] => PATH: ${options.path}${hasAuth ? ' 🔐' : ' 🔓'}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          AppLogger.info('✅ [DIO] RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          final code = e.response?.statusCode;
          final body = e.response?.data;
          AppLogger.error('❌ [DIO] ERROR[$code] => PATH: ${e.requestOptions.path}');
          if (body != null) {
            AppLogger.info('   Response body: $body');
          }
          return handler.next(e);
        },
      ),
    );

  }

  static String _getBaseUrl() {
    return dotenv.maybeGet('API_BASE_URL') ?? 
           dotenv.maybeGet('API_URL') ?? 
           dotenv.maybeGet('BASE_API_URL') ?? 
           'http://localhost:8080/api/v1';
  }
}
