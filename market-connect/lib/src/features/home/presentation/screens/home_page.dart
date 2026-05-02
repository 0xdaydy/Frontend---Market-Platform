import 'package:market_connect/src/imports/core_imports.dart';
import 'package:market_connect/src/imports/packages_imports.dart';

import '../../../transactions/presentation/providers/transaction_providers.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    final now = DateTime.now();
    final dayName = DateFormat('EEEE', l10n.localeName).format(now);
    final dateStr = DateFormat('d MMMM yyyy', l10n.localeName).format(now);

    final transactionsAsync = ref.watch(transactionsProvider);

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$dayName · $dateStr',
                        style: tt.labelSmall?.copyWith(
                          color: cs.onSurfaceVariant,
                          letterSpacing: 0.08,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        l10n.homeTitle,
                        style: tt.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.02,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _IconButton(
                        icon: Icons.sync,
                        onPressed: () => context.push(AppRoutes.syncIssues),
                      ),
                      SizedBox(width: 8.w),
                      _IconButton(
                        icon: Icons.settings_outlined,
                        onPressed: () => context.push(AppRoutes.settings),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    SizedBox(height: 8.h),

                    // Hero buttons
                    SizedBox(
                      width: double.infinity,
                      height: 64.h,
                      child: FilledButton.icon(
                        onPressed: () => context.push(AppRoutes.catalogue),
                        icon: const Icon(Icons.shopping_bag_outlined),
                        label: Text(
                          l10n.newSale,
                          style: tt.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    SizedBox(
                      width: double.infinity,
                      height: 64.h,
                      child: OutlinedButton.icon(
                        onPressed: () => context.push(AppRoutes.recordRepayment),
                        icon: const Icon(Icons.receipt_long_outlined),
                        label: Text(
                          l10n.recordRepayment,
                          style: tt.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Stats card
                    transactionsAsync.when(
                      data: (transactions) {
                        final today = DateTime.now();
                        final todayTransactions = transactions.where((t) {
                          final dt = t.createdAt;
                          return dt.year == today.year &&
                              dt.month == today.month &&
                              dt.day == today.day;
                        }).toList();
                        final totalFcfa = todayTransactions.fold<double>(
                          0,
                          (sum, t) => sum + t.totalAmount,
                        );

                        return Card(
                          child: Padding(
                            padding: EdgeInsets.all(16.w),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      l10n.salesToday,
                                      style: tt.bodyMedium?.copyWith(
                                        color: cs.onSurfaceVariant,
                                      ),
                                    ),
                                    Text(
                                      '${todayTransactions.length}',
                                      style: tt.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontFeatures: const [
                                          FontFeature.tabularFigures(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(height: 16.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      l10n.totalFcfa,
                                      style: tt.bodyMedium?.copyWith(
                                        color: cs.onSurfaceVariant,
                                      ),
                                    ),
                                    Text(
                                      '${totalFcfa.toStringAsFixed(0)} ${l10n.currency}',
                                      style: tt.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: cs.primary,
                                        fontFeatures: const [
                                          FontFeature.tabularFigures(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      loading: () => const Card(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      ),
                      error: (_, __) => const Card(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: Text('No data')),
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
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return Material(
      color: cs.surface,
      shape: const CircleBorder(
        side: BorderSide(color: Colors.transparent),
      ),
      elevation: 0,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            border: Border.all(color: cs.outlineVariant),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20.w),
        ),
      ),
    );
  }
}
