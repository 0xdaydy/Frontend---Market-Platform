import 'package:market_connect/src/imports/core_imports.dart';
import 'package:market_connect/src/imports/packages_imports.dart';

import '../../../auth/presentation/providers/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    final isLoading = ref.watch(authControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Appearance
              Text(l10n.appearance, style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              SizedBox(height: 8.h),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      title: Text(l10n.theme),
                      trailing: SegmentedButton<String>(
                        segments: [
                          ButtonSegment(value: 'light', label: Text(l10n.light)),
                          ButtonSegment(value: 'dark', label: Text(l10n.dark)),
                        ],
                        selected: const {'light'},
                        onSelectionChanged: (_) {},
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              // Language
              Text(l10n.language, style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              SizedBox(height: 8.h),
              Card(
                child: RadioGroup<String>(
                  groupValue: 'fr',
                  onChanged: (_) {},
                  child: Column(
                    children: [
                      RadioListTile<String>(
                        title: Text(l10n.french),
                        value: 'fr',
                      ),
                      RadioListTile<String>(
                        title: Text(l10n.english),
                        value: 'en',
                      ),
                      RadioListTile<String>(
                        title: Text(l10n.arabic),
                        value: 'ar',
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              // Sync
              Text(l10n.syncTitle, style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              SizedBox(height: 8.h),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      title: Text('${l10n.lastSync}: 01/05/2026 14:30'),
                      trailing: TextButton(
                        onPressed: () => context.push(AppRoutes.syncIssues),
                        child: Text(l10n.syncNow),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              // Account
              Text(l10n.account, style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              SizedBox(height: 8.h),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      title: Text(l10n.changePassword),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    ListTile(
                      title: Text(l10n.logout),
                      trailing: isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: cs.primary,
                              ),
                            )
                          : const Icon(Icons.logout),
                      onTap: isLoading
                          ? null
                          : () => ref.read(authControllerProvider.notifier).logout(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              // About
              Center(
                child: Text(
                  '${l10n.appName} ${l10n.appVersion}',
                  style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
