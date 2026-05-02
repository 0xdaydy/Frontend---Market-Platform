import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:market_connect/src/core/data/models/repayment_model.dart';
import 'package:market_connect/src/core/data/models/sync_queue_entry_model.dart';
import 'package:market_connect/src/core/data/remote/repayment_remote_data_source.dart';
import 'package:market_connect/src/core/data/repositories/repayment_repository.dart';
import 'package:market_connect/src/services/hive_service.dart';
import 'package:market_connect/src/services/internet_connection_service.dart';
import 'package:mocktail/mocktail.dart';

class MockRepaymentRemoteDataSource extends Mock
    implements RepaymentRemoteDataSource {}

class MockHiveService extends Mock implements HiveService {}

class MockInternetConnectionService extends Mock
    implements InternetConnectionService {}

class FakeRepaymentModel extends Fake implements RepaymentModel {}

class FakeSyncQueueEntryModel extends Fake implements SyncQueueEntryModel {}

void main() {
  late RepaymentRepository repository;
  late MockRepaymentRemoteDataSource mockRemote;
  late MockHiveService mockLocal;
  late MockInternetConnectionService mockNetwork;

  final testRepayment = RepaymentModel(
    id: 1,
    farmerId: 1,
    farmerName: 'Test Farmer',
    amount: 5000,
    paymentMethod: 'cash',
    reference: 'RPY-20260501-0001',
    createdAt: DateTime(2026, 5, 1),
    isSynced: true,
  );

  setUpAll(() {
    registerFallbackValue(FakeRepaymentModel());
    registerFallbackValue(FakeSyncQueueEntryModel());
  });

  setUp(() {
    mockRemote = MockRepaymentRemoteDataSource();
    mockLocal = MockHiveService();
    mockNetwork = MockInternetConnectionService();
    repository = RepaymentRepository(
      remote: mockRemote,
      local: mockLocal,
      network: mockNetwork,
    );
  });

  group('getAll (repayments)', () {
    test('returns repayments from API when online and caches them', () async {
      when(() => mockNetwork.hasConnection()).thenAnswer((_) async => true);
      when(() => mockRemote.getRepayments())
          .thenAnswer((_) async => right([testRepayment]));
      when(() => mockLocal.saveRepayments(any()))
          .thenAnswer((_) async => right(null));

      final result = await repository.getAll();

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected Right'),
        (repayments) {
          expect(repayments.length, 1);
          expect(repayments.first.reference, 'RPY-20260501-0001');
        },
      );
      verify(() => mockLocal.saveRepayments(any())).called(1);
    });

    test('returns cached repayments when offline', () async {
      when(() => mockNetwork.hasConnection()).thenAnswer((_) async => false);
      when(() => mockLocal.getRepayments()).thenReturn([testRepayment]);

      final result = await repository.getAll();

      expect(result.isRight(), true);
      verifyNever(() => mockRemote.getRepayments());
    });
  });

  group('createRepayment', () {
    test('creates repayment via API when online', () async {
      when(() => mockNetwork.hasConnection()).thenAnswer((_) async => true);
      when(() => mockRemote.createRepayment(any()))
          .thenAnswer((_) async => right(testRepayment));
      when(() => mockLocal.saveRepayments(any()))
          .thenAnswer((_) async => right(null));

      final result = await repository.createRepayment({
        'farmer_id': 1,
        'farmer_name': 'Test Farmer',
        'amount': 5000,
        'payment_method': 'cash',
      });

      expect(result.isRight(), true);
      verify(() => mockRemote.createRepayment(any())).called(1);
    });

    test('creates local repayment and queues sync when offline', () async {
      when(() => mockNetwork.hasConnection()).thenAnswer((_) async => false);
      when(() => mockLocal.saveRepayments(any()))
          .thenAnswer((_) async => right(null));
      when(() => mockLocal.enqueue(any()))
          .thenAnswer((_) async => right(null));

      final result = await repository.createRepayment({
        'farmer_id': 1,
        'farmer_name': 'Test Farmer',
        'amount': 5000,
        'payment_method': 'cash',
      });

      expect(result.isRight(), true);
      verify(() => mockLocal.saveRepayments(any())).called(1);
      verify(() => mockLocal.enqueue(any())).called(1);
      verifyNever(() => mockRemote.createRepayment(any()));
    });
  });
}
