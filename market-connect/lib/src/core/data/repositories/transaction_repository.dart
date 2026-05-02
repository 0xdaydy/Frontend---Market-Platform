import '../../../imports/core_imports.dart';
import '../../../imports/packages_imports.dart';

import '../models/models.dart';
import '../remote/transaction_remote_data_source.dart';
import 'offline_first_repository.dart';

/// Repository for transaction operations with offline-first strategy.
class TransactionRepository extends OfflineFirstRepository<TransactionModel> {
  final TransactionRemoteDataSource _remote;

  TransactionRepository({
    TransactionRemoteDataSource? remote,
    super.network,
    super.local,
  }) : _remote = remote ?? TransactionRemoteDataSource();

  @override
  FutureEither<List<TransactionModel>> fetchRemote() => _remote.getTransactions();

  @override
  FutureEither<void> saveLocal(List<TransactionModel> items) => local.saveTransactions(items);

  @override
  List<TransactionModel> getLocal() => local.getTransactions();

  @override
  String get cacheFailureMessage => 'No transactions available offline';

  /// Fetch a single transaction.
  FutureEither<TransactionModel> getTransaction(int id) async {
    if (await network.hasConnection()) {
      return await _remote.getTransaction(id);
    }

    final all = local.getTransactions();
    final match = all.where((t) => t.id == id).firstOrNull;
    if (match != null) return right(match);
    return left(const CacheFailure('Transaction not available offline'));
  }

  /// Create a transaction — remote with local cache, or offline temp + queue.
  FutureEither<TransactionModel> createTransaction(Map<String, dynamic> data) async {
    if (await network.hasConnection()) {
      final result = await _remote.createTransaction(data);
      result.fold(
        (_) {},
        (transaction) async => await local.saveTransaction(transaction),
      );
      return result;
    }

    final items = (data['items'] as List<dynamic>)
        .map((e) => TransactionItemModel(
              productId: e['product_id'] as int,
              productName: e['product_name'] as String? ?? '',
              quantity: e['quantity'] as int,
              unitPrice: (e['unit_price'] as num).toDouble(),
              lineTotal: ((e['quantity'] as num) * (e['unit_price'] as num)).toDouble(),
            ))
        .toList();

    final tempTransaction = TransactionModel(
      id: null,
      reference: 'LOCAL-${DateTime.now().millisecondsSinceEpoch}',
      farmerId: data['farmer_id'] as int,
      farmerName: data['farmer_name'] as String? ?? '',
      paymentMethod: data['payment_method'] as String,
      totalAmount: (data['total_amount'] as num?)?.toDouble() ?? 0.0,
      status: 'pending',
      items: items,
      createdAt: DateTime.now(),
      isSynced: false,
    );

    await local.saveTransaction(tempTransaction);
    await enqueueSync(
      operation: 'create',
      entityType: 'transaction',
      entityId: tempTransaction.reference ?? 'local-${DateTime.now().millisecondsSinceEpoch}',
      payload: data,
    );

    return right(tempTransaction);
  }

  /// Validate an offline transaction against the server.
  FutureEither<Map<String, dynamic>> validateTransaction(Map<String, dynamic> data) async {
    return await _remote.validateTransaction(data);
  }

  List<TransactionModel> getUnsyncedTransactions() {
    return local.getUnsyncedTransactions();
  }
}
