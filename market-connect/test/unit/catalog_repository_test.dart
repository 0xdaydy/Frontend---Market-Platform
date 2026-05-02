import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:market_connect/src/core/data/models/category_model.dart';
import 'package:market_connect/src/core/data/models/product_model.dart';
import 'package:market_connect/src/core/data/remote/catalog_remote_data_source.dart';
import 'package:market_connect/src/core/data/repositories/catalog_repository.dart';
import 'package:market_connect/src/services/hive_service.dart';
import 'package:market_connect/src/services/internet_connection_service.dart';
import 'package:mocktail/mocktail.dart';

class MockCatalogRemoteDataSource extends Mock
    implements CatalogRemoteDataSource {}

class MockHiveService extends Mock implements HiveService {}

class MockInternetConnectionService extends Mock
    implements InternetConnectionService {}

class FakeCategoryModel extends Fake implements CategoryModel {}

class FakeProductModel extends Fake implements ProductModel {}

void main() {
  late CatalogRepository repository;
  late MockCatalogRemoteDataSource mockRemote;
  late MockHiveService mockLocal;
  late MockInternetConnectionService mockNetwork;

  final testCategory = CategoryModel(
    id: 1,
    name: 'Céréales',
    createdAt: DateTime(2026, 5, 1),
  );

  final testProduct = ProductModel(
    id: 1,
    name: 'Riz',
    categoryId: 1,
    categoryName: 'Céréales',
    priceFcfa: 500,
    createdAt: DateTime(2026, 5, 1),
  );

  setUpAll(() {
    registerFallbackValue(FakeCategoryModel());
    registerFallbackValue(FakeProductModel());
  });

  setUp(() {
    mockRemote = MockCatalogRemoteDataSource();
    mockLocal = MockHiveService();
    mockNetwork = MockInternetConnectionService();
    repository = CatalogRepository(
      remote: mockRemote,
      local: mockLocal,
      network: mockNetwork,
    );
  });

  group('getAll (categories)', () {
    test('returns categories from API when online and caches them', () async {
      when(() => mockNetwork.hasConnection()).thenAnswer((_) async => true);
      when(() => mockRemote.getCategories())
          .thenAnswer((_) async => right([testCategory]));
      when(() => mockLocal.saveCategories(any()))
          .thenAnswer((_) async => right(null));

      final result = await repository.getAll();

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected Right'),
        (categories) {
          expect(categories.length, 1);
          expect(categories.first.name, 'Céréales');
        },
      );
      verify(() => mockLocal.saveCategories(any())).called(1);
    });

    test('returns cached categories when offline', () async {
      when(() => mockNetwork.hasConnection()).thenAnswer((_) async => false);
      when(() => mockLocal.getCategories()).thenReturn([testCategory]);

      final result = await repository.getAll();

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected Right'),
        (categories) => expect(categories.first.name, 'Céréales'),
      );
      verifyNever(() => mockRemote.getCategories());
    });

    test('returns CacheFailure when offline and no cache', () async {
      when(() => mockNetwork.hasConnection()).thenAnswer((_) async => false);
      when(() => mockLocal.getCategories()).thenReturn([]);

      final result = await repository.getAll();

      expect(result.isLeft(), true);
    });
  });

  group('getProducts', () {
    test('returns products from API when online and caches them', () async {
      when(() => mockNetwork.hasConnection()).thenAnswer((_) async => true);
      when(() => mockRemote.getProducts())
          .thenAnswer((_) async => right([testProduct]));
      when(() => mockLocal.saveProducts(any()))
          .thenAnswer((_) async => right(null));

      final result = await repository.getProducts();

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected Right'),
        (products) {
          expect(products.length, 1);
          expect(products.first.name, 'Riz');
        },
      );
      verify(() => mockLocal.saveProducts(any())).called(1);
    });

    test('returns cached products when offline', () async {
      when(() => mockNetwork.hasConnection()).thenAnswer((_) async => false);
      when(() => mockLocal.getProducts()).thenReturn([testProduct]);

      final result = await repository.getProducts();

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected Right'),
        (products) => expect(products.first.name, 'Riz'),
      );
      verifyNever(() => mockRemote.getProducts());
    });
  });

  group('getProductsByCategory', () {
    test('returns products by category from API when online', () async {
      when(() => mockNetwork.hasConnection()).thenAnswer((_) async => true);
      when(() => mockRemote.getProductsByCategory(1))
          .thenAnswer((_) async => right([testProduct]));
      when(() => mockLocal.saveProducts(any()))
          .thenAnswer((_) async => right(null));

      final result = await repository.getProductsByCategory(1);

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected Right'),
        (products) => expect(products.first.categoryId, 1),
      );
    });

    test('returns cached products by category when offline', () async {
      when(() => mockNetwork.hasConnection()).thenAnswer((_) async => false);
      when(() => mockLocal.getProductsByCategory(1))
          .thenReturn([testProduct]);

      final result = await repository.getProductsByCategory(1);

      expect(result.isRight(), true);
      verifyNever(() => mockRemote.getProductsByCategory(any()));
    });
  });
}
