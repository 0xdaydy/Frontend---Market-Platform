import 'package:market_connect/src/utils/utils.dart';
import 'package:market_connect/src/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  /// Stream of auth state changes. Emits AppUser when authenticated, null when not.
  Stream<AppUser?> get onAuthStateChanged;

  /// Sign in with email and password
  FutureEither<AppUser> login({
    required String email,
    required String password,
  });

  /// Sign out the current user
  FutureEither<void> logout();
  
  /// Check if the user is currently authenticated natively
  FutureEither<AppUser?> checkAuthState();
}
