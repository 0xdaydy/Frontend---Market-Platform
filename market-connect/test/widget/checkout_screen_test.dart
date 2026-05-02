import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market_connect/src/features/transactions/presentation/providers/transaction_providers.dart';
import 'package:market_connect/src/features/transactions/presentation/screens/checkout_screen.dart';
import 'package:market_connect/generated/app_localizations.dart';

void main() {
  Widget buildTestableWidget(Widget child) {
    return ProviderScope(
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('fr'),
          home: child,
        ),
      ),
    );
  }

  testWidgets('CheckoutScreen renders empty cart state', (tester) async {
    await tester.pumpWidget(buildTestableWidget(const CheckoutScreen()));
    await tester.pumpAndSettle();

    // Verify title
    expect(find.text('Caisse'), findsOneWidget);

    // Verify empty state
    expect(find.text('Aucune donnée disponible'), findsOneWidget);
  });

  testWidgets('CheckoutScreen renders cart items', (tester) async {
    final container = ProviderContainer();

    // Set up cart with items and farmer
    container.read(cartProvider.notifier).setFarmer(1, 'Test Farmer');
    container.read(cartProvider.notifier).addItem(1, 'Riz', 500);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const ScreenUtilInit(
          designSize: Size(375, 812),
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('fr'),
            home: CheckoutScreen(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify cart items
    expect(find.text('Riz'), findsOneWidget);

    // Verify payment method toggle exists
    expect(find.byType(SegmentedButton<bool>), findsOneWidget);

    container.dispose();
  });
}
