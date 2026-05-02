import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market_connect/src/features/auth/presentation/screens/login_screen.dart';
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

  testWidgets('LoginScreen renders all key elements', (tester) async {
    await tester.pumpWidget(buildTestableWidget(const LoginScreen()));
    await tester.pumpAndSettle();

    // Verify form fields
    expect(find.byType(TextFormField), findsNWidgets(2));

    // Verify login button
    expect(find.byType(FilledButton), findsOneWidget);
    expect(find.text('Se connecter'), findsOneWidget);
  });

  testWidgets('LoginScreen validates empty fields', (tester) async {
    await tester.pumpWidget(buildTestableWidget(const LoginScreen()));
    await tester.pumpAndSettle();

    // Tap login button without entering anything
    await tester.tap(find.byType(FilledButton));
    await tester.pump();

    // Should show validation errors
    expect(find.text('Ce champ est obligatoire'), findsNWidgets(2));
  });

  testWidgets('LoginScreen validates email format', (tester) async {
    await tester.pumpWidget(buildTestableWidget(const LoginScreen()));
    await tester.pumpAndSettle();

    // Enter invalid email
    await tester.enterText(
      find.byType(TextFormField).first,
      'invalid-email',
    );
    await tester.enterText(
      find.byType(TextFormField).last,
      'password123',
    );

    // Tap login
    await tester.tap(find.byType(FilledButton));
    await tester.pump();

    // Should show email validation error
    expect(find.text('Adresse email invalide'), findsOneWidget);
  });
}
