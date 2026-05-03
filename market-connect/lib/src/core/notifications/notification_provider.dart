import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'notification_gateway.dart';
import 'toast_notification_adapter.dart';

/// Riverpod provider for the global [NotificationGateway].
///
/// Override this in tests to inject a spy or silent adapter.
final notificationGatewayProvider = Provider<NotificationGateway>(
  (ref) => ToastNotificationAdapter(),
);
