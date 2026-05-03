import 'package:market_connect/src/imports/core_imports.dart';
import 'package:market_connect/src/imports/packages_imports.dart';

import '../../core/notifications/notifications.dart';
import '../../features/auth/domain/entities/user.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

/// Listens to auth controller state changes and handles side effects
/// (navigation on login/logout, error toast).
///
/// Keeps AuthController free of UI dependencies.
///
/// Uses [GoRouter.go] via [appRouter] instead of [context.go] because this
/// widget sits above the Router in the widget tree, so [GoRouter.of] would
/// throw.
class AuthListenerWrapper extends ConsumerWidget {
  final Widget child;
  const AuthListenerWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<AppUser?>>(authControllerProvider, (prev, next) {
      if (prev == null) return;

      next.whenOrNull(
        data: (user) {
          final wasLoggedIn = prev.hasValue && prev.value != null;
          final isLoggedIn = user != null;
          if (isLoggedIn && !wasLoggedIn) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              appRouter.go(AppRoutes.home);
            });
          } else if (!isLoggedIn && wasLoggedIn) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              appRouter.go(AppRoutes.login);
            });
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
