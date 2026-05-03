import 'package:dio/dio.dart';
import '../../services/auth_service.dart';
import '../../services/secure_storage_service.dart';
import '../../utils/logger.dart';

/// Dio interceptor that attaches JWT bearer token to authenticated requests.
///
/// On 401 Unauthorized responses, clears the stored token so the app
/// can redirect to login on the next request.
class AuthInterceptor extends Interceptor {
  static const String _tokenKey = 'jwt_token';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _attachToken(options, handler).catchError((Object e, StackTrace st) {
      AppLogger.error('AuthInterceptor: Unhandled error in onRequest: $e', [e, st]);
      handler.next(options);
    });
  }

  Future<void> _attachToken(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      // Skip auth for public endpoints
      if (_isPublicEndpoint(options.path)) {
        handler.next(options);
        return;
      }

      final tokenResult = await SecureStorageService.instance.read(_tokenKey);
      tokenResult.fold(
        (failure) {
          AppLogger.warning('AuthInterceptor: Failed to read token: ${failure.message}');
          handler.next(options);
        },
        (token) {
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
            AppLogger.info('AuthInterceptor: Token attached to ${options.path}');
          }
          handler.next(options);
        },
      );
    } catch (e, st) {
      AppLogger.error('AuthInterceptor: Error attaching token: $e', [e, st]);
      handler.next(options);
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      AppLogger.warning('AuthInterceptor: 401 received, clearing token');
      AuthService.instance.forceLogout();
    }
    handler.next(err);
  }

  /// Store JWT token after successful login.
  static Future<void> setToken(String token) async {
    final result = await SecureStorageService.instance.write(_tokenKey, token);
    result.fold(
      (failure) => AppLogger.error('AuthInterceptor: Failed to store token: ${failure.message}'),
      (_) => AppLogger.info('AuthInterceptor: Token stored'),
    );
  }

  /// Clear JWT token on logout.
  static Future<void> clearToken() async {
    final result = await SecureStorageService.instance.delete(_tokenKey);
    result.fold(
      (failure) => AppLogger.error('AuthInterceptor: Failed to clear token: ${failure.message}'),
      (_) => AppLogger.info('AuthInterceptor: Token cleared'),
    );
  }

  /// Check if a token exists.
  static Future<bool> hasToken() async {
    final result = await SecureStorageService.instance.read(_tokenKey);
    return result.fold(
      (_) => false,
      (token) => token != null && token.isNotEmpty,
    );
  }

  bool _isPublicEndpoint(String path) {
    final publicPaths = [
      '/auth/login',
      '/auth/register',
      '/auth/forgot-password',
      '/auth/reset-password',
    ];
    return publicPaths.any((p) => path.contains(p));
  }
}
