/// Strategy for syncing a specific entity type to the server.
///
/// Each feature registers its own strategy so the sync engine
/// doesn't need to know about all entity types.
abstract class SyncStrategy {
  String get entityType;
  Future<bool> sync(Map<String, dynamic> payload);
}
