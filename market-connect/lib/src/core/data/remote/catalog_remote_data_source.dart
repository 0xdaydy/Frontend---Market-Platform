import '../../../imports/core_imports.dart';
import '../../../imports/packages_imports.dart';
import '../models/models.dart';

/// Remote data source for catalog (products & categories) API operations.
class CatalogRemoteDataSource {
  final DioService _dio = DioService.instance;

  FutureEither<List<CategoryModel>> getCategories() async {
    final result = await _dio.get('/categories');
    return result.flatMap((response) {
      try {
        final list = switch (response.data) {
          final List<dynamic> l => l,
          final Map<String, dynamic> m =>
            m.jsonList('data', fallbackKeys: const ['categories']),
          _ => throw const FormatException('Expected Map or List response'),
        };
        final categories = list
            .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return right(categories);
      } catch (e, st) {
        AppLogger.error(
            'CatalogRemoteDataSource: Failed to parse getCategories: $e',
            [e, st]);
        return left(ServerFailure('Failed to parse categories: $e', error: e));
      }
    });
  }

  FutureEither<List<ProductModel>> getProducts() async {
    final result = await _dio.get('/products');
    return result.flatMap((response) {
      try {
        final list = switch (response.data) {
          final List<dynamic> l => l,
          final Map<String, dynamic> m =>
            m.jsonList('data', fallbackKeys: const ['products']),
          _ => throw const FormatException('Expected Map or List response'),
        };
        final products = list
            .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return right(products);
      } catch (e, st) {
        AppLogger.error(
            'CatalogRemoteDataSource: Failed to parse getProducts: $e',
            [e, st]);
        return left(ServerFailure('Failed to parse products: $e', error: e));
      }
    });
  }

  FutureEither<List<ProductModel>> getProductsByCategory(int categoryId) async {
    final result = await _dio.get('/categories/$categoryId/products');
    return result.flatMap((response) {
      try {
        final list = switch (response.data) {
          final List<dynamic> l => l,
          final Map<String, dynamic> m =>
            m.jsonList('data', fallbackKeys: const ['products']),
          _ => throw const FormatException('Expected Map or List response'),
        };
        final products = list
            .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return right(products);
      } catch (e, st) {
        AppLogger.error(
            'CatalogRemoteDataSource: Failed to parse getProductsByCategory: $e',
            [e, st]);
        return left(ServerFailure('Failed to parse products: $e', error: e));
      }
    });
  }
}
