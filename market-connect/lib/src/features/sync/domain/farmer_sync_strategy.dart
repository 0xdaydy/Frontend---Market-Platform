import '../../../core/data/repositories/farmer_repository.dart';
import 'sync_strategy.dart';

class FarmerSyncStrategy implements SyncStrategy {
  final FarmerRepository _repository;

  FarmerSyncStrategy(this._repository);

  @override
  String get entityType => 'farmer';

  @override
  Future<bool> sync(Map<String, dynamic> payload) async {
    final result = await _repository.createFarmer(payload);
    return result.isRight();
  }
}
