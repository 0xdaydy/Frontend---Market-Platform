import '../../../../core/data/models/models.dart';
import '../../../../core/data/repositories/transaction_repository.dart';
import '../../../../imports/packages_imports.dart';
import '../../../../utils/utils.dart';
import '../../../farmers/presentation/providers/farmer_providers.dart';

// Repository provider
final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepository();
});

// Transactions provider
final transactionsProvider =
    FutureProvider<List<TransactionModel>>((ref) async {
  final repo = ref.watch(transactionRepositoryProvider);
  return (await repo.getAll()).getOrThrow;
});

// Single transaction provider
final transactionProvider =
    FutureProvider.family<TransactionModel, int>((ref, id) async {
  final repo = ref.watch(transactionRepositoryProvider);
  return (await repo.getTransaction(id)).getOrThrow;
});

// Create transaction notifier
class CreateTransactionNotifier extends AsyncNotifier<TransactionModel?> {
  @override
  Future<TransactionModel?> build() async => null;

  Future<void> createTransaction(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    final repo = ref.read(transactionRepositoryProvider);
    final result = await repo.createTransaction(data);
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (transaction) => AsyncValue.data(transaction),
    );
    // Refresh lists
    ref.invalidate(transactionsProvider);
    final farmerId = data['farmer_id'] as int?;
    if (farmerId != null) {
      ref.invalidate(farmerTransactionsProvider(farmerId));
    }
  }

  Future<void> validateTransaction(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    final repo = ref.read(transactionRepositoryProvider);
    final result = await repo.validateTransaction(data);
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (_) => const AsyncValue.data(null),
    );
  }
}

final createTransactionProvider =
    AsyncNotifierProvider<CreateTransactionNotifier, TransactionModel?>(
        CreateTransactionNotifier.new);

// Cart state
class CartState {
  final int? farmerId;
  final String? farmerName;
  final List<CartItem> items;
  final String paymentMethod;

  const CartState({
    this.farmerId,
    this.farmerName,
    this.items = const [],
    this.paymentMethod = 'cash',
  });

  double get subtotal => items.fold(0, (sum, item) => sum + item.lineTotal);
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => items.isEmpty;
  bool get hasFarmer => farmerId != null;

  CartState copyWith({
    int? farmerId,
    String? farmerName,
    List<CartItem>? items,
    String? paymentMethod,
  }) {
    return CartState(
      farmerId: farmerId ?? this.farmerId,
      farmerName: farmerName ?? this.farmerName,
      items: items ?? this.items,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }
}

class CartItem {
  final int productId;
  final String productName;
  final int quantity;
  final double unitPrice;

  CartItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
  });

  double get lineTotal => quantity * unitPrice;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      productId: productId,
      productName: productName,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice,
    );
  }
}

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(const CartState());

  void setFarmer(int id, String name) {
    state = state.copyWith(farmerId: id, farmerName: name);
  }

  void addItem(int productId, String productName, double price) {
    final existingIndex =
        state.items.indexWhere((i) => i.productId == productId);
    if (existingIndex >= 0) {
      final updated = [...state.items];
      updated[existingIndex] = updated[existingIndex].copyWith(
        quantity: updated[existingIndex].quantity + 1,
      );
      state = state.copyWith(items: updated);
    } else {
      state = state.copyWith(
        items: [
          ...state.items,
          CartItem(
            productId: productId,
            productName: productName,
            quantity: 1,
            unitPrice: price,
          )
        ],
      );
    }
  }

  void updateQuantity(int productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }
    final updated = [...state.items];
    final index = updated.indexWhere((i) => i.productId == productId);
    if (index >= 0) {
      updated[index] = updated[index].copyWith(quantity: quantity);
      state = state.copyWith(items: updated);
    }
  }

  void removeItem(int productId) {
    state = state.copyWith(
      items: state.items.where((i) => i.productId != productId).toList(),
    );
  }

  void setPaymentMethod(String method) {
    state = state.copyWith(paymentMethod: method);
  }

  void clear() {
    state = const CartState();
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});
