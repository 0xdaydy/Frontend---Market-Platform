import 'package:market_connect/src/imports/core_imports.dart';
import 'package:market_connect/src/imports/packages_imports.dart';

import '../../../transactions/presentation/providers/transaction_providers.dart';
import '../../presentation/providers/farmer_providers.dart';
import '../../../../core/design_system/components/debt_card.dart';

class FarmerDetailScreen extends ConsumerWidget {
  final String farmerId;

  const FarmerDetailScreen({super.key, required this.farmerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final farmerIdInt = int.tryParse(farmerId);

    if (farmerIdInt == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.farmerDetail)),
        body: Center(child: Text(l10n.error)),
      );
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.farmerDetail),
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.profile),
              Tab(text: l10n.debts),
              Tab(text: l10n.history),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Profil tab
            _ProfileTab(farmerId: farmerIdInt),
            // Dettes tab
            _DebtsTab(farmerId: farmerIdInt),
            // Historique tab
            _HistoryTab(farmerId: farmerIdInt),
          ],
        ),
      ),
    );
  }
}

class _ProfileTab extends ConsumerWidget {
  final int farmerId;
  const _ProfileTab({required this.farmerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    final farmerAsync = ref.watch(farmerProvider(farmerId));

    return farmerAsync.when(
      data: (farmer) => SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: cs.primaryContainer,
                      child: Text(
                        _getInitials(farmer.name),
                        style: tt.headlineMedium?.copyWith(
                          color: cs.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      farmer.name,
                      style: tt.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      farmer.cardId,
                      style: tt.titleMedium?.copyWith(
                        color: cs.onSurfaceVariant,
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    if (farmer.phone != null)
                      Text(
                        farmer.phone!,
                        style: tt.bodyMedium?.copyWith(
                            color: cs.onSurfaceVariant),
                      ),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Chip(
                          label: Text(
                              '${l10n.creditLimit}: ${farmer.creditLimit.toStringAsFixed(0)} FCFA'),
                        ),
                        SizedBox(width: 8.w),
                        Chip(
                          label: Text(
                              '${l10n.credit}: ${farmer.creditBalanceFcfa.toStringAsFixed(0)} FCFA'),
                          backgroundColor: cs.secondaryContainer,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: FilledButton.icon(
                onPressed: () {
                  ref
                      .read(cartProvider.notifier)
                      .setFarmer(farmer.id, farmer.name);
                  context.push(AppRoutes.checkout);
                },
                icon: const Icon(Icons.shopping_bag_outlined),
                label: Text(l10n.newSaleForFarmer),
              ),
            ),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text(
          error is Failure ? error.message : l10n.errorLoading,
          style: tt.bodyMedium?.copyWith(color: cs.error),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0].substring(0, 1).toUpperCase();
    }
    return '??';
  }
}

class _DebtsTab extends ConsumerWidget {
  final int farmerId;
  const _DebtsTab({required this.farmerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    final debtsAsync = ref.watch(farmerDebtsProvider(farmerId));

    return debtsAsync.when(
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
                  style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: EdgeInsets.all(20.w),
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
              onTap: () => context.push('${AppRoutes.debtDetail}/${debt.id}'),
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
    );
  }
}

class _HistoryTab extends ConsumerWidget {
  final int farmerId;
  const _HistoryTab({required this.farmerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    final transactionsAsync = ref.watch(farmerTransactionsProvider(farmerId));

    return transactionsAsync.when(
      data: (transactions) {
        if (transactions.isEmpty) {
          return Center(
            child: Text(
              l10n.noData,
              style: tt.bodyLarge?.copyWith(color: cs.onSurfaceVariant),
            ),
          );
        }
        return ListView.builder(
          padding: EdgeInsets.all(20.w),
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final txn = transactions[index];
            return Card(
              child: ListTile(
                title: Text(txn.reference ?? 'TXN-${txn.id}'),
                subtitle: Text(
                  '${DateFormat('dd/MM/yyyy', l10n.localeName).format(txn.createdAt)} \u00B7 ${txn.paymentMethod}',
                ),
                trailing: Text(
                  '${txn.totalAmount.toStringAsFixed(0)} FCFA',
                  style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                onTap: () => context.push(
                    '${AppRoutes.transactionDetail}/${txn.id ?? txn.reference}'),
              ),
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
    );
  }
}
