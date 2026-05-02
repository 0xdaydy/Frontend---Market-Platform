import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/data/models/models.dart';
import '../../../../core/data/repositories/farmer_repository.dart';
import '../../../../imports/packages_imports.dart';
import '../../../../services/services.dart';
import '../../../../utils/utils.dart';

// Repository provider
final farmerRepositoryProvider = Provider<FarmerRepository>((ref) {
  return FarmerRepository();
});

// Farmers list provider
final farmersProvider = FutureProvider<List<FarmerModel>>((ref) async {
  final repo = ref.watch(farmerRepositoryProvider);
  return (await repo.getAll()).getOrThrow;
});

// Search farmers provider
final searchedFarmersProvider = FutureProvider.family<List<FarmerModel>, String>((ref, query) async {
  final repo = ref.watch(farmerRepositoryProvider);
  final farmers = (await repo.getAll()).getOrThrow;
  if (query.isEmpty) return farmers;
  final lowerQuery = query.toLowerCase();
  return farmers.where((f) {
    return f.name.toLowerCase().contains(lowerQuery) ||
        f.cardId.toLowerCase().contains(lowerQuery) ||
        (f.phone?.toLowerCase().contains(lowerQuery) ?? false);
  }).toList();
});

// Single farmer provider
final farmerProvider = FutureProvider.family<FarmerModel, int>((ref, id) async {
  final repo = ref.watch(farmerRepositoryProvider);
  return (await repo.getFarmer(id)).getOrThrow;
});

// Farmer debts provider
final farmerDebtsProvider = FutureProvider.family<List<DebtModel>, int>((ref, farmerId) async {
  final repo = ref.watch(farmerRepositoryProvider);
  return (await repo.getFarmerDebts(farmerId)).getOrThrow;
});

// Farmer transactions provider
final farmerTransactionsProvider = FutureProvider.family<List<TransactionModel>, int>((ref, farmerId) async {
  final repo = ref.watch(farmerRepositoryProvider);
  return (await repo.getFarmerTransactions(farmerId)).getOrThrow;
});

// Create farmer notifier
class CreateFarmerNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    // Nothing to do initially
  }

  Future<void> createFarmer(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    final repo = ref.read(farmerRepositoryProvider);
    final result = await repo.createFarmer(data);
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (_) => const AsyncValue.data(null),
    );
    // Refresh farmers list
    ref.invalidate(farmersProvider);
  }
}

final createFarmerProvider = AsyncNotifierProvider<CreateFarmerNotifier, void>(CreateFarmerNotifier.new);

// All debts provider (uses local cache + attempts remote refresh via farmer endpoints)
final debtsProvider = FutureProvider<List<DebtModel>>((ref) async {
  final repo = ref.watch(farmerRepositoryProvider);

  // If online, refresh by fetching all farmers then their debts
  final network = InternetConnectionService();
  final isOnline = await network.hasConnection();

  if (isOnline) {
    final farmersResult = await repo.getAll();
    await farmersResult.fold(
      (_) async {},
      (farmers) async {
        for (final farmer in farmers) {
          await repo.getFarmerDebts(farmer.id);
        }
      },
    );
  }

  return HiveService.instance.getDebts();
});
