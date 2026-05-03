import '../../shared/helpers/show_toast.dart';
import '../../utils/failure.dart';
import 'notification_gateway.dart';

/// [NotificationGateway] adapter that renders failures through the
/// existing custom Overlay toast system.
///
/// Maps [Failure] subclasses to toast colours / severity:
/// - [NetworkFailure]  → warning (user can retry when online)
/// - [CacheFailure]    → warning (offline fallback active)
/// - [ServerFailure]   → error   (action failed)
/// - [UnknownFailure]  → error   (unexpected crash)
class ToastNotificationAdapter implements NotificationGateway {
  @override
  void notify(Failure failure) {
    showGlobalToast(
      message: failure.message,
      status: _statusFor(failure),
    );
  }

  String _statusFor(Failure failure) => switch (failure) {
        NetworkFailure _ => 'warning',
        CacheFailure _ => 'warning',
        ServerFailure _ => 'error',
        UnknownFailure _ => 'error',
        _ => 'error',
      };
}
