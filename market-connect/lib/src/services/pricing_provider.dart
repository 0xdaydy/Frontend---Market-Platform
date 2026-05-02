import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pricing_service.dart';

/// Provides the shared PricingService instance.
///
/// Interest rate can be made dynamic later by watching a settings provider.
final pricingServiceProvider = Provider<PricingService>((ref) {
  return const PricingService();
});
