import 'package:market_connect/src/imports/core_imports.dart';
import 'package:market_connect/src/imports/packages_imports.dart';

class DebtDetailScreen extends StatelessWidget {
  final String debtId;

  const DebtDetailScreen({super.key, required this.debtId});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.debtDetail)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('TXN-20260501-$debtId', style: tt.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                      SizedBox(height: 16.h),
                      _InfoRow(label: l10n.originalAmount, value: '10 000 FCFA'),
                      _InfoRow(label: l10n.paidAmount, value: '2 500 FCFA'),
                      _InfoRow(label: l10n.remainingBalance, value: '7 500 FCFA', isHighlight: true),
                      SizedBox(height: 8.h),
                      Chip(label: Text(l10n.open)),
                      SizedBox(height: 8.h),
                      Text('01/05/2026', style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Text(l10n.repayments, style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              SizedBox(height: 8.h),
              ...List.generate(2, (index) => Card(
                child: ListTile(
                  title: Text('${(index + 1) * 1250} FCFA'),
                  subtitle: const Text('Cash'),
                  trailing: const Text('01/05/2026'),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlight;

  const _InfoRow({required this.label, required this.value, this.isHighlight = false});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
          Text(
            value,
            style: isHighlight
                ? tt.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: cs.error)
                : tt.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}