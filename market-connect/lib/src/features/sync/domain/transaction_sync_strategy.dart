import '../../../core/data/repositories/transaction_repository.dart';
import 'sync_strategy.dart';

class TransactionSyncStrategy implements SyncStrategy {
  final TransactionRepository _repository;

  TransactionSyncStrategy(this._repository);

  @override
  String get entityType => 'transaction';

  @override
  Future<bool> sync(Map<String, dynamic> payload) async {
    final result = await _repository.createTransaction(payload);
    return result.isRight();
  }
}
