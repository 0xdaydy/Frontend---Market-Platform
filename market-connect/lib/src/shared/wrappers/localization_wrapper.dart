import '../../imports/core_imports.dart';

/// A wrapper that previously initialized EasyLocalization.
/// Now localization is handled directly by MaterialApp.
class LocalizationWrapper extends StatelessWidget {
  final Widget child;

  const LocalizationWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}