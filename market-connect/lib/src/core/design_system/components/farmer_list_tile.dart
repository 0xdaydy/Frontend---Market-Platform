import 'package:market_connect/src/imports/core_imports.dart';

import 'amount_display.dart';

/// A 72dp farmer list tile with avatar, name, card/phone, and credit balance.
///
/// Entire row is tappable. Credit balance shown only when non-zero and
/// [showCreditBalance] is true.
class FarmerListTile extends StatelessWidget {
  const FarmerListTile({
    super.key,
    required this.farmer,
    required this.onTap,
    this.showCreditBalance = true,
  });

  final Farmer farmer;
  final VoidCallback onTap;
  final bool showCreditBalance;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    final initials = _getInitials(farmer.name);

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 20,
              backgroundColor: cs.primaryContainer,
              child: Text(
                initials,
                style: tt.titleSmall?.copyWith(
                  color: cs.onPrimaryContainer,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    farmer.name,
                    style: tt.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${farmer.cardId} · ${farmer.phone}',
                    style: tt.bodyMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Credit balance
            if (showCreditBalance && farmer.creditBalanceFcfa != 0)
              AmountDisplay(
                amount: farmer.creditBalanceFcfa,
                showCurrency: false,
                overrideStyle: tt.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
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

/// Minimal Farmer model for UI components.
class Farmer {
  const Farmer({
    required this.id,
    required this.name,
    required this.cardId,
    required this.phone,
    this.creditBalanceFcfa = 0,
    this.creditLimit = 0,
    this.location,
  });

  final String id;
  final String name;
  final String cardId;
  final String phone;
  final int creditBalanceFcfa;
  final int creditLimit;
  final String? location;
}