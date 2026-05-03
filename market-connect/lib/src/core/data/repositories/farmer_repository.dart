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
      await result.fold(
        (failure) async => AppLogger.warning('Failed to fetch farmer $id remotely: ${failure.message}'),
        (farmer) async {
          final saveResult = await local.saveFarmer(farmer);
          saveResult.fold(
            (f) => AppLogger.warning('Failed to cache farmer $id: ${f.message}'),
            (_) {},
          );
        },
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
      await result.fold(
        (failure) async => AppLogger.warning('Remote farmer creation failed: ${failure.message}'),
        (farmer) async {
          final saveResult = await local.saveFarmer(farmer);
          saveResult.fold(
            (f) => AppLogger.warning('Failed to cache created farmer: ${f.message}'),
            (_) {},
          );
        },
      );
      return result;
    }

    try {
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

      final saveResult = await local.saveFarmer(tempFarmer);
      return saveResult.fold(
        (failure) => left(failure),
        (_) async {
          final queueResult = await enqueueSync(
            operation: 'create',
            entityType: 'farmer',
            entityId: tempFarmer.id.toString(),
            payload: data,
          );
          return queueResult.fold(
            (f) => left(f),
            (_) => right(tempFarmer),
          );
        },
      );
    } catch (e, st) {
      AppLogger.error('FarmerRepository: Failed to create offline farmer: $e', [e, st]);
      return left(ServerFailure('Failed to create offline farmer: $e', error: e));
    }
  }

  /// Get debts for a farmer.
  FutureEither<List<DebtModel>> getFarmerDebts(int farmerId) async {
    if (await network.hasConnection()) {
      final result = await _remote.getFarmerDebts(farmerId);
      await result.fold(
        (failure) async => AppLogger.warning('Failed to fetch debts for farmer $farmerId: ${failure.message}'),
        (debts) async {
          final saveResult = await local.saveDebts(debts);
          saveResult.fold(
            (f) => AppLogger.warning('Failed to cache debts for farmer $farmerId: ${f.message}'),
            (_) {},
          );
        },
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
      await result.fold(
        (failure) async => AppLogger.warning('Failed to fetch transactions for farmer $farmerId: ${failure.message}'),
        (transactions) async {
          final saveResult = await local.saveTransactions(transactions);
          saveResult.fold(
            (f) => AppLogger.warning('Failed to cache transactions for farmer $farmerId: ${f.message}'),
            (_) {},
          );
        },
      );
      return result;
    }

    final cached = local.getTransactionsByFarmer(farmerId);
    return right(cached);
  }
}
