import 'dart:async';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

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
        'device_name': 'mobile',
      });
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const ServerFailure('Invalid login response format');
      }

      // Extract and store JWT token
      final token = data['token'] ?? data['access_token'];
      if (token != null) {
        await AuthInterceptor.setToken(token.toString());
      }

      // Cache user data for getCurrentUser
      final userData = data['user'] ?? data;
      if (userData is Map<String, dynamic>) {
        await AuthInterceptor.setUserData(userData);
      }

      _authStateController.add(data);
      return data;
    }, requiresNetwork: true);
  }

  FutureEither<void> forgotPassword({required String email}) async {
    // Backend does not support password reset
    return left(
      const ServerFailure('Password reset is not supported by this backend.'),
    );
  }

  FutureEither<void> logout() async {
    return runTask(() async {
      await _dio.post<void>('/auth/logout');
      await AuthInterceptor.clearToken();
      await AuthInterceptor.clearUserData();
      _authStateController.add(null);
    }, requiresNetwork: true);
  }

  /// Force logout without calling API (e.g. on 401 error)
  void forceLogout() {
    AuthInterceptor.clearToken().ignore();
    AuthInterceptor.clearUserData().ignore();
    _authStateController.add(null);
  }

  FutureEither<Map<String, dynamic>?> getCurrentUser() async {
    return runTask(() async {
      final hasToken = await AuthInterceptor.hasToken();
      if (!hasToken) return null;
      return await AuthInterceptor.getUserData();
    });
  }

  void dispose() {
    _authStateController.close();
  }
}
