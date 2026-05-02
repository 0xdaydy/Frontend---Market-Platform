import 'package:market_connect/src/imports/core_imports.dart';
import 'package:market_connect/src/imports/packages_imports.dart';

import '../../../transactions/presentation/providers/transaction_providers.dart';

class TransactionDetailScreen extends ConsumerWidget {
  final String transactionId;

  const TransactionDetailScreen({super.key, required this.transactionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    final transactionIdInt = int.tryParse(transactionId);

    // If the ID is not an int, it might be a local reference
    final transactionAsync = transactionIdInt != null
        ? ref.watch(transactionProvider(transactionIdInt))
        : null;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.transactionDetail)),
      body: SafeArea(
        child: transactionAsync != null
            ? transactionAsync.when(
                data: (txn) => SingleChildScrollView(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    children: [
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                txn.reference ?? 'TXN-${txn.id}',
                                style: tt.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8.h),
                              Row(
                                children: [
                                  Chip(
                                    label: Text(
                                      DateFormat('dd/MM/yyyy', l10n.localeName)
                                          .format(txn.createdAt),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Chip(label: Text(txn.paymentMethod)),
                                  SizedBox(width: 8.w),
                                  Chip(
                                    label: Text(
                                      txn.isSynced
                                          ? l10n.synced
                                          : l10n.pending,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(txn.farmerName),
                                subtitle: Text('ID: ${txn.farmerId}'),
                              ),
                              const Divider(),
                              ...txn.items.map((item) => ListTile(
                                    title: Text(item.productName),
                                    subtitle: Text(
                                      '${item.quantity} \u00D7 ${item.unitPrice.toStringAsFixed(0)} FCFA',
                                    ),
                                    trailing: Text(
                                      '${item.lineTotal.toStringAsFixed(0)} FCFA',
                                    ),
                                  )),
                              const Divider(),
                              ListTile(
                                title: Text(
                                  l10n.total,
                                  style: tt.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold),
                                ),
                                trailing: Text(
                                  '${txn.totalAmount.toStringAsFixed(0)} FCFA',
                                  style: tt.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: cs.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Text(
                    error is Failure ? error.message : l10n.errorLoading,
                    style: tt.bodyMedium?.copyWith(color: cs.error),
                  ),
                ),
              )
            : Center(
                child: Text(
                  l10n.noData,
                  style: tt.bodyLarge?.copyWith(color: cs.onSurfaceVariant),
                ),
              ),
      ),
    );
  }
}
