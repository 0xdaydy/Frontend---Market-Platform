import '../../../imports/core_imports.dart';
import '../../../imports/packages_imports.dart';

import '../../../utils/utils.dart';
import '../models/models.dart';
import '../remote/farmer_remote_data_source.dart';
import 'offline_first_repository.dart';

/// Repository for farmer operations with offline-first strategy.
class FarmerRepository extends OfflineFirstRepository<FarmerModel> {
  final FarmerRemoteDataSource _remote;

  FarmerRepository({
    FarmerRemoteDataSource? remote,
    super.network,
    super.local,
  }) : _remote = remote ?? FarmerRemoteDataSource();

  @override
  FutureEither<List<FarmerModel>> fetchRemote() => _remote.getFarmers();

  @override
  FutureEither<void> saveLocal(List<FarmerModel> items) => local.saveFarmers(items);

  @override
  List<FarmerModel> getLocal() => local.getFarmers();

  @override
  String get cacheFailureMessage => 'No farmers available offline';

  /// Fetch a single farmer by ID.
  FutureEither<FarmerModel> getFarmer(int id) async {
    if (await network.hasConnection()) {
      final result = await _remote.getFarmer(id);
      result.fold(
        (_) {},
        (farmer) async => await local.saveFarmer(farmer),
      );
      return result;
    }

    final cached = local.getFarmer(id);
    if (cached != null) return right(cached);
    return left(const CacheFailure('Farmer not available offline'));
  }

  /// Create a farmer — remote with local cache, or offline temp + queue.
  FutureEither<FarmerModel> createFarmer(Map<String, dynamic> data) async {
    if (await network.hasConnection()) {
      final result = await _remote.createFarmer(data);
      result.fold(
        (_) {},
        (farmer) async => await local.saveFarmer(farmer),
      );
      return result;
    }

    final tempFarmer = FarmerModel(
      id: DateTime.now().millisecondsSinceEpoch, // temporary local ID
      cardId: data['card_id'] as String,
      name: data['name'] as String,
      phone: data['phone'] as String?,
      village: data['village'] as String?,
      creditLimit: (data['credit_limit'] as num?)?.toDouble() ?? 50000.0,
      creditBalanceFcfa: 0,
      createdAt: DateTime.now(),
    );

    await local.saveFarmer(tempFarmer);
    await enqueueSync(
      operation: 'create',
      entityType: 'farmer',
      entityId: tempFarmer.id.toString(),
      payload: data,
    );

    return right(tempFarmer);
  }

  /// Get debts for a farmer.
  FutureEither<List<DebtModel>> getFarmerDebts(int farmerId) async {
    if (await network.hasConnection()) {
      final result = await _remote.getFarmerDebts(farmerId);
      result.fold(
        (_) {},
        (debts) async => await local.saveDebts(debts),
      );
      return result;
    }

    final cached = local.getDebtsByFarmer(farmerId);
    return right(cached);
  }

  /// Get transactions for a farmer.
  FutureEither<List<TransactionModel>> getFarmerTransactions(int farmerId) async {
    if (await network.hasConnection()) {
      final result = await _remote.getFarmerTransactions(farmerId);
      result.fold(
        (_) {},
        (transactions) async => await local.saveTransactions(transactions),
      );
      return result;
    }

    final cached = local.getTransactionsByFarmer(farmerId);
    return right(cached);
  }
}
