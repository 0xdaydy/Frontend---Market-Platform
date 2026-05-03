import 'package:market_connect/src/imports/core_imports.dart';
import 'package:market_connect/src/imports/packages_imports.dart';

import '../../../transactions/presentation/providers/transaction_providers.dart';
import '../../presentation/providers/catalog_providers.dart';
import '../../../../core/design_system/components/product_catalog_card.dart';
import '../../../../core/design_system/components/cart_summary_bar.dart';

class CatalogueScreen extends ConsumerWidget {
  const CatalogueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    final searchQuery = useState('');
    final selectedCategory = useState<int?>(null);

    final categoriesAsync = ref.watch(categoriesProvider);
    final productsAsync = searchQuery.value.isEmpty
        ? (selectedCategory.value != null
            ? ref.watch(productsByCategoryProvider(selectedCategory.value!))
            : ref.watch(productsProvider))
        : ref.watch(searchedProductsProvider(searchQuery.value));

    final cart = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 8.h),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.catalogTitle,
                        style: tt.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.02,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Search
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SearchBar(
                hintText: l10n.searchProduct,
                leading: const Icon(Icons.search),
                padding: WidgetStateProperty.all(
                  EdgeInsets.symmetric(horizontal: 16.w),
                ),
                onChanged: (value) => searchQuery.value = value,
              ),
            ),
            SizedBox(height: 10.h),
            // Category pills
            SizedBox(
              height: 40.h,
              child: categoriesAsync.when(
                data: (categories) {
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    children: [
                      _CategoryPill(
                        label: l10n.all,
                        isActive: selectedCategory.value == null,
                        onTap: () => selectedCategory.value = null,
                      ),
                      ...categories.map((cat) => _CategoryPill(
                            label: cat.name,
                            isActive: selectedCategory.value == cat.id,
                            onTap: () => selectedCategory.value = cat.id,
                          )),
                    ],
                  );
                },
                loading: () => const Center(child: SizedBox()),
                error: (e, _) {
                  AppLogger.error('CatalogueScreen: Failed to load categories: $e');
                  return const SizedBox();
                },
              ),
            ),
            SizedBox(height: 8.h),
            // Product list
            Expanded(
              child: productsAsync.when(
                data: (products) {
                  if (products.isEmpty) {
                    return Center(
                      child: Text(
                        l10n.noProducts,
                        style: tt.bodyLarge?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      final cartItem = cart.items
                          .where((i) => i.productId == product.id)
                          .firstOrNull;
                      final quantity = cartItem?.quantity ?? 0;

                      return ProductCatalogCard(
                        product: Product(
                          id: product.id.toString(),
                          name: product.name,
                          category: product.categoryName ?? l10n.uncategorized,
                          unit: 'kg',
                          priceFcfa: product.priceFcfa.toInt(),
                          categoryColor: cs.primary,
                        ),
                        quantity: quantity,
                        onQuantityChanged: (qty) {
                          if (qty == 0) {
                            ref.read(cartProvider.notifier).removeItem(product.id);
                          } else if (qty == 1 && quantity == 0) {
                            ref.read(cartProvider.notifier).addItem(
                              product.id,
                              product.name,
                              product.priceFcfa,
                            );
                          } else {
                            ref.read(cartProvider.notifier).updateQuantity(product.id, qty);
                          }
                        },
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) {
                  AppLogger.error('CatalogueScreen: Failed to load products: $error');
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Text(
                        AppErrorHandler.format(error),
                        style: tt.bodyMedium?.copyWith(color: cs.error),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
            ),
            // Cart summary bar
            if (!cart.isEmpty)
              CartSummaryBar(
                itemCount: cart.totalItems,
                totalFcfa: cart.subtotal.toInt(),
                ctaLabel: l10n.checkoutTitle,
                onCta: () => context.push(AppRoutes.checkout),
              ),
          ],
        ),
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({
    required this.label,
    this.isActive = false,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: FilterChip(
        selected: isActive,
        showCheckmark: false,
        label: Text(
          label,
          style: tt.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: isActive ? cs.onPrimary : cs.onSurfaceVariant,
          ),
        ),
        onSelected: (_) => onTap(),
        backgroundColor: cs.surface,
        selectedColor: cs.primary,
        side: BorderSide(color: cs.outlineVariant),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
    );
  }
}
