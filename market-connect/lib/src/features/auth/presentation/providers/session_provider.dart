import 'dart:async';

import 'package:market_connect/src/features/auth/domain/entities/user.dart';
import 'package:market_connect/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:market_connect/src/imports/core_imports.dart';
import 'package:market_connect/src/imports/packages_imports.dart';

import 'auth_provider.dart';

/// Provides a stream of auth state changes
final authStateStreamProvider = StreamProvider<AppUser?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.onAuthStateChanged;
});

/// Provides the current session state
final sessionProvider =
    StateNotifierProvider<SessionNotifier, SessionState>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return SessionNotifier(repository: repo);
});

/// Session states
enum SessionStatus { unknown, authenticated, unauthenticated }

class SessionState {
  final SessionStatus status;
  final AppUser? user;

  const SessionState({this.status = SessionStatus.unknown, this.user});

  SessionState copyWith({SessionStatus? status, AppUser? user}) {
    return SessionState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }
}

class SessionNotifier extends StateNotifier<SessionState> {
  final AuthRepository _repository;
  StreamSubscription<AppUser?>? _authSub;

  SessionNotifier({required AuthRepository repository})
      : _repository = repository,
        super(const SessionState()) {
    _init();
  }

  Future<void> _init() async {
    try {
      // Check persisted session first
      final result = await _repository.checkAuthState();
      result.fold(
        (failure) {
          AppLogger.warning('SessionNotifier: checkAuthState failed: ${failure.message}');
          state = const SessionState(status: SessionStatus.unauthenticated);
        },
        (user) {
          if (user != null) {
            state = SessionState(status: SessionStatus.authenticated, user: user);
          } else {
            state = const SessionState(status: SessionStatus.unauthenticated);
          }
        },
      );
    } catch (e, st) {
      AppLogger.error('SessionNotifier: Error during auth state check: $e', [e, st]);
      state = const SessionState(status: SessionStatus.unauthenticated);
    }

    // Listen for future changes
    try {
      _authSub = _repository.onAuthStateChanged.listen(
        (user) {
          if (user != null) {
            state = SessionState(status: SessionStatus.authenticated, user: user);
          } else {
            state = const SessionState(status: SessionStatus.unauthenticated);
          }
        },
        onError: (Object e, StackTrace st) {
          AppLogger.error('SessionNotifier: Auth stream error: $e', [e, st]);
        },
      );
    } catch (e, st) {
      AppLogger.error('SessionNotifier: Failed to subscribe to auth stream: $e', [e, st]);
    }
  }

  Future<void> logout() async {
    try {
      final result = await _repository.logout();
      result.fold(
        (failure) => AppLogger.warning('SessionNotifier: Logout API failed: ${failure.message}'),
        (_) => AppLogger.info('SessionNotifier: Logout successful'),
      );
    } catch (e, st) {
      AppLogger.error('SessionNotifier: Error during logout: $e', [e, st]);
    } finally {
      // Always clear local session state regardless of API result
      state = const SessionState(status: SessionStatus.unauthenticated);
    }
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }
}
