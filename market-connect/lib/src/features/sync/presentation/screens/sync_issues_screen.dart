import 'package:market_connect/src/imports/core_imports.dart';
import 'package:market_connect/src/imports/packages_imports.dart';

import '../../../../core/data/models/models.dart';
import '../../../sync/presentation/providers/sync_providers.dart';

class SyncIssuesScreen extends ConsumerWidget {
  const SyncIssuesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    final pendingQueue = ref.watch(pendingSyncQueueProvider);
    final failedQueue = ref.watch(failedSyncQueueProvider);
    final syncState = ref.watch(syncEngineProvider);

    // Calculate pending totals
    final pendingTransactions = pendingQueue
        .where((e) => e.entityType == 'transaction')
        .toList();
    final pendingTotal = pendingTransactions.fold<double>(
      0,
      (sum, e) => sum + ((e.payload['total_amount'] as num?)?.toDouble() ?? 0),
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.syncTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sync status
              if (syncState.isLoading)
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      children: [
                        const CircularProgressIndicator(),
                        SizedBox(height: 12.h),
                        Text(l10n.syncInProgress),
                      ],
                    ),
                  ),
                ),
              if (syncState.hasError)
                Card(
                  color: cs.errorContainer,
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Text(
                      syncState.error is Failure
                          ? (syncState.error as Failure).message
                          : l10n.error,
                      style: TextStyle(color: cs.onErrorContainer),
                    ),
                  ),
                ),
              if (syncState.hasValue && syncState.value!.message != null)
                Card(
                  color: syncState.value!.success
                      ? cs.primaryContainer
                      : cs.errorContainer,
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Text(
                      syncState.value!.message!,
                      style: TextStyle(
                        color: syncState.value!.success
                            ? cs.onPrimaryContainer
                            : cs.onErrorContainer,
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 16.h),
              // Pending section
              Text(l10n.pendingSection,
                  style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              SizedBox(height: 8.h),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${pendingQueue.length} ${pendingQueue.length == 1 ? 'element' : 'elements'}',
                        style: tt.bodyMedium,
                      ),
                      Text(
                        '${pendingTotal.toStringAsFixed(0)} FCFA',
                        style: tt.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              // Failed section
              if (failedQueue.isNotEmpty) ...[
                Text(l10n.failedSection,
                    style:
                        tt.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                SizedBox(height: 8.h),
                ...failedQueue.map((entry) => Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${entry.entityType.toUpperCase()} — ${entry.entityId}',
                              style: tt.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              entry.operation,
                              style: tt.bodyMedium?.copyWith(
                                  color: cs.onSurfaceVariant),
                            ),
                            if (entry.lastError != null)
                              Text(
                                '${l10n.error}: ${entry.lastError}',
                                style: tt.bodySmall?.copyWith(color: cs.error),
                              ),
                            SizedBox(height: 8.h),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () => _retryEntry(ref, entry),
                                child: Text(l10n.retry),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                SizedBox(height: 24.h),
              ],
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: FilledButton(
                  onPressed: syncState.isLoading
                      ? null
                      : () => ref.read(syncEngineProvider.notifier).syncAll(),
                  child: syncState.isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(l10n.syncNow),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _retryEntry(WidgetRef ref, SyncQueueEntryModel entry) async {
    // Reset entry to pending and trigger sync
    await HiveService.instance.updateQueueEntry(
      entry.copyWith(status: 'pending', retryCount: 0, lastError: null),
    );
    ref.invalidate(pendingSyncQueueProvider);
    ref.invalidate(failedSyncQueueProvider);
    ref.read(syncEngineProvider.notifier).syncAll();
  }
}
