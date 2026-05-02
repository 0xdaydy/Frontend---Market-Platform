import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import '../../hive_registrar.g.dart';
import '../core/data/models/models.dart';
import '../utils/utils.dart';

/// A robust [Hive] storage service for local NoSQL persistence.
class HiveService {
  HiveService._();
  static final HiveService instance = HiveService._();

  bool _initialized = false;

  /// Initialize Hive and open typed boxes.
  FutureEither<void> init() async {
    return runTask(() async {
      if (_initialized) return;
      
      await Hive.initFlutter();
      Hive.registerAdapters();
      
      // Open typed boxes for each entity
      await Hive.openBox<FarmerModel>('farmers');
      await Hive.openBox<ProductModel>('products');
      await Hive.openBox<CategoryModel>('categories');
      await Hive.openBox<TransactionModel>('transactions');
      await Hive.openBox<DebtModel>('debts');
      await Hive.openBox<RepaymentModel>('repayments');
      await Hive.openBox<SyncQueueEntryModel>('sync_queue');
      
      _initialized = true;
      AppLogger.info('Hive initialized with typed boxes');
    });
  }

  // --- Generic box access ---

  Box<T> _box<T>(String name) => Hive.box<T>(name);

  // --- Farmers ---

  FutureEither<void> saveFarmers(List<FarmerModel> farmers) async {
    return runTask(() async {
      final box = _box<FarmerModel>('farmers');
      final Map<String, FarmerModel> entries = {
        for (final f in farmers) f.id.toString(): f,
      };
      await box.putAll(entries);
    });
  }

  FutureEither<void> saveFarmer(FarmerModel farmer) async {
    return runTask(() => _box<FarmerModel>('farmers').put(farmer.id.toString(), farmer));
  }

  List<FarmerModel> getFarmers() {
    return _box<FarmerModel>('farmers').values.toList();
  }

  FarmerModel? getFarmer(int id) {
    return _box<FarmerModel>('farmers').get(id.toString());
  }

  FutureEither<void> clearFarmers() async {
    return runTask(() => _box<FarmerModel>('farmers').clear());
  }

  // --- Products ---

  FutureEither<void> saveProducts(List<ProductModel> products) async {
    return runTask(() async {
      final box = _box<ProductModel>('products');
      final entries = {for (final p in products) p.id.toString(): p};
      await box.putAll(entries);
    });
  }

  List<ProductModel> getProducts() {
    return _box<ProductModel>('products').values.toList();
  }

  List<ProductModel> getProductsByCategory(int categoryId) {
    return _box<ProductModel>('products')
        .values
        .where((p) => p.categoryId == categoryId)
        .toList();
  }

  FutureEither<void> clearProducts() async {
    return runTask(() => _box<ProductModel>('products').clear());
  }

  // --- Categories ---

  FutureEither<void> saveCategories(List<CategoryModel> categories) async {
    return runTask(() async {
      final box = _box<CategoryModel>('categories');
      final entries = {for (final c in categories) c.id.toString(): c};
      await box.putAll(entries);
    });
  }

  List<CategoryModel> getCategories() {
    return _box<CategoryModel>('categories').values.toList();
  }

  FutureEither<void> clearCategories() async {
    return runTask(() => _box<CategoryModel>('categories').clear());
  }

  // --- Transactions ---

  FutureEither<void> saveTransactions(List<TransactionModel> transactions) async {
    return runTask(() async {
      final box = _box<TransactionModel>('transactions');
      final entries = {
        for (final t in transactions) 
          (t.id ?? t.reference ?? DateTime.now().toIso8601String()).toString(): t,
      };
      await box.putAll(entries);
    });
  }

  FutureEither<void> saveTransaction(TransactionModel transaction) async {
    return runTask(() async {
      final box = _box<TransactionModel>('transactions');
      final key = (transaction.id ?? transaction.reference ?? DateTime.now().millisecondsSinceEpoch).toString();
      await box.put(key, transaction);
    });
  }

  List<TransactionModel> getTransactions() {
    return _box<TransactionModel>('transactions').values.toList();
  }

  List<TransactionModel> getTransactionsByFarmer(int farmerId) {
    return _box<TransactionModel>('transactions')
        .values
        .where((t) => t.farmerId == farmerId)
        .toList();
  }

  List<TransactionModel> getUnsyncedTransactions() {
    return _box<TransactionModel>('transactions')
        .values
        .where((t) => !t.isSynced)
        .toList();
  }

  // --- Debts ---

  FutureEither<void> saveDebts(List<DebtModel> debts) async {
    return runTask(() async {
      final box = _box<DebtModel>('debts');
      final entries = {for (final d in debts) d.id.toString(): d};
      await box.putAll(entries);
    });
  }

  List<DebtModel> getDebts() {
    return _box<DebtModel>('debts').values.toList();
  }

  List<DebtModel> getDebtsByFarmer(int farmerId) {
    return _box<DebtModel>('debts')
        .values
        .where((d) => d.farmerId == farmerId)
        .toList();
  }

  FutureEither<void> clearDebts() async {
    return runTask(() => _box<DebtModel>('debts').clear());
  }

  // --- Repayments ---

  FutureEither<void> saveRepayments(List<RepaymentModel> repayments) async {
    return runTask(() async {
      final box = _box<RepaymentModel>('repayments');
      final entries = {for (final r in repayments) r.id.toString(): r};
      await box.putAll(entries);
    });
  }

  List<RepaymentModel> getRepayments() {
    return _box<RepaymentModel>('repayments').values.toList();
  }

  List<RepaymentModel> getUnsyncedRepayments() {
    return _box<RepaymentModel>('repayments')
        .values
        .where((r) => !r.isSynced)
        .toList();
  }

  // --- Sync Queue ---

  FutureEither<void> enqueue(SyncQueueEntryModel entry) async {
    return runTask(() => _box<SyncQueueEntryModel>('sync_queue').put(entry.id, entry));
  }

  FutureEither<void> removeFromQueue(String id) async {
    return runTask(() => _box<SyncQueueEntryModel>('sync_queue').delete(id));
  }

  FutureEither<void> updateQueueEntry(SyncQueueEntryModel entry) async {
    return runTask(() => _box<SyncQueueEntryModel>('sync_queue').put(entry.id, entry));
  }

  List<SyncQueueEntryModel> getSyncQueue() {
    return _box<SyncQueueEntryModel>('sync_queue').values.toList();
  }

  List<SyncQueueEntryModel> getPendingSyncQueue() {
    return _box<SyncQueueEntryModel>('sync_queue')
        .values
        .where((e) => e.status == 'pending')
        .toList();
  }

  List<SyncQueueEntryModel> getFailedSyncQueue() {
    return _box<SyncQueueEntryModel>('sync_queue')
        .values
        .where((e) => e.status == 'failed')
        .toList();
  }

  FutureEither<void> clearSyncQueue() async {
    return runTask(() => _box<SyncQueueEntryModel>('sync_queue').clear());
  }

  // --- Generic ---

  FutureEither<void> clearAll() async {
    return runTask(() async {
      await _box<FarmerModel>('farmers').clear();
      await _box<ProductModel>('products').clear();
      await _box<CategoryModel>('categories').clear();
      await _box<TransactionModel>('transactions').clear();
      await _box<DebtModel>('debts').clear();
      await _box<RepaymentModel>('repayments').clear();
      await _box<SyncQueueEntryModel>('sync_queue').clear();
    });
  }
}
