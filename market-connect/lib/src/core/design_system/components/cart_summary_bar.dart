import 'package:market_connect/src/imports/core_imports.dart';

import 'amount_display.dart';

/// Fixed bottom bar (80dp) showing cart item count, total FCFA, and CTA button.
///
/// Positioned above bottom navigation if present.
class CartSummaryBar extends StatelessWidget {
  const CartSummaryBar({
    super.key,
    required this.itemCount,
    required this.totalFcfa,
    required this.ctaLabel,
    required this.onCta,
    this.isEnabled = true,
  });

  final int itemCount;
  final int totalFcfa;
  final String ctaLabel;
  final VoidCallback onCta;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(
          top: BorderSide(color: cs.outlineVariant, width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          // Item count
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.itemsCount(itemCount),
                style: tt.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Total
          Expanded(
            child: AmountDisplay(
              amount: totalFcfa,
              overrideStyle: tt.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isEnabled ? cs.onSurface : cs.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ),
          ),
          // CTA
          FilledButton(
            onPressed: isEnabled ? onCta : null,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              minimumSize: const Size(0, 48),
            ),
            child: Text(
              ctaLabel,
              style: tt.labelLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}