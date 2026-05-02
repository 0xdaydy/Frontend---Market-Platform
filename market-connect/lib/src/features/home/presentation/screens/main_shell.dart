import 'package:market_connect/src/imports/core_imports.dart';
import 'package:market_connect/src/imports/packages_imports.dart';

import 'package:market_connect/src/core/design_system/components/offline_banner.dart';

/// Main app shell with bottom navigation for the 4 primary tabs:
/// Accueil, Catalogue, Producteurs, Crédit.
///
/// All drill-in screens are pushed full-screen on top of this shell,
/// hiding the tab bar.
class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({
    super.key,
    required this.navigationShell,
  });

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Column(
        children: [
          // Global offline banner overlay
          const OfflineBanner(),
          Expanded(child: navigationShell),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: cs.primary),
            label: l10n.homeTitle,
          ),
          NavigationDestination(
            icon: const Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view, color: cs.primary),
            label: l10n.catalogTitle,
          ),
          NavigationDestination(
            icon: const Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people, color: cs.primary),
            label: l10n.farmersTitle,
          ),
          NavigationDestination(
            icon: const Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet, color: cs.primary),
            label: l10n.creditTitle,
          ),
        ],
      ),
    );
  }
}