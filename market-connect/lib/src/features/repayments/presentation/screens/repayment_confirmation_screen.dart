import 'package:market_connect/src/imports/core_imports.dart';
import 'package:market_connect/src/imports/packages_imports.dart';

import '../../../repayments/presentation/providers/repayment_providers.dart';

class RepaymentConfirmationScreen extends ConsumerWidget {
  const RepaymentConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    final createdRepayment = ref.watch(createRepaymentProvider).asData?.value;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.repaymentRecorded)),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Icon(Icons.check_circle, color: cs.primary, size: 64),
                      SizedBox(height: 16.h),
                      Text(
                        l10n.repaymentRecorded,
                        style: tt.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 24.h),
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${l10n.amount}:',
                                style: tt.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                '${(createdRepayment?.amount ?? 0).toStringAsFixed(0)} FCFA',
                                style: tt.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: cs.primary,
                                ),
                              ),
                              if (createdRepayment?.commodityName != null) ...[
                                SizedBox(height: 8.h),
                                Text(
                                  '${createdRepayment!.commodityName} — ${createdRepayment.commodityKg?.toStringAsFixed(0) ?? 0} kg',
                                  style: tt.bodyMedium?.copyWith(
                                      color: cs.onSurfaceVariant),
                                ),
                              ],
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
                  onPressed: () => context.push(AppRoutes.recordRepayment),
                  child: Text(l10n.newRepayment),
                ),
              ),
              SizedBox(height: 12.h),
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: OutlinedButton(
                  onPressed: () => context.go(AppRoutes.home),
                  child: Text(l10n.back),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
