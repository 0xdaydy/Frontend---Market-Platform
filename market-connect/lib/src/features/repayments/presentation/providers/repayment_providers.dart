import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/data/models/models.dart';
import '../../../../core/data/repositories/repayment_repository.dart';
import '../../../../imports/packages_imports.dart';
import '../../../../utils/utils.dart';
import '../../../farmers/presentation/providers/farmer_providers.dart';

// Repository provider
final repaymentRepositoryProvider = Provider<RepaymentRepository>((ref) {
  return RepaymentRepository();
});

// Repayments provider
final repaymentsProvider = FutureProvider<List<RepaymentModel>>((ref) async {
  final repo = ref.watch(repaymentRepositoryProvider);
  return (await repo.getAll()).getOrThrow;
});

// Create repayment notifier
class CreateRepaymentNotifier extends AsyncNotifier<RepaymentModel?> {
  @override
  Future<RepaymentModel?> build() async => null;

  Future<void> createRepayment(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(repaymentRepositoryProvider);
      final result = await repo.createRepayment(data);
      state = result.fold(
        (failure) => AsyncValue.error(failure, StackTrace.current),
        (repayment) => AsyncValue.data(repayment),
      );
      // Refresh lists
      ref.invalidate(repaymentsProvider);
      final farmerId = data['farmer_id'] as int?;
      if (farmerId != null) {
        ref.invalidate(farmerDebtsProvider(farmerId));
      }
    } catch (e, st) {
      AppLogger.error('CreateRepaymentNotifier: Unexpected error: $e', [e, st]);
      state = AsyncValue.error(
        UnknownFailure(e is String ? e : e.toString(), error: e),
        st,
      );
    }
  }
}

final createRepaymentProvider = AsyncNotifierProvider<CreateRepaymentNotifier, RepaymentModel?>(CreateRepaymentNotifier.new);
