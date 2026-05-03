import '../../../imports/core_imports.dart';
import '../../../imports/packages_imports.dart';

import '../../../utils/utils.dart';
import '../models/models.dart';
import '../remote/catalog_remote_data_source.dart';
import 'offline_first_repository.dart';

/// Repository for catalog operations with offline-first strategy.
class CatalogRepository extends OfflineFirstRepository<CategoryModel> {
  final CatalogRemoteDataSource _remote;

  // Also manage products through the same repo
  CatalogRepository({
    CatalogRemoteDataSource? remote,
    super.network,
    super.local,
  }) : _remote = remote ?? CatalogRemoteDataSource();

  // --- Categories ---

  @override
  FutureEither<List<CategoryModel>> fetchRemote() => _remote.getCategories();

  @override
  FutureEither<void> saveLocal(List<CategoryModel> items) => local.saveCategories(items);

  @override
  List<CategoryModel> getLocal() => local.getCategories();

  @override
  String get cacheFailureMessage => 'No categories available offline';

  // --- Products ---

  FutureEither<List<ProductModel>> getProducts() async {
    if (await network.hasConnection()) {
      final result = await _remote.getProducts();
      await result.fold(
        (failure) async => AppLogger.warning('Failed to fetch products remotely: ${failure.message}'),
        (products) async {
          final saveResult = await local.saveProducts(products);
          saveResult.fold(
            (f) => AppLogger.warning('Failed to cache products: ${f.message}'),
            (_) {},
          );
        },
      );
      return result;
    }

    final cached = local.getProducts();
    if (cached.isNotEmpty) {
      return right(cached);
    }
    return left(const CacheFailure('No products available offline'));
  }

  FutureEither<List<ProductModel>> getProductsByCategory(int categoryId) async {
    if (await network.hasConnection()) {
      final result = await _remote.getProductsByCategory(categoryId);
      await result.fold(
        (failure) async => AppLogger.warning('Failed to fetch products for category $categoryId: ${failure.message}'),
        (products) async {
          final saveResult = await local.saveProducts(products);
          saveResult.fold(
            (f) => AppLogger.warning('Failed to cache products for category $categoryId: ${f.message}'),
            (_) {},
          );
        },
      );
      return result;
    }

    final cached = local.getProductsByCategory(categoryId);
    return right(cached);
  }
}
