import 'package:market_connect/src/imports/core_imports.dart';
import 'package:market_connect/src/imports/packages_imports.dart';

class FarmerRegistrationScreen extends StatelessWidget {
  const FarmerRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.farmerRegistration)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: l10n.fullName),
              ),
              SizedBox(height: 16.h),
              TextFormField(
                decoration: InputDecoration(labelText: l10n.cardNumber),
              ),
              SizedBox(height: 16.h),
              TextFormField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: l10n.phone),
              ),
              SizedBox(height: 16.h),
              TextFormField(
                decoration: InputDecoration(labelText: l10n.location),
              ),
              SizedBox(height: 16.h),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.creditLimitOptional,
                ),
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: FilledButton(
                  onPressed: () => context.pop(),
                  child: Text(l10n.save),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}