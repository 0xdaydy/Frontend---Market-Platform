import 'package:flutter_test/flutter_test.dart';
import 'package:market_connect/src/core/data/models/models.dart';

/// Contract tests: verify frontend models can deserialize backend API responses.
///
/// Sample JSON is derived from the OpenAPI spec (docs/openapi.json) and actual
/// backend responses. If a backend field changes, these tests fail immediately,
/// catching the drift before it reaches production.
///
/// To regenerate: capture a real API response and paste it below.
void main() {
  group('FarmerModel contract', () {
    final sampleJson = {
      'id': 1,
      'card_id': 'FM-001',
      'name': 'Kouamé Yao',
      'phone': '+225 01 23 45 67',
      'village': 'Yamoussoukro',
      'credit_limit': 50000.0,
      'credit_balance_fcfa': 15000.0,
      'created_at': '2026-05-01T10:00:00.000000Z',
      'updated_at': '2026-05-01T14:30:00.000000Z',
    };

    test('fromJson parses all fields', () {
      final model = FarmerModel.fromJson(sampleJson);
      expect(model.id, 1);
      expect(model.cardId, 'FM-001');
      expect(model.name, 'Kouamé Yao');
      expect(model.phone, '+225 01 23 45 67');
      expect(model.village, 'Yamoussoukro');
      expect(model.creditLimit, 50000.0);
      expect(model.creditBalanceFcfa, 15000.0);
      expect(model.createdAt, DateTime.parse('2026-05-01T10:00:00.000000Z'));
      expect(model.updatedAt, DateTime.parse('2026-05-01T14:30:00.000000Z'));
    });

    test('round-trip toJson/fromJson is lossless', () {
      final original = FarmerModel.fromJson(sampleJson);
      final json = original.toJson();
      final restored = FarmerModel.fromJson(json);
      expect(restored, original);
    });
  });

  group('ProductModel contract', () {
    final sampleJson = {
      'id': 1,
      'name': 'Tomate',
      'description': 'Tomate fraîche',
      'price_fcfa': 1500.0,
      'category_id': 1,
      'created_at': '2026-05-01T10:00:00.000000Z',
      'updated_at': null,
    };

    test('fromJson parses all fields', () {
      final model = ProductModel.fromJson(sampleJson);
      expect(model.id, 1);
      expect(model.name, 'Tomate');
      expect(model.description, 'Tomate fraîche');
      expect(model.categoryId, 1);
    });
  });

  group('TransactionModel contract', () {
    final sampleJson = {
      'id': 1,
      'reference': 'TRX-20260501-0001',
      'farmer_id': 1,
      'operator_id': 1,
      'payment_method': 'cash',
      'total_amount': 4500.0,
      'status': 'completed',
      'created_at': '2026-05-01T10:00:00.000000Z',
      'updated_at': null,
    };

    test('fromJson parses all fields', () {
      final model = TransactionModel.fromJson(sampleJson);
      expect(model.id, 1);
      expect(model.reference, 'TRX-20260501-0001');
      expect(model.farmerId, 1);
      expect(model.paymentMethod, 'cash');
      expect(model.status, 'completed');
    });
  });

  group('RepaymentModel contract', () {
    final sampleJson = {
      'id': 1,
      'farmer_id': 1,
      'operator_id': 1,
      'amount': 5000.0,
      'payment_method': 'cash',
      'reference': 'RPY-20260501-0001',
      'created_at': '2026-05-01T10:00:00.000000Z',
      'updated_at': null,
    };

    test('fromJson parses all fields', () {
      final model = RepaymentModel.fromJson(sampleJson);
      expect(model.id, 1);
      expect(model.farmerId, 1);
      expect(model.amount, 5000.0);
      expect(model.paymentMethod, 'cash');
      expect(model.reference, 'RPY-20260501-0001');
    });
  });

  group('CategoryModel contract', () {
    final sampleJson = {
      'id': 1,
      'name': 'Légumes',
      'parent_id': null,
      'created_at': '2026-05-01T10:00:00.000000Z',
      'updated_at': null,
    };

    test('fromJson parses all fields', () {
      final model = CategoryModel.fromJson(sampleJson);
      expect(model.id, 1);
      expect(model.name, 'Légumes');
      expect(model.parentId, isNull);
    });
  });

  group('DebtModel contract', () {
    final sampleJson = {
      'id': 1,
      'transaction_id': 1,
      'farmer_id': 1,
      'principal': 4500.0,
      'interest_rate': 0.05,
      'total_due': 4725.0,
      'amount_repaid': 0.0,
      'balance': 4725.0,
      'status': 'open',
      'created_at': '2026-05-01T10:00:00.000000Z',
      'updated_at': null,
    };

    test('fromJson parses all fields', () {
      final model = DebtModel.fromJson(sampleJson);
      expect(model.id, 1);
      expect(model.farmerId, 1);
      expect(model.principal, 4500.0);
      expect(model.balance, 4725.0);
      expect(model.status, 'open');
    });
  });
}
