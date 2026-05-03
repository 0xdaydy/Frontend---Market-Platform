import 'package:dio/dio.dart';

import 'failure.dart';

class AppErrorHandler {
  static String format(dynamic error) {
    if (error is String) return error;

    if (error is DioException) {
      return _formatDioException(error);
    }

    if (error is Failure) {
      return error.message;
    }

    try {
      final message = error?.message;
      if (message is String && message.isNotEmpty) {
        return _stripStackTrace(message);
      }
    } catch (_) {}

    try {
      final str = error.toString();
      if (str.isNotEmpty) return _stripStackTrace(str);
    } catch (_) {}

    return 'An unexpected error occurred';
  }

  static String _formatDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timed out. Please try again.';
      case DioExceptionType.sendTimeout:
        return 'Request timed out. Please try again.';
      case DioExceptionType.receiveTimeout:
        return 'Server is taking too long. Please try again.';
      case DioExceptionType.badResponse:
        return _formatBadResponse(error);
      case DioExceptionType.badCertificate:
        return 'Certificate verification failed. Please try again.';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.connectionError:
        return 'Unable to connect. Please check your internet connection.';
      case DioExceptionType.unknown:
        final msg = error.message;
        if (msg != null && msg.isNotEmpty) return _stripStackTrace(msg);
        return 'An unexpected error occurred.';
    }
  }

  static String _formatBadResponse(DioException error) {
    final statusCode = error.response?.statusCode;
    switch (statusCode) {
      case 400:
        return 'Invalid request. Please check your input.';
      case 401:
        return 'Invalid email or password.';
      case 403:
        return 'Access denied.';
      case 404:
        return 'Service not found.';
      case 429:
        return 'Too many attempts. Please try again later.';
      case 500:
        return 'Server error. Please try again later.';
      case 502:
        return 'Server is currently unavailable.';
      case 503:
        return 'Service temporarily unavailable.';
      default:
        return 'Request failed ($statusCode). Please try again.';
    }
  }

  static String _stripStackTrace(String message) {
    var cleaned = message;
    cleaned = cleaned.replaceAll(
      RegExp(r'#\d+\s+\S+.*$', multiLine: true),
      '',
    );
    cleaned = cleaned.replaceAll(
      RegExp(r'\s*at\s+\S+\s*\([^)]*\)', multiLine: true),
      '',
    );
    cleaned = cleaned.replaceAll(
      RegExp(r'\n\s*\n', multiLine: true),
      '\n',
    );
    return cleaned.trim();
  }
}
