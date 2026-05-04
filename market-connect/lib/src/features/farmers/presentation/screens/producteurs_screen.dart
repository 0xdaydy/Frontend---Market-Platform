import 'package:market_connect/src/imports/core_imports.dart';
import 'package:market_connect/src/imports/packages_imports.dart';

import '../../../../core/design_system/components/farmer_list_tile.dart';
import '../../presentation/providers/farmer_providers.dart';

class ProducteursScreen extends HookConsumerWidget {
  const ProducteursScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    final searchQuery = useState('');
    final farmersAsync = searchQuery.value.isEmpty
        ? ref.watch(farmersProvider)
        : ref.watch(searchedFarmersProvider(searchQuery.value));

    return Scaffold(
      backgroundColor: cs.surface,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.farmerRegistration),
        icon: const Icon(Icons.add),
        label: Text(l10n.newFarmer, style: TextStyle(color: cs.surface)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 8.h),
              child: Row(
                children: [
                  Text(
                    l10n.farmersTitle,
                    style: tt.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.02,
                    ),
                  ),
                ],
              ),
            ),
            // Search
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SearchBar(
                hintText: l10n.searchFarmer,
                leading: const Icon(Icons.search),
                padding: WidgetStateProperty.all(
                  EdgeInsets.symmetric(horizontal: 16.w),
                ),
                onChanged: (value) => searchQuery.value = value,
              ),
            ),
            SizedBox(height: 10.h),
            // Farmer list
            Expanded(
              child: farmersAsync.when(
                data: (farmers) {
                  if (farmers.isEmpty) {
                    return Center(
                      child: Text(
                        searchQuery.value.isEmpty
                            ? l10n.noFarmers
                            : l10n.noSearchResults,
                        style: tt.bodyLarge?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    itemCount: farmers.length,
                    itemBuilder: (context, index) {
                      final farmer = farmers[index];
                      return FarmerListTile(
                        farmer: Farmer(
                          id: farmer.id.toString(),
                          name: farmer.name,
                          cardId: farmer.cardId,
                          phone: farmer.phone ?? '',
                          creditBalanceFcfa: farmer.creditBalanceFcfa.toInt(),
                        ),
                        onTap: () => context.push(
                          '${AppRoutes.farmerDetail}/${farmer.id}',
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) {
                  AppLogger.error(
                      'ProducteursScreen: Failed to load farmers: $error');
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
          ],
        ),
      ),
    );
  }
}
