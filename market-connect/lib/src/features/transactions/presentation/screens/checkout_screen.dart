import 'package:market_connect/src/imports/core_imports.dart';
import 'package:market_connect/src/imports/packages_imports.dart';

import '../../../farmers/presentation/providers/farmer_providers.dart';
import '../../../../services/pricing_provider.dart';
import '../../../transactions/presentation/providers/transaction_providers.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  bool isCredit = false;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    final cart = ref.watch(cartProvider);
    final createAsync = ref.watch(createTransactionProvider);
    final pricing = ref.watch(pricingServiceProvider);

    // Compute totals from cart
    final subtotal = cart.subtotal;
    final interest = isCredit ? pricing.calculateInterest(subtotal) : 0.0;
    final total = subtotal + interest;

    // Watch farmer details if cart has a farmer
    final farmerAsync = cart.farmerId != null
        ? ref.watch(farmerProvider(cart.farmerId!))
        : null;

    // Listen for transaction creation state changes
    ref.listen(createTransactionProvider, (previous, next) {
      next.whenOrNull(
        data: (transaction) {
          if (transaction != null) {
            // Clear cart and navigate to confirmation
            ref.read(cartProvider.notifier).clear();
            context.push(AppRoutes.transactionConfirmation);
          }
        },
        error: (error, _) {
          context.showErrorSnackBar(
            error is Failure ? error.message : l10n.error,
          );
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.checkoutTitle),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Farmer card
                    if (farmerAsync != null)
                      farmerAsync.when(
                        data: (farmer) => Card(
                          child: Padding(
                            padding: EdgeInsets.all(14.w),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: cs.primaryContainer,
                                  child: Text(
                                    _getInitials(farmer.name),
                                    style: tt.titleSmall?.copyWith(
                                      color: cs.onPrimaryContainer,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        farmer.name,
                                        style: tt.titleMedium?.copyWith(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        '${farmer.cardId} \u00B7 ${farmer.phone ?? ''}',
                                        style: tt.bodySmall?.copyWith(
                                            color: cs.onSurfaceVariant),
                                      ),
                                    ],
                                  ),
                                ),
                                Chip(
                                  label: Text(
                                    l10n.itemsCount(cart.totalItems),
                                  ),
                                  backgroundColor: cs.primaryContainer,
                                ),
                              ],
                            ),
                          ),
                        ),
                        loading: () => const Card(
                          child: Padding(
                            padding: EdgeInsets.all(14),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        ),
                        error: (_, __) => const SizedBox.shrink(),
                      )
                    else
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(14.w),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: cs.primaryContainer,
                                child: Icon(Icons.person_outline,
                                    color: cs.onPrimaryContainer),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Text(
                                  cart.farmerName ?? l10n.selectFarmer,
                                  style: tt.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    SizedBox(height: 16.h),
                    // Payment method
                    Text(
                      l10n.paymentMethod,
                      style: tt.labelMedium?.copyWith(
                        color: cs.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    SegmentedButton<bool>(
                      segments: [
                        ButtonSegment(
                          value: false,
                          label: Text(l10n.cash),
                        ),
                        ButtonSegment(
                          value: true,
                          label: Text(l10n.credit),
                        ),
                      ],
                      selected: {isCredit},
                      onSelectionChanged: (set) {
                        setState(() => isCredit = set.first);
                      },
                    ),
                    SizedBox(height: 16.h),
                    // Cart items
                    if (cart.items.isEmpty)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(24.w),
                          child: Text(
                            l10n.noData,
                            style: tt.bodyLarge?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ),
                      )
                    else
                      ...cart.items.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;
                        return Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.productName,
                                        style: tt.titleMedium?.copyWith(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        '${item.quantity} \u00D7 ${item.unitPrice.toStringAsFixed(0)} FCFA',
                                        style: tt.bodySmall?.copyWith(
                                            color: cs.onSurfaceVariant),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${item.lineTotal.toStringAsFixed(0)} FCFA',
                                    style: tt.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            if (index < cart.items.length - 1)
                              const Divider(),
                          ],
                        );
                      }),
                    SizedBox(height: 16.h),
                    // Totals
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(18.w),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  l10n.subtotal,
                                  style: tt.bodyMedium?.copyWith(
                                      color: cs.onSurfaceVariant),
                                ),
                                Text(
                                  '${subtotal.toStringAsFixed(0)} FCFA',
                                  style: tt.titleMedium,
                                ),
                              ],
                            ),
                            if (isCredit) ...[
                              SizedBox(height: 8.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    l10n.interest,
                                    style: tt.bodyMedium?.copyWith(
                                        color: cs.onSurfaceVariant),
                                  ),
                                  Text(
                                    '${interest.toStringAsFixed(0)} FCFA',
                                    style: tt.titleMedium?.copyWith(
                                        color: cs.secondary),
                                  ),
                                ],
                              ),
                            ],
                            Divider(height: 24.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  l10n.total,
                                  style: tt.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '${total.toStringAsFixed(0)} FCFA',
                                  style: tt.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: cs.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
            // CTA
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: FilledButton(
                      onPressed: cart.isEmpty || cart.farmerId == null
                          ? null
                          : () => _finalizeSale(context, cart, total),
                      child: createAsync.isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              l10n.finalizeSale,
                              style: tt.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w600),
                            ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: cs.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        l10n.onlineSynced,
                        style: tt.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _finalizeSale(BuildContext context, CartState cart, double total) {
    final paymentMethod = isCredit ? 'credit' : 'cash';

    final itemsData = cart.items
        .map((item) => {
              'product_id': item.productId,
              'product_name': item.productName,
              'quantity': item.quantity,
              'unit_price': item.unitPrice,
              'line_total': item.lineTotal,
            })
        .toList();

    final data = {
      'farmer_id': cart.farmerId,
      'farmer_name': cart.farmerName,
      'payment_method': paymentMethod,
      'total_amount': total,
      'subtotal': cart.subtotal,
      'interest_amount': isCredit ? (cart.subtotal * 0.05) : 0.0,
      'items': itemsData,
    };

    ref.read(createTransactionProvider.notifier).createTransaction(data);
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
