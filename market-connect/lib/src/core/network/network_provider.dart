import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/internet_connection_service.dart';

/// Global connectivity status provider.
///
/// Emits `true` when the device has internet access, `false` otherwise.
/// Uses [InternetConnectionService.onStatusChange] under the hood.
final networkStatusProvider = StreamProvider<bool>((ref) {
  final service = InternetConnectionService();
  return service.onStatusChange;
});
