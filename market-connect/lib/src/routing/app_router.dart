import 'package:go_router/go_router.dart';
import 'package:market_connect/src/routing/global_navigator.dart';
import 'package:market_connect/src/routing/app_routes.dart';

import 'package:market_connect/src/features/auth/presentation/screens/login_screen.dart';
import 'package:market_connect/src/features/home/presentation/screens/main_shell.dart';
import 'package:market_connect/src/features/home/presentation/screens/home_page.dart';
import 'package:market_connect/src/features/catalog/presentation/screens/catalogue_screen.dart';
import 'package:market_connect/src/features/catalog/presentation/screens/product_detail_screen.dart';
import 'package:market_connect/src/features/farmers/presentation/screens/producteurs_screen.dart';
import 'package:market_connect/src/features/farmers/presentation/screens/farmer_detail_screen.dart';
import 'package:market_connect/src/features/farmers/presentation/screens/farmer_registration_screen.dart';
import 'package:market_connect/src/features/credit/presentation/screens/credit_screen.dart';
import 'package:market_connect/src/features/credit/presentation/screens/debt_detail_screen.dart';
import 'package:market_connect/src/features/transactions/presentation/screens/checkout_screen.dart';
import 'package:market_connect/src/features/transactions/presentation/screens/transaction_confirmation_screen.dart';
import 'package:market_connect/src/features/transactions/presentation/screens/transaction_detail_screen.dart';
import 'package:market_connect/src/features/repayments/presentation/screens/record_repayment_screen.dart';
import 'package:market_connect/src/features/repayments/presentation/screens/repayment_confirmation_screen.dart';
import 'package:market_connect/src/features/sync/presentation/screens/sync_loader_screen.dart';
import 'package:market_connect/src/features/sync/presentation/screens/sync_issues_screen.dart';
import 'package:market_connect/src/features/settings/presentation/screens/settings_screen.dart';

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.login,
  routes: <RouteBase>[
    // Auth routes (no shell)
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.syncLoader,
      name: 'syncLoader',
      builder: (context, state) => const SyncLoaderScreen(),
    ),

    // Main shell with 4 tabs
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShell(
          navigationShell: navigationShell,
        );
      },
      branches: [
        // Accueil tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              name: 'home',
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),
        // Catalogue tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.catalogue,
              name: 'catalogue',
              builder: (context, state) => const CatalogueScreen(),
            ),
          ],
        ),
        // Producteurs tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.producteurs,
              name: 'producteurs',
              builder: (context, state) => const ProducteursScreen(),
            ),
          ],
        ),
        // Crédit tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.credit,
              name: 'credit',
              builder: (context, state) => const CreditScreen(),
            ),
          ],
        ),
      ],
    ),

    // Non-tab drill-in screens
    GoRoute(
      path: '${AppRoutes.farmerDetail}/:id',
      name: 'farmerDetail',
      builder: (context, state) => FarmerDetailScreen(
        farmerId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '${AppRoutes.productDetail}/:id',
      name: 'productDetail',
      builder: (context, state) => ProductDetailScreen(
        productId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '${AppRoutes.debtDetail}/:id',
      name: 'debtDetail',
      builder: (context, state) => DebtDetailScreen(
        debtId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '${AppRoutes.transactionDetail}/:id',
      name: 'transactionDetail',
      builder: (context, state) => TransactionDetailScreen(
        transactionId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: AppRoutes.checkout,
      name: 'checkout',
      builder: (context, state) => const CheckoutScreen(),
    ),
    GoRoute(
      path: AppRoutes.transactionConfirmation,
      name: 'transactionConfirmation',
      builder: (context, state) => const TransactionConfirmationScreen(),
    ),
    GoRoute(
      path: AppRoutes.recordRepayment,
      name: 'recordRepayment',
      builder: (context, state) => const RecordRepaymentScreen(),
    ),
    GoRoute(
      path: AppRoutes.repaymentConfirmation,
      name: 'repaymentConfirmation',
      builder: (context, state) => const RepaymentConfirmationScreen(),
    ),
    GoRoute(
      path: AppRoutes.farmerRegistration,
      name: 'farmerRegistration',
      builder: (context, state) => const FarmerRegistrationScreen(),
    ),
    GoRoute(
      path: AppRoutes.syncIssues,
      name: 'syncIssues',
      builder: (context, state) => const SyncIssuesScreen(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);