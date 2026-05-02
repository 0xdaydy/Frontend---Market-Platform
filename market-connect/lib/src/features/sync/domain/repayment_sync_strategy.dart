import '../../../core/data/repositories/repayment_repository.dart';
import 'sync_strategy.dart';

class RepaymentSyncStrategy implements SyncStrategy {
  final RepaymentRepository _repository;

  RepaymentSyncStrategy(this._repository);

  @override
  String get entityType => 'repayment';

  @override
  Future<bool> sync(Map<String, dynamic> payload) async {
    final result = await _repository.createRepayment(payload);
    return result.isRight();
  }
}
