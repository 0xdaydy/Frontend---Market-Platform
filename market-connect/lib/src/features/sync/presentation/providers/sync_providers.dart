import '../../../../core/data/models/models.dart';
import '../../../../imports/packages_imports.dart';
import '../../../../services/services.dart';
import '../../../../utils/utils.dart';
import '../../../farmers/presentation/providers/farmer_providers.dart';
import '../../../repayments/presentation/providers/repayment_providers.dart';
import '../../../transactions/presentation/providers/transaction_providers.dart';
import '../../domain/farmer_sync_strategy.dart';
import '../../domain/repayment_sync_strategy.dart';
import '../../domain/sync_strategy.dart';
import '../../domain/transaction_sync_strategy.dart';

/// Aggregated strategy map — one strategy per entity type.
/// Adding a new syncable entity just means registering its strategy here.
final syncStrategiesProvider = Provider<Map<String, SyncStrategy>>((ref) {
  return {
    'transaction':
        TransactionSyncStrategy(ref.read(transactionRepositoryProvider)),
    'repayment': RepaymentSyncStrategy(ref.read(repaymentRepositoryProvider)),
    'farmer': FarmerSyncStrategy(ref.read(farmerRepositoryProvider)),
  };
});

// Sync queue provider
final syncQueueProvider = Provider<List<SyncQueueEntryModel>>((ref) {
  return HiveService.instance.getSyncQueue();
});

// Pending sync queue provider
final pendingSyncQueueProvider = Provider<List<SyncQueueEntryModel>>((ref) {
  return HiveService.instance.getPendingSyncQueue();
});

// Failed sync queue provider
final failedSyncQueueProvider = Provider<List<SyncQueueEntryModel>>((ref) {
  return HiveService.instance.getFailedSyncQueue();
});

// Unsynced transactions provider
final unsyncedTransactionsProvider = Provider<List<TransactionModel>>((ref) {
  return HiveService.instance.getUnsyncedTransactions();
});

// Unsynced repayments provider
final unsyncedRepaymentsProvider = Provider<List<RepaymentModel>>((ref) {
  return HiveService.instance.getUnsyncedRepayments();
});

// Sync engine notifier
class SyncEngineNotifier extends StateNotifier<AsyncValue<SyncResult>> {
  final Ref _ref;

  SyncEngineNotifier(this._ref) : super(const AsyncValue.data(SyncResult()));

  Future<void> syncAll() async {
    state = const AsyncValue.loading();
    final network = InternetConnectionService();
    final hasConnection = await network.hasConnection();

    if (!hasConnection) {
      state = const AsyncValue.data(SyncResult(
        success: false,
        message: 'No internet connection',
      ));
      return;
    }

    int synced = 0;
    int failed = 0;
    String? lastError;

    // Get pending queue
    final queue = HiveService.instance.getPendingSyncQueue();
    final strategies = _ref.read(syncStrategiesProvider);

    for (final entry in queue) {
      final strategy = strategies[entry.entityType];

      if (strategy == null) {
        lastError = 'No strategy for entity type: ${entry.entityType}';
        final updateResult = await HiveService.instance.updateQueueEntry(
          entry.copyWith(
            status: 'failed',
            retryCount: entry.retryCount + 1,
            lastError: lastError,
            lastAttemptAt: DateTime.now(),
          ),
        );
        updateResult.fold(
          (f) => AppLogger.warning('SyncEngine: Failed to update queue entry: ${f.message}'),
          (_) {},
        );
        failed++;
        continue;
      }

      try {
        final success = await strategy.sync(entry.payload);

        if (success) {
          final removeResult = await HiveService.instance.removeFromQueue(entry.id);
          removeResult.fold(
            (f) => AppLogger.warning('SyncEngine: Failed to remove queue entry ${entry.id}: ${f.message}'),
            (_) {},
          );
          synced++;
        } else {
          lastError = 'Sync returned failure';
          final updateResult = await HiveService.instance.updateQueueEntry(
            entry.copyWith(
              status: 'failed',
              retryCount: entry.retryCount + 1,
              lastError: lastError,
              lastAttemptAt: DateTime.now(),
            ),
          );
          updateResult.fold(
            (f) => AppLogger.warning('SyncEngine: Failed to update queue entry: ${f.message}'),
            (_) {},
          );
          failed++;
        }
      } catch (e) {
        final updateResult = await HiveService.instance.updateQueueEntry(
          entry.copyWith(
            status: 'failed',
            retryCount: entry.retryCount + 1,
            lastError: e.toString(),
            lastAttemptAt: DateTime.now(),
          ),
        );
        updateResult.fold(
          (f) => AppLogger.warning('SyncEngine: Failed to update queue entry: ${f.message}'),
          (_) {},
        );
        failed++;
      }
    }

    // Refresh providers
    _ref.invalidate(syncQueueProvider);
    _ref.invalidate(pendingSyncQueueProvider);
    _ref.invalidate(failedSyncQueueProvider);

    state = AsyncValue.data(SyncResult(
      success: failed == 0,
      syncedCount: synced,
      failedCount: failed,
      message: failed == 0
          ? 'Synchronisation terminee ($synced elements)'
          : '$synced synchronise(s), $failed echec(s)',
    ));
  }
}

class SyncResult {
  final bool success;
  final int syncedCount;
  final int failedCount;
  final String? message;

  const SyncResult({
    this.success = true,
    this.syncedCount = 0,
    this.failedCount = 0,
    this.message,
  });
}

final syncEngineProvider =
    StateNotifierProvider<SyncEngineNotifier, AsyncValue<SyncResult>>((ref) {
  return SyncEngineNotifier(ref);
});
