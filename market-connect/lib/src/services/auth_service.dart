import 'dart:async';

import 'package:dio/dio.dart';

import '../config/app_config.dart';
import '../core/api/auth_interceptor.dart';
import '../utils/utils.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  Dio get _dio => AppConfig.dio;

  // Custom Backend doesn't have a built-in auth state stream, so we manage our own
  final StreamController<Map<String, dynamic>?> _authStateController =
      StreamController<Map<String, dynamic>?>.broadcast();

  /// Stream of auth state changes. Emits the current user map or null.
  Stream<Map<String, dynamic>?> get authStateChanges =>
      _authStateController.stream;

  FutureEither<Map<String, dynamic>?> login({
    required String email,
    required String password,
  }) async {
    return runTask(() async {
      final response =
          await _dio.post<Map<String, dynamic>>('/auth/login', data: {
        'email': email,
        'password': password,
      });
      final data = response.data as Map<String, dynamic>;
      
      // Extract and store JWT token
      final token = data['token'] ?? data['access_token'];
      if (token != null) {
        await AuthInterceptor.setToken(token.toString());
      }
      
      _authStateController.add(data);
      return data;
    }, requiresNetwork: true);
  }

  FutureEither<Map<String, dynamic>?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    return runTask(() async {
      final response =
          await _dio.post<Map<String, dynamic>>('/auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
      });
      final data = response.data as Map<String, dynamic>;
      
      // Extract and store JWT token
      final token = data['token'] ?? data['access_token'];
      if (token != null) {
        await AuthInterceptor.setToken(token.toString());
      }
      
      _authStateController.add(data);
      return data;
    }, requiresNetwork: true);
  }

  FutureEither<void> forgotPassword({required String email}) async {
    return runTask(() async {
      await _dio.post<void>('/auth/forgot-password', data: {'email': email});
    }, requiresNetwork: true);
  }

  FutureEither<void> logout() async {
    return runTask(() async {
      await _dio.post<void>('/auth/logout');
      await AuthInterceptor.clearToken();
      _authStateController.add(null);
    }, requiresNetwork: true);
  }

  /// Force logout without calling API (e.g. on 401 error)
  void forceLogout() {
    AuthInterceptor.clearToken();
    _authStateController.add(null);
  }

  FutureEither<Map<String, dynamic>?> getCurrentUser() async {
    return runTask(() async {
      final response = await _dio.get<Map<String, dynamic>>('/auth/me');
      return response.data as Map<String, dynamic>;
    });
  }

  void dispose() {
    _authStateController.close();
  }
}
