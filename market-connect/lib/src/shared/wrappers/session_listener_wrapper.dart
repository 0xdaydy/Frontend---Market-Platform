import 'package:market_connect/src/imports/core_imports.dart';
import 'package:market_connect/src/imports/packages_imports.dart';

import 'package:market_connect/src/features/auth/presentation/providers/session_provider.dart';

class SessionListenerWrapper extends ConsumerWidget {
  final Widget child;
  const SessionListenerWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<SessionState>(sessionProvider, (prev, next) {
      if (next.status != SessionStatus.unknown) {
        FlutterNativeSplash.remove();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) return;
          try {
            if (next.status == SessionStatus.authenticated) {
              context.go(AppRoutes.home);
            } else if (next.status == SessionStatus.unauthenticated) {
              context.go(AppRoutes.login);
            }
          } catch (e) {
            // GoRouter may not be available in test contexts; ignore.
            AppLogger.warning('SessionListenerWrapper: navigation skipped: $e');
          }
        });
      }
    });

    return child;
  }
}
