import 'package:market_connect/src/imports/core_imports.dart';

/// Global offline banner that slides in from the top when connectivity is lost.
///
/// Non-dismissible, non-blocking. Content below remains scrollable and tappable.
/// Height: 48dp. Background: offlineIndicator color.
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      height: 48,
      color: cs.secondary,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wifi_off,
            color: cs.onSecondary,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.offlineBanner,
              style: tt.labelLarge?.copyWith(
                color: cs.onSecondary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}