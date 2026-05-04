import 'package:market_connect/src/features/auth/presentation/providers/auth_provider.dart';
import 'package:market_connect/src/imports/core_imports.dart';
import 'package:market_connect/src/imports/packages_imports.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlobalKey<FormState> formKey =
        useMemoized(() => GlobalKey<FormState>());
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final obscurePassword = useState(true);
    final rememberMe = useState(true);

    final authAsync = ref.watch(authControllerProvider);
    final isLoading = authAsync.isLoading;

    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    Future<void> handleLogin() async {
      if (!(formKey.currentState?.validate() ?? false)) {
        return;
      }

      ref.read(authControllerProvider.notifier).login(
            email: emailController.text,
            password: passwordController.text,
          );
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: AppSpacing.xl.h),
                // Logo
                Container(
                  width: 64.w,
                  height: 64.w,
                  decoration: BoxDecoration(
                    color: cs.primary,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Center(
                    child: Text(
                      'M',
                      style: tt.headlineMedium?.copyWith(
                        color: cs.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.lg.h),
                Text(
                  l10n.loginTitle,
                  style: tt.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.02,
                  ),
                ),
                SizedBox(height: AppSpacing.sm.h),
                Text(
                  l10n.loginSubtitle,
                  textAlign: TextAlign.center,
                  style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                ),
                SizedBox(height: AppSpacing.xxxl.h),
                // Form
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Email
                      Text(
                        l10n.emailLabel,
                        style: tt.labelMedium?.copyWith(
                          color: cs.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xs.h),
                      TextFormField(
                        controller: emailController,
                        enabled: !isLoading,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: l10n.emailHint,
                          prefixIcon: const Icon(Icons.email_outlined),
                        ),
                        validator: (v) {
                          if (AppUtils.isBlank(v)) {
                            return l10n.requiredField;
                          }
                          if (!AppUtils.isValidEmail(v!)) {
                            return l10n.invalidEmail;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: AppSpacing.md.h),
                      // Password
                      Text(
                        l10n.passwordLabel,
                        style: tt.labelMedium?.copyWith(
                          color: cs.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xs.h),
                      TextFormField(
                        controller: passwordController,
                        enabled: !isLoading,
                        obscureText: obscurePassword.value,
                        decoration: InputDecoration(
                          hintText: l10n.passwordHint,
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(obscurePassword.value
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () =>
                                obscurePassword.value = !obscurePassword.value,
                          ),
                        ),
                        validator: (v) {
                          if (AppUtils.isBlank(v)) {
                            return l10n.requiredField;
                          }
                          if (v!.length < 6) {
                            return l10n.minLength(6);
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: AppSpacing.sm.h),
                      // Remember me
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 20.w,
                                height: 20.w,
                                child: Checkbox(
                                  value: rememberMe.value,
                                  onChanged: (value) =>
                                      rememberMe.value = value ?? true,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                l10n.rememberMe,
                                style: tt.bodySmall
                                    ?.copyWith(color: cs.onSurfaceVariant),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.lg.h),
                      // Sign In button
                      SizedBox(
                        width: double.infinity,
                        height: 56.h,
                        child: FilledButton(
                          onPressed: isLoading ? null : handleLogin,
                          child: isLoading
                              ? SizedBox(
                                  width: 20.w,
                                  height: 20.w,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: cs.onPrimary,
                                  ),
                                )
                              : Text(
                                  l10n.signIn,
                                  style: tt.labelLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: cs.surface,
                                    fontSize: 14.sp,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: AppSpacing.md.h),
                      // Forgot password
                      Center(
                        child: TextButton(
                          onPressed: () {
                            // Not in MVP spec
                          },
                          child: Text(
                            l10n.forgotPassword,
                            style: tt.bodySmall?.copyWith(
                              color: cs.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
