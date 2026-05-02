import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:market_connect/src/core/data/models/farmer_model.dart';
import 'package:market_connect/src/core/data/models/sync_queue_entry_model.dart';
import 'package:market_connect/src/core/data/remote/farmer_remote_data_source.dart';
import 'package:market_connect/src/core/data/repositories/farmer_repository.dart';
import 'package:market_connect/src/services/hive_service.dart';
import 'package:market_connect/src/services/internet_connection_service.dart';
import 'package:mocktail/mocktail.dart';

class MockFarmerRemoteDataSource extends Mock
    implements FarmerRemoteDataSource {}

class MockHiveService extends Mock implements HiveService {}

class MockInternetConnectionService extends Mock
    implements InternetConnectionService {}

class FakeFarmerModel extends Fake implements FarmerModel {}

class FakeSyncQueueEntryModel extends Fake implements SyncQueueEntryModel {}

void main() {
  late FarmerRepository repository;
  late MockFarmerRemoteDataSource mockRemote;
  late MockHiveService mockLocal;
  late MockInternetConnectionService mockNetwork;

  final testFarmer = FarmerModel(
    id: 1,
    cardId: 'FM-1234',
    name: 'Test Farmer',
    phone: '+225 01 23 45 67',
    village: 'Test Village',
    creditLimit: 50000,
    creditBalanceFcfa: 0,
    createdAt: DateTime(2026, 5, 1),
  );

  setUpAll(() {
    registerFallbackValue(FakeFarmerModel());
    registerFallbackValue(FakeSyncQueueEntryModel());
  });

  setUp(() {
    mockRemote = MockFarmerRemoteDataSource();
    mockLocal = MockHiveService();
    mockNetwork = MockInternetConnectionService();
    repository = FarmerRepository(
      remote: mockRemote,
      local: mockLocal,
      network: mockNetwork,
    );
  });

  group('getAll (farmers)', () {
    test('returns farmers from API when online and caches them', () async {
      when(() => mockNetwork.hasConnection()).thenAnswer((_) async => true);
      when(() => mockRemote.getFarmers())
          .thenAnswer((_) async => right([testFarmer]));
      when(() => mockLocal.saveFarmers(any()))
          .thenAnswer((_) async => right(null));

      final result = await repository.getAll();

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected Right'),
        (farmers) {
          expect(farmers.length, 1);
          expect(farmers.first.name, 'Test Farmer');
        },
      );
      verify(() => mockLocal.saveFarmers(any())).called(1);
    });

    test('returns cached farmers when offline', () async {
      when(() => mockNetwork.hasConnection()).thenAnswer((_) async => false);
      when(() => mockLocal.getFarmers()).thenReturn([testFarmer]);

      final result = await repository.getAll();

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected Right'),
        (farmers) => expect(farmers.first.name, 'Test Farmer'),
      );
      verifyNever(() => mockRemote.getFarmers());
    });

    test('returns CacheFailure when offline and no cache', () async {
      when(() => mockNetwork.hasConnection()).thenAnswer((_) async => false);
      when(() => mockLocal.getFarmers()).thenReturn([]);

      final result = await repository.getAll();

      expect(result.isLeft(), true);
    });
  });

  group('createFarmer', () {
    test('creates farmer via API when online', () async {
      when(() => mockNetwork.hasConnection()).thenAnswer((_) async => true);
      when(() => mockRemote.createFarmer(any()))
          .thenAnswer((_) async => right(testFarmer));
      when(() => mockLocal.saveFarmer(any()))
          .thenAnswer((_) async => right(null));

      final result = await repository.createFarmer({
        'card_id': 'FM-1234',
        'name': 'Test Farmer',
      });

      expect(result.isRight(), true);
      verify(() => mockRemote.createFarmer(any())).called(1);
    });

    test('creates local farmer and queues sync when offline', () async {
      when(() => mockNetwork.hasConnection()).thenAnswer((_) async => false);
      when(() => mockLocal.saveFarmer(any()))
          .thenAnswer((_) async => right(null));
      when(() => mockLocal.enqueue(any()))
          .thenAnswer((_) async => right(null));

      final result = await repository.createFarmer({
        'card_id': 'FM-1234',
        'name': 'Test Farmer',
      });

      expect(result.isRight(), true);
      verify(() => mockLocal.saveFarmer(any())).called(1);
      verify(() => mockLocal.enqueue(any())).called(1);
      verifyNever(() => mockRemote.createFarmer(any()));
    });
  });
}
