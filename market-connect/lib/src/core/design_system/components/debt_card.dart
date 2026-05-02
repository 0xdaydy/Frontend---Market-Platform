import 'package:market_connect/src/imports/core_imports.dart';

import 'amount_display.dart';
import 'status_chip.dart';

/// A 120dp debt summary card showing reference, remaining balance,
/// status chip, and creation date.
///
/// Status colors:
/// - open: amber (offlineIndicator)
/// - partially_paid: yellow (warning)
/// - closed: green (success)
class DebtCard extends StatelessWidget {
  const DebtCard({
    super.key,
    required this.debt,
    this.onTap,
  });

  final Debt debt;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top: Reference
            Text(
              debt.reference,
              style: tt.labelSmall?.copyWith(
                color: cs.outline,
                fontWeight: FontWeight.w500,
              ),
            ),
            // Middle: Remaining balance
            AmountDisplay(
              amount: debt.remainingBalance,
              overrideStyle: tt.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            // Bottom: Status + Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatusChip(status: _mapStatus(debt.status)),
                Text(
                  _formatDate(context, debt.createdAt),
                  style: tt.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  StatusType _mapStatus(String status) {
    return switch (status) {
      'open' => StatusType.open,
      'partially_paid' => StatusType.partiallyPaid,
      'closed' => StatusType.closed,
      _ => StatusType.open,
    };
  }

  String _formatDate(BuildContext context, DateTime date) {
    final l10n = AppLocalizations.of(context)!;
    return DateFormat('dd/MM/yyyy', l10n.localeName).format(date);
  }
}

/// Minimal Debt model for UI components.
class Debt {
  const Debt({
    required this.id,
    required this.reference,
    required this.remainingBalance,
    required this.status,
    required this.createdAt,
    this.originalAmount = 0,
    this.paidAmount = 0,
  });

  final String id;
  final String reference;
  final int remainingBalance;
  final String status;
  final DateTime createdAt;
  final int originalAmount;
  final int paidAmount;
}