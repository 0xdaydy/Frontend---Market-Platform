import 'package:market_connect/src/imports/core_imports.dart';
import 'package:market_connect/src/imports/packages_imports.dart';

import '../../../transactions/presentation/providers/transaction_providers.dart';

class TransactionConfirmationScreen extends ConsumerWidget {
  const TransactionConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    final createdTxn = ref.watch(createTransactionProvider).asData?.value;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(l10n.transactionConfirmation),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: cs.primary,
                        size: 64,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        createdTxn?.reference ?? l10n.success,
                        style: tt.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 24.h),
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            children: [
                              _Row(
                                label: l10n.subtotal,
                                value:
                                    '${(createdTxn?.subtotal ?? 0).toStringAsFixed(0)} FCFA',
                              ),
                              _Row(
                                label: l10n.interest,
                                value:
                                    '${(createdTxn?.interestAmount ?? 0).toStringAsFixed(0)} FCFA',
                              ),
                              const Divider(),
                              _Row(
                                label: l10n.total,
                                value:
                                    '${(createdTxn?.totalAmount ?? 0).toStringAsFixed(0)} FCFA',
                                isBold: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: FilledButton(
                  onPressed: () => context.go(AppRoutes.home),
                  child: Text(l10n.newSaleCTA),
                ),
              ),
              SizedBox(height: 12.h),
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: OutlinedButton(
                  onPressed: () {},
                  child: Text(l10n.shareReceipt),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _Row({required this.label, required this.value, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    final tt = context.theme.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: isBold ? tt.titleMedium : tt.bodyMedium),
          Text(
            value,
            style: isBold
                ? tt.headlineSmall?.copyWith(fontWeight: FontWeight.bold)
                : tt.titleMedium,
          ),
        ],
      ),
    );
  }
}
