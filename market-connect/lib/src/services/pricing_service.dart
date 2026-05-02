/// Service for pricing calculations on the frontend.
///
/// Centralizes interest and total computation so it's not duplicated
/// across screens. The interest rate is configurable and defaults to 5%.
///
/// For production, the rate should be synced from the backend `/settings` endpoint.
class PricingService {
  final double _interestRate;

  const PricingService({double interestRate = 0.05}) : _interestRate = interestRate;

  double get interestRate => _interestRate;

  /// Calculate the total due for a purchase.
  double calculateTotal(double subtotal, {bool isCredit = false}) {
    if (!isCredit) return subtotal;
    return subtotal + calculateInterest(subtotal);
  }

  /// Calculate the interest amount for a subtotal.
  double calculateInterest(double subtotal) {
    return subtotal * _interestRate;
  }
}
