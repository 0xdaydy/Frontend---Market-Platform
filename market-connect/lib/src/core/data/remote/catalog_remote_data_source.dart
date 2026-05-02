import '../../../imports/core_imports.dart';
import '../../../imports/packages_imports.dart';

import '../models/models.dart';

/// Remote data source for catalog (products & categories) API operations.
class CatalogRemoteDataSource {
  final DioService _dio = DioService.instance;

  FutureEither<List<CategoryModel>> getCategories() async {
    final result = await _dio.get('/categories');
    return result.flatMap((response) {
      final data = response.data as Map<String, dynamic>;
      final list = (data['data'] ?? data) as List<dynamic>;
      final categories = list
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(categories);
    });
  }

  FutureEither<List<ProductModel>> getProducts() async {
    final result = await _dio.get('/products');
    return result.flatMap((response) {
      final data = response.data as Map<String, dynamic>;
      final list = (data['data'] ?? data) as List<dynamic>;
      final products = list
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(products);
    });
  }

  FutureEither<List<ProductModel>> getProductsByCategory(int categoryId) async {
    final result = await _dio.get('/categories/$categoryId/products');
    return result.flatMap((response) {
      final data = response.data as Map<String, dynamic>;
      final list = (data['data'] ?? data) as List<dynamic>;
      final products = list
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(products);
    });
  }
}
