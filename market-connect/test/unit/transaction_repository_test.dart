import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:market_connect/src/core/data/models/sync_queue_entry_model.dart';
import 'package:market_connect/src/core/data/models/transaction_item_model.dart';
import 'package:market_connect/src/core/data/models/transaction_model.dart';
import 'package:market_connect/src/core/data/remote/transaction_remote_data_source.dart';
import 'package:market_connect/src/core/data/repositories/transaction_repository.dart';
import 'package:market_connect/src/services/hive_service.dart';
import 'package:market_connect/src/services/internet_connection_service.dart';
import 'package:mocktail/mocktail.dart';

class MockTransactionRemoteDataSource extends Mock
    implements TransactionRemoteDataSource {}

class MockHiveService extends Mock implements HiveService {}

class MockInternetConnectionService extends Mock
    implements InternetConnectionService {}

class FakeTransactionModel extends Fake implements TransactionModel {}

class FakeSyncQueueEntryModel extends Fake implements SyncQueueEntryModel {}

void main() {
  late TransactionRepository repository;
  late MockTransactionRemoteDataSource mockRemote;
  late MockHiveService mockLocal;
  late MockInternetConnectionService mockNetwork;

  const testItem = TransactionItemModel(
    productId: 1,
    productName: 'Riz',
    quantity: 2,
    unitPrice: 500,
    lineTotal: 1000,
  );

  final testTransaction = TransactionModel(
    id: 1,
    reference: 'TXN-20260501-0001',
    farmerId: 1,
    farmerName: 'Test Farmer',
    paymentMethod: 'cash',
    totalAmount: 1000,
    items: const [testItem],
    createdAt: DateTime(2026, 5, 1),
    isSynced: true,
  );

  setUpAll(() {
    registerFallbackValue(FakeTransactionModel());
    registerFallbackValue(FakeSyncQueueEntryModel());
  });

  setUp(() {
    mockRemote = MockTransactionRemoteDataSource();
    mockLocal = MockHiveService();
    mockNetwork = MockInternetConnectionService();
    repository = TransactionRepository(
      remote: mockRemote,
      local: mockLocal,
      network: mockNetwork,
    );
  });

  group('getAll (transactions)', () {
    test('returns transactions from API when online and caches them', () async {
      when(() => mockNetwork.hasConnection()).thenAnswer((_) async => true);
      when(() => mockRemote.getTransactions())
          .thenAnswer((_) async => right([testTransaction]));
      when(() => mockLocal.saveTransactions(any()))
          .thenAnswer((_) async => right(null));

      final result = await repository.getAll();

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected Right'),
        (transactions) {
          expect(transactions.length, 1);
          expect(transactions.first.reference, 'TXN-20260501-0001');
        },
      );
      verify(() => mockLocal.saveTransactions(any())).called(1);
    });

    test('returns cached transactions when offline', () async {
      when(() => mockNetwork.hasConnection()).thenAnswer((_) async => false);
      when(() => mockLocal.getTransactions()).thenReturn([testTransaction]);

      final result = await repository.getAll();

      expect(result.isRight(), true);
      verifyNever(() => mockRemote.getTransactions());
    });
  });

  group('createTransaction', () {
    test('creates transaction via API when online', () async {
      when(() => mockNetwork.hasConnection()).thenAnswer((_) async => true);
      when(() => mockRemote.createTransaction(any()))
          .thenAnswer((_) async => right(testTransaction));
      when(() => mockLocal.saveTransaction(any()))
          .thenAnswer((_) async => right(null));

      final result = await repository.createTransaction({
        'farmer_id': 1,
        'farmer_name': 'Test Farmer',
        'payment_method': 'cash',
        'total_amount': 1000,
        'items': [
          {
            'product_id': 1,
            'product_name': 'Riz',
            'quantity': 2,
            'unit_price': 500,
          }
        ],
      });

      expect(result.isRight(), true);
      verify(() => mockRemote.createTransaction(any())).called(1);
    });

    test('creates local transaction and queues sync when offline', () async {
      when(() => mockNetwork.hasConnection()).thenAnswer((_) async => false);
      when(() => mockLocal.saveTransaction(any()))
          .thenAnswer((_) async => right(null));
      when(() => mockLocal.enqueue(any())).thenAnswer((_) async => right(null));

      final result = await repository.createTransaction({
        'farmer_id': 1,
        'farmer_name': 'Test Farmer',
        'payment_method': 'cash',
        'total_amount': 1000,
        'items': [
          {
            'product_id': 1,
            'product_name': 'Riz',
            'quantity': 2,
            'unit_price': 500,
          }
        ],
      });

      expect(result.isRight(), true);
      verify(() => mockLocal.saveTransaction(any())).called(1);
      verify(() => mockLocal.enqueue(any())).called(1);
      verifyNever(() => mockRemote.createTransaction(any()));
    });
  });
}
