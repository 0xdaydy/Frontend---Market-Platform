import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../utils/error_handler.dart';
import '../../../../utils/failure.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

// Provides the single instance of AuthRepositoryImpl
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

// Auth state provider - streams auth changes
final authStateProvider = StreamProvider<AppUser?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.onAuthStateChanged;
});

// Current user provider
final currentUserProvider = Provider<AppUser?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) => user,
    loading: () => null,
    error: (_, __) => null,
  );
});

// Auth controller — pure state machine, no UI dependencies.
// Navigation and toast side effects are handled by AuthListener widget.
class AuthController extends StateNotifier<AsyncValue<AppUser?>> {
  final AuthRepository _repository;

  AuthController({required AuthRepository repository})
      : _repository = repository,
        super(const AsyncValue.data(null));

  Future<void> login({required String email, required String password}) async {
    state = const AsyncValue.loading();

    try {
      final result = await _repository.login(
        email: email,
        password: password,
      );

      result.fold(
        (failure) => state = AsyncValue.error(failure, StackTrace.current),
        (user) => state = AsyncValue.data(user),
      );
    } catch (e, st) {
      state = AsyncValue.error(
        UnknownFailure(
          AppErrorHandler.format(e),
          error: e,
        ),
        st,
      );
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();

    try {
      final result = await _repository.logout();

      result.fold(
        (failure) => state = AsyncValue.error(failure, StackTrace.current),
        (_) => state = const AsyncValue.data(null),
      );
    } catch (e, st) {
      state = AsyncValue.error(
        UnknownFailure(
          AppErrorHandler.format(e),
          error: e,
        ),
        st,
      );
    }
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<AppUser?>>((ref) {
  return AuthController(repository: ref.read(authRepositoryProvider));
});
