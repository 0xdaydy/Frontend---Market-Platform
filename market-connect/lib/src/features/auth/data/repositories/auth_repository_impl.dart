import 'package:market_connect/src/imports/core_imports.dart';
import 'package:market_connect/src/imports/packages_imports.dart';

import 'package:market_connect/src/features/auth/domain/entities/user.dart';
import 'package:market_connect/src/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService = AuthService.instance;

  @override
  Stream<AppUser?> get onAuthStateChanged {
    return _authService.authStateChanges.map((userData) {
      if (userData == null) return null;
      try {
        return AppUser(
          id: userData['id']?.toString() ?? '',
          email: userData['email']?.toString() ?? '',
          name: userData['name']?.toString(),
          photoUrl: userData['photoUrl']?.toString(),
        );
      } catch (e, st) {
        AppLogger.error('AuthRepositoryImpl: Failed to map auth state: $e', [e, st]);
        return null;
      }
    });
  }

  @override
  FutureEither<AppUser> login({
    required String email,
    required String password,
  }) async {
    final result = await _authService.login(email: email, password: password);

    return result.flatMap((userData) {
      try {
        if (userData == null) {
          return left(const ServerFailure('Login failed: User record not found'));
        }

        final data = userData['user'] ?? userData;
        if (data is! Map<String, dynamic>) {
          return left(const ServerFailure('Invalid user data format from server'));
        }

        final user = AppUser(
          id: data['id']?.toString() ?? '',
          email: data['email']?.toString() ?? email,
          name: data['name']?.toString(),
        );

        return right(user);
      } catch (e, st) {
        AppLogger.error('AuthRepositoryImpl: Failed to parse login response: $e', [e, st]);
        return left(ServerFailure('Failed to parse login response: $e', error: e));
      }
    });
  }

  @override
  FutureEither<void> logout() {
    return _authService.logout();
  }

  @override
  FutureEither<AppUser?> checkAuthState() async {
    final result = await _authService.getCurrentUser();

    return result.map((userData) {
      if (userData == null) return null;

      try {
        return AppUser(
          id: userData['id']?.toString() ?? '',
          email: userData['email']?.toString() ?? '',
          name: userData['name']?.toString(),
          photoUrl: userData['photoUrl']?.toString(),
        );
      } catch (e, st) {
        AppLogger.error('AuthRepositoryImpl: Failed to parse current user: $e', [e, st]);
        return null;
      }
    });
  }
}
