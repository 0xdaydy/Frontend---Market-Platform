import '../../utils/failure.dart';

/// Gateway for surfacing [Failure] instances to the user.
///
/// The interface is intentionally narrow: callers emit a [Failure];
/// the adapter decides how it is presented. This keeps every screen
/// and provider free of presentation logic.
///
/// **One adapter = hypothetical seam. Two adapters = real seam.**
/// Currently backed by a single [ToastNotificationAdapter], but the
/// gateway shape survives if we later add analytics, logging, or
/// platform-specific channels.
abstract class NotificationGateway {
  /// Surface [failure] to the user.
  ///
  /// Implementations must be safe to call from any isolate or zone
  /// that has access to the UI layer (e.g. after app mount).
  void notify(Failure failure);
}
