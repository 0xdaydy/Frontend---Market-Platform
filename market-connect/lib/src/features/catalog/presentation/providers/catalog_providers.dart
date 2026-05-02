import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/data/models/models.dart';
import '../../../../core/data/repositories/catalog_repository.dart';
import '../../../../utils/utils.dart';

// Repository provider
final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  return CatalogRepository();
});

// Categories provider
final categoriesProvider = FutureProvider<List<CategoryModel>>((ref) async {
  final repo = ref.watch(catalogRepositoryProvider);
  return (await repo.getAll()).getOrThrow;
});

// Products provider
final productsProvider = FutureProvider<List<ProductModel>>((ref) async {
  final repo = ref.watch(catalogRepositoryProvider);
  return (await repo.getProducts()).getOrThrow;
});

// Products by category provider
final productsByCategoryProvider = FutureProvider.family<List<ProductModel>, int>((ref, categoryId) async {
  final repo = ref.watch(catalogRepositoryProvider);
  return (await repo.getProductsByCategory(categoryId)).getOrThrow;
});

// Search products provider
final searchedProductsProvider = FutureProvider.family<List<ProductModel>, String>((ref, query) async {
  final productsAsync = ref.watch(productsProvider);
  return productsAsync.when(
    data: (products) {
      if (query.isEmpty) return products;
      final lowerQuery = query.toLowerCase();
      return products.where((p) {
        return p.name.toLowerCase().contains(lowerQuery) ||
            (p.description?.toLowerCase().contains(lowerQuery) ?? false);
      }).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});
