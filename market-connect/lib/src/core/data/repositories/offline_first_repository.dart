import 'package:fpdart/fpdart.dart';

import '../../../services/internet_connection_service.dart';
import '../../../services/hive_service.dart';
import '../../../utils/failure.dart';
import '../../../utils/typedefs.dart';
import '../models/sync_queue_entry_model.dart';

/// Base class for offline-first repositories.
///
/// Eliminates the duplicated "check online → fetch remote → cache → fallback to local" pattern
/// that was repeated verbatim across all 4 repositories.
///
/// Concrete repositories override hooks for entity-specific remote/local logic.
abstract class OfflineFirstRepository<T> {
  final InternetConnectionService network;
  final HiveService local;

  OfflineFirstRepository({
    InternetConnectionService? network,
    HiveService? local,
  })  : network = network ?? InternetConnectionService(),
        local = local ?? HiveService.instance;

  // --- Hooks for concrete repositories ---

  FutureEither<List<T>> fetchRemote();
  FutureEither<void> saveLocal(List<T> items);
  List<T> getLocal();
  String get cacheFailureMessage => 'No data available offline';

  // --- Shared offline-first method ---

  /// Fetch all items: try remote first, cache, fall back to local.
  FutureEither<List<T>> getAll() async {
    if (await network.hasConnection()) {
      final result = await fetchRemote();
      result.fold(
        (_) {},
        (items) async => await saveLocal(items),
      );
      return result;
    }

    final cached = getLocal();
    if (cached.isNotEmpty) {
      return right(cached);
    }
    return left(CacheFailure(cacheFailureMessage));
  }

  // --- Create helper for offline queueing ---

  /// Enqueue a sync entry. Call from subclass `create()` methods.
  FutureEither<void> enqueueSync({
    required String operation,
    required String entityType,
    required String entityId,
    required Map<String, dynamic> payload,
  }) {
    return local.enqueue(SyncQueueEntryModel.create(
      operation: operation,
      entityType: entityType,
      entityId: entityId,
      payload: payload,
    ));
  }
}
