import 'package:market_connect/src/imports/core_imports.dart';
import 'package:market_connect/src/imports/packages_imports.dart';

import '../../core/notifications/notifications.dart';
import '../../features/auth/domain/entities/user.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

/// Listens to auth controller state changes and handles side effects
/// (navigation on login/logout, error toast).
///
/// Keeps AuthController free of UI dependencies.
class AuthListenerWrapper extends ConsumerWidget {
  final Widget child;
  const AuthListenerWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<AppUser?>>(authControllerProvider, (prev, next) {
      // Only react to transitions, not initial state
      if (prev == null) return;

      next.whenOrNull(
        data: (user) {
          final wasLoggedIn = prev.hasValue && prev.value != null;
          final isLoggedIn = user != null;
          if (isLoggedIn && !wasLoggedIn) {
            // Successful login — navigate to home
            context.go(AppRoutes.home);
          } else if (!isLoggedIn && wasLoggedIn) {
            // Successful logout — navigate to login
            context.go(AppRoutes.login);
          }
        },
        error: (error, _) {
          if (error is Failure) {
            ref.read(notificationGatewayProvider).notify(error);
          }
        },
      );
    });

    return child;
  }
}
