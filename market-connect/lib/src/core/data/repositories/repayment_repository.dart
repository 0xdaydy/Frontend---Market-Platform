import '../../../imports/core_imports.dart';
import '../../../imports/packages_imports.dart';

import '../../../utils/utils.dart';
import '../models/models.dart';
import '../remote/repayment_remote_data_source.dart';
import 'offline_first_repository.dart';

/// Repository for repayment operations with offline-first strategy.
class RepaymentRepository extends OfflineFirstRepository<RepaymentModel> {
  final RepaymentRemoteDataSource _remote;

  RepaymentRepository({
    RepaymentRemoteDataSource? remote,
    super.network,
    super.local,
  }) : _remote = remote ?? RepaymentRemoteDataSource();

  @override
  FutureEither<List<RepaymentModel>> fetchRemote() => _remote.getRepayments();

  @override
  FutureEither<void> saveLocal(List<RepaymentModel> items) => local.saveRepayments(items);

  @override
  List<RepaymentModel> getLocal() => local.getRepayments();

  @override
  String get cacheFailureMessage => 'No repayments available offline';

  /// Create a repayment — remote with local cache, or offline temp + queue.
  FutureEither<RepaymentModel> createRepayment(Map<String, dynamic> data) async {
    if (await network.hasConnection()) {
      final result = await _remote.createRepayment(data);
      await result.fold(
        (failure) async => AppLogger.warning('Remote repayment creation failed: ${failure.message}'),
        (repayment) async {
          final saveResult = await local.saveRepayments([repayment]);
          saveResult.fold(
            (f) => AppLogger.warning('Failed to cache created repayment: ${f.message}'),
            (_) {},
          );
        },
      );
      return result;
    }

    try {
      final tempRepayment = RepaymentModel(
        id: DateTime.now().millisecondsSinceEpoch,
        farmerId: data['farmer_id'] as int,
        farmerName: data['farmer_name'] as String? ?? '',
        amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
        paymentMethod: data['payment_method'] as String,
        reference: 'LOCAL-${DateTime.now().millisecondsSinceEpoch}',
        createdAt: DateTime.now(),
        commodityName: data['commodity_name'] as String?,
        commodityRate: (data['commodity_rate'] as num?)?.toDouble(),
        commodityKg: (data['commodity_kg'] as num?)?.toDouble(),
        isSynced: false,
      );

      final saveResult = await local.saveRepayments([tempRepayment]);
      return saveResult.fold(
        (failure) => left(failure),
        (_) async {
          final queueResult = await enqueueSync(
            operation: 'create',
            entityType: 'repayment',
            entityId: tempRepayment.id.toString(),
            payload: data,
          );
          return queueResult.fold(
            (f) => left(f),
            (_) => right(tempRepayment),
          );
        },
      );
    } catch (e, st) {
      AppLogger.error('RepaymentRepository: Failed to create offline repayment: $e', [e, st]);
      return left(ServerFailure('Failed to create offline repayment: $e', error: e));
    }
  }

  List<RepaymentModel> getUnsyncedRepayments() {
    return local.getUnsyncedRepayments();
  }
}
