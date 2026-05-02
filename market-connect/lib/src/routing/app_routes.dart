/// Centralized route path constants for GoRouter.
///
/// Use these variables instead of raw strings throughout the app.
abstract final class AppRoutes {
  AppRoutes._();

  // Auth
  static const String login = '/login';

  // Main tabs (inside ShellRoute)
  static const String home = '/';
  static const String catalogue = '/catalogue';
  static const String producteurs = '/producteurs';
  static const String credit = '/credit';

  // Non-tab screens
  static const String syncLoader = '/sync-loader';
  static const String farmerDetail = '/farmer';
  static const String checkout = '/checkout';
  static const String transactionConfirmation = '/transaction-confirmation';
  static const String transactionDetail = '/transaction';
  static const String recordRepayment = '/record-repayment';
  static const String repaymentConfirmation = '/repayment-confirmation';
  static const String syncIssues = '/sync-issues';
  static const String settings = '/settings';
  static const String farmerRegistration = '/farmer-registration';
  static const String productDetail = '/product';
  static const String debtDetail = '/debt';
}