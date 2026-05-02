import 'package:market_connect/src/imports/core_imports.dart';
import 'package:market_connect/src/imports/packages_imports.dart';

import '../../../farmers/presentation/providers/farmer_providers.dart';
import '../../../../core/design_system/components/debt_card.dart';

class CreditScreen extends ConsumerWidget {
  const CreditScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    final debtsAsync = ref.watch(debtsProvider);

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.creditTitle,
                    style: tt.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.02,
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: () => context.push(AppRoutes.recordRepayment),
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(l10n.recordRepayment),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ],
              ),
            ),
            // Debt list
            Expanded(
              child: debtsAsync.when(
                data: (debts) {
                  if (debts.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle_outline,
                              size: 48, color: cs.onSurfaceVariant),
                          SizedBox(height: 12.h),
                          Text(
                            l10n.noDebts,
                            style: tt.titleMedium?.copyWith(
                              color: cs.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            l10n.allDebtsPaid,
                            style: tt.bodySmall?.copyWith(
                                color: cs.onSurfaceVariant),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    itemCount: debts.length,
                    itemBuilder: (context, index) {
                      final debt = debts[index];
                      return DebtCard(
                        debt: Debt(
                          id: debt.id.toString(),
                          reference: debt.reference ?? 'DEBT-${debt.id}',
                          remainingBalance: debt.balance.toInt(),
                          status: debt.status,
                          createdAt: debt.createdAt,
                          originalAmount: debt.totalDue.toInt(),
                          paidAmount: debt.amountRepaid.toInt(),
                        ),
                        onTap: () => context.push(
                            '${AppRoutes.debtDetail}/${debt.id}'),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Text(
                    error is Failure ? error.message : l10n.errorLoading,
                    style: tt.bodyMedium?.copyWith(color: cs.error),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
