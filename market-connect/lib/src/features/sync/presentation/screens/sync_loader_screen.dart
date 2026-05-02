import 'package:market_connect/src/imports/core_imports.dart';
import 'package:market_connect/src/imports/packages_imports.dart';

class SyncLoaderScreen extends StatelessWidget {
  const SyncLoaderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: cs.primary),
              SizedBox(height: 24.h),
              Text(
                l10n.syncInProgress,
                style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8.h),
              Text(
                'Farmers, products, categories...',
                style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}