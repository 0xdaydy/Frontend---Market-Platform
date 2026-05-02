import 'package:market_connect/src/imports/core_imports.dart';

/// A status chip with preset colors for sync, debt, and payment states.
///
/// Variants:
/// - synced: green
/// - pending: amber
/// - offline: secondary container
/// - error: red
/// - open: amber
/// - partiallyPaid: yellow
/// - closed: green
class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.status,
    this.compact = false,
  });

  final StatusType status;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final ext = context.theme.extension<AppColorsExtension>()!;

    final (bgColor, fgColor, label) = switch (status) {
      StatusType.synced => (ext.successContainer ?? cs.primaryContainer, ext.onSuccessContainer ?? cs.onPrimaryContainer, 'synced'),
      StatusType.pending => (cs.secondaryContainer, cs.onSecondaryContainer, 'pending'),
      StatusType.offline => (cs.surfaceContainerHighest, cs.onSurfaceVariant, 'offline'),
      StatusType.error => (cs.errorContainer, cs.onErrorContainer, 'error'),
      StatusType.open => (cs.secondaryContainer, cs.onSecondaryContainer, 'open'),
      StatusType.partiallyPaid => (ext.warningContainer ?? cs.tertiaryContainer, ext.onWarningContainer ?? cs.onTertiaryContainer, 'partiallyPaid'),
      StatusType.closed => (ext.successContainer ?? cs.primaryContainer, ext.onSuccessContainer ?? cs.onPrimaryContainer, 'closed'),
    };

    return Chip(
      visualDensity: compact ? VisualDensity.compact : VisualDensity.standard,
      backgroundColor: bgColor,
      padding: compact
          ? const EdgeInsets.symmetric(horizontal: 4, vertical: 0)
          : const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      label: Text(
        _localizedLabel(context, label),
        style: (compact ? tt.labelSmall : tt.labelMedium)?.copyWith(
          color: fgColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _localizedLabel(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;
    return switch (key) {
      'synced' => l10n.synced,
      'pending' => l10n.pending,
      'offline' => l10n.offline,
      'error' => l10n.error,
      'open' => l10n.open,
      'partiallyPaid' => l10n.partiallyPaid,
      'closed' => l10n.closed,
      _ => key,
    };
  }
}

enum StatusType {
  synced,
  pending,
  offline,
  error,
  open,
  partiallyPaid,
  closed,
}