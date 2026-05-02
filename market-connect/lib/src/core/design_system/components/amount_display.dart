import 'package:market_connect/src/imports/core_imports.dart';


/// Displays a monetary amount in FCFA with locale-aware formatting.
///
/// Uses [FontFeature.tabularFigures] to prevent column jitter when
/// values change. Pairs numeric value in [headlineSmall] bold with
/// "FCFA" suffix in [labelSmall].
///
/// Example: `AmountDisplay(amount: 12500)` renders "12 500 FCFA"
class AmountDisplay extends StatelessWidget {
  const AmountDisplay({
    super.key,
    required this.amount,
    this.showSign = false,
    this.overrideStyle,
    this.showCurrency = true,
    this.textAlign = TextAlign.end,
  });

  /// Amount in FCFA (integer, smallest currency unit).
  final int amount;

  /// Whether to show a +/- sign.
  final bool showSign;

  /// Optional override for the numeric value style.
  final TextStyle? overrideStyle;

  /// Whether to append "FCFA" suffix.
  final bool showCurrency;

  /// Text alignment.
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    final numberFormat = NumberFormat.decimalPattern(l10n.localeName);
    final formattedAmount = numberFormat.format(amount.abs());

    final isNegative = amount < 0;
    final isZero = amount == 0;

    final numericStyle = overrideStyle ??
        tt.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          fontFeatures: const [FontFeature.tabularFigures()],
        );

    Color color;
    if (isNegative) {
      color = cs.error;
    } else if (isZero) {
      color = cs.onSurfaceVariant.withValues(alpha: 0.6);
    } else {
      color = cs.onSurface;
    }

    final sign = showSign && !isZero
        ? (isNegative ? '-' : '+')
        : '';

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          '$sign$formattedAmount',
          style: numericStyle?.copyWith(color: color),
          textAlign: textAlign,
        ),
        if (showCurrency) ...[
          const SizedBox(width: 4),
          Text(
            l10n.currency,
            style: tt.labelSmall?.copyWith(
              color: isZero
                  ? cs.onSurfaceVariant.withValues(alpha: 0.6)
                  : color,
            ),
          ),
        ],
      ],
    );
  }
}