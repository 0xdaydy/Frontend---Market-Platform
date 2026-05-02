import 'package:market_connect/src/imports/core_imports.dart';

import 'amount_display.dart';

/// A 96dp product catalog card with category color dot, name, price,
/// and quantity stepper or "Add" button.
///
/// When [quantity] == 0, shows an "Add" button.
/// When [quantity] > 0, shows a stepper (+/- + count).
class ProductCatalogCard extends StatelessWidget {
  const ProductCatalogCard({
    super.key,
    required this.product,
    required this.onQuantityChanged,
    this.quantity = 0,
  });

  final Product product;
  final ValueChanged<int> onQuantityChanged;
  final int quantity;

  bool get inCart => quantity > 0;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Container(
      height: 96,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          // Category color dot
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: product.categoryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: product.categoryColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Product info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  product.name,
                  style: tt.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${product.category} · ${product.unit}',
                  style: tt.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                AmountDisplay(
                  amount: product.priceFcfa,
                  showCurrency: false,
                  overrideStyle: tt.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // Trailing: stepper or Add button
          if (quantity == 0)
            FilledButton(
              onPressed: () => onQuantityChanged(1),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                minimumSize: const Size(0, 36),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                AppLocalizations.of(context)!.add,
                style: tt.labelMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            )
          else
            _Stepper(
              quantity: quantity,
              onChanged: onQuantityChanged,
            ),
        ],
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({required this.quantity, required this.onChanged});

  final int quantity;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {

    final tt = context.theme.textTheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StepperButton(
          icon: Icons.remove,
          onPressed: () => onChanged(quantity - 1),
          isPrimary: false,
        ),
        SizedBox(
          width: 28,
          child: Text(
            '$quantity',
            textAlign: TextAlign.center,
            style: tt.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
        _StepperButton(
          icon: Icons.add,
          onPressed: () => onChanged(quantity + 1),
          isPrimary: true,
        ),
      ],
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
    required this.icon,
    required this.onPressed,
    required this.isPrimary,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return SizedBox(
      width: 32,
      height: 32,
      child: Material(
        color: isPrimary ? cs.primary : cs.surface,
        shape: const CircleBorder(
          side: BorderSide(color: Colors.transparent),
        ),
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isPrimary ? cs.primary : cs.outlineVariant,
              ),
            ),
            child: Icon(
              icon,
              size: 14,
              color: isPrimary ? cs.onPrimary : cs.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

/// Minimal Product model for UI components.
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.unit,
    required this.priceFcfa,
    required this.categoryColor,
    this.description,
  });

  final String id;
  final String name;
  final String category;
  final String unit;
  final int priceFcfa;
  final Color categoryColor;
  final String? description;
}