# Frontend---Market-Platform
Flutter Mobile POS for Farmers Market Platform
# Market Connect — Flutter Frontend

## Overview

**Market Connect** is the Flutter mobile POS application for the Farmers Market Platform. It is designed for field operators who need to process transactions, manage farmer credit, and record repayments in markets with unreliable connectivity.

| Property | Value |
|----------|-------|
| **Framework** | Flutter 3.5+ (Dart 3.5+) |
| **Location** | `Frontend---Market-Platform/market-connect/` |
| **State Management** | Riverpod (`flutter_riverpod` + `hooks_riverpod`) |
| **Navigation** | `go_router` with `StatefulShellRoute` bottom navigation |
| **Architecture** | Clean Architecture (Domain / Data / Presentation) |
| **Offline Strategy** | Offline-first reads + sync queue for mutations |
| **Localization** | French (`fr`), English (`en`), Arabic (`ar`) |

---

## Quick Start (Frontend)

### Prerequisites

- Flutter SDK `>=3.5.0 <4.0.0`
- Dart `>=3.5.0`
- Android Studio / VS Code with Flutter extension
- An Android emulator or physical device

### Installation

```bash
cd Frontend---Market-Platform/market-connect

# Fetch dependencies
flutter pub get

# Generate code (Hive adapters, localization, etc.)
dart run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

### Environment Configuration

Create a `.env` file in the project root:

```env
API_BASE_URL=http://localhost:8080/api/v1
API_URL=http://localhost:8080/api/v1
BASE_API_URL=http://localhost:8080/api/v1
APP_NAME="Market Connect"
```

> **Note:** When running on an Android emulator, use `http://10.0.2.2:8080/api/v1` instead of `localhost`.

---

## Architecture

The frontend follows **Clean Architecture** with three principal layers:

| Layer | Responsibility | Location |
|-------|---------------|----------|
| **Domain** | Entities, repository interfaces, business rules | `lib/src/features/*/domain/` |
| **Data** | Models, remote data sources, repository implementations | `lib/src/core/data/` |
| **Presentation** | Screens, providers (state), routing | `lib/src/features/*/presentation/` |

### Directory Structure

```
lib/
├── main.dart                          # Entry point: init services, run app
├── app.dart                           # MaterialApp.router with wrappers
├── src/
│   ├── config/
│   │   └── app_config.dart            # Dio init, base URL, interceptors
│   ├── core/
│   │   ├── api/
│   │   │   └── auth_interceptor.dart  # JWT attach + 401 logout
│   │   ├── data/
│   │   │   ├── models/                # Hive + JSON models (Equatable)
│   │   │   ├── remote/                # Remote data sources (Dio wrappers)
│   │   │   └── repositories/          # Offline-first repo implementations
│   │   ├── design_system/
│   │   │   └── components/            # Business-aware reusable widgets
│   │   └── notifications/             # Unified error notification seam
│   │       ├── notification_gateway.dart
│   │       └── toast_notification_adapter.dart
│   ├── features/                      # Feature-based modules
│   │   ├── auth/                      # Login, session, auth state
│   │   ├── catalog/                   # Product categories & browsing
│   │   ├── credit/                    # Debt tracking & credit details
│   │   ├── farmers/                   # Farmer CRUD, search, detail
│   │   ├── home/                      # Dashboard, summary cards
│   │   ├── repayments/                # Record repayments (cash/commodity)
│   │   ├── settings/                  # App settings, logout
│   │   ├── sync/                      # Offline sync engine & queue
│   │   └── transactions/              # Cart, checkout, transaction history
│   ├── routing/
│   │   ├── app_router.dart            # go_router configuration
│   │   └── global_navigator.dart      # rootNavigatorKey for global overlays
│   ├── services/                      # Singleton services
│   │   ├── dio_service.dart           # HTTP client wrapper
│   │   ├── hive_service.dart          # Local NoSQL storage
│   │   ├── auth_service.dart          # JWT management
│   │   └── internet_connection_service.dart
│   ├── shared/
│   │   ├── helpers/
│   │   │   └── show_toast.dart        # Overlay toast primitives
│   │   ├── widgets/
│   │   │   └── toast/                 # ToastBar, ToastCard, RawToast
│   │   └── wrappers/
│   │       ├── auth_listener_wrapper.dart
│   │       ├── session_listener_wrapper.dart
│   │       └── state_wrapper.dart     # ProviderScope
│   ├── theme/                         # Material 3 theming & design tokens
│   └── utils/
│       ├── failure.dart               # Failure hierarchy (Server, Cache, Network, Unknown)
│       ├── task_runner.dart           # runTask() → Either<Failure, T>
│       └── error_handler.dart         # Exception-to-message formatting
```

### Key Patterns

#### 1. Offline-First Repository

All read operations go through `OfflineFirstRepository<T>`:

1. Check network availability
2. If online → fetch from remote API, cache to Hive
3. If offline → return cached Hive data
4. If offline with no cache → return `CacheFailure`

```dart
abstract class OfflineFirstRepository<T> {
  FutureEither<List<T>> getAll();
  FutureEither<T> getById(String id);
  FutureEither<void> syncPending();

  // Hooks implemented by concrete repositories
  FutureEither<List<T>> fetchRemote();
  FutureEither<void> saveLocal(List<T> items);
  FutureEither<List<T>> getLocal();
}
```

#### 2. Functional Error Handling

All async operations return `Either<Failure, T>` via `fpdart`:

```dart
// Repository layer
final result = await farmerRepository.getAll();

// Provider layer
final farmers = result.getOrThrow; // Throws Failure into AsyncValue.error

// UI layer (Riverpod AsyncValue)
providersAsync.when(
  data: (farmers) => FarmerList(farmers),
  loading: () => Skeletonizer(child: ...),
  error: (failure, _) => AppErrorWidget(failure: failure),
);
```

#### 3. Unified Notification Gateway

Errors are surfaced to users through a single seam — `NotificationGateway` — rather than scattered `SnackBar` / `Toast` calls:

```dart
// In any provider, wrapper, or screen listener
ref.read(notificationGatewayProvider).notify(failure);
```

The `ToastNotificationAdapter` maps `Failure` subclasses to toast severity:
- `NetworkFailure` / `CacheFailure` → `warning` (retryable)
- `ServerFailure` / `UnknownFailure` → `error` (action failed)

#### 4. Sync Queue for Offline Mutations

When the user performs a mutation (create transaction, record repayment) while offline, the operation is stored as a `SyncQueueEntryModel` in Hive. The `SyncEngineNotifier` processes the queue when connectivity returns using pluggable `SyncStrategy` implementations per entity type.

---

## Backend API Integration (OpenAPI Spec)

The frontend strictly adheres to the backend's OpenAPI 3.1.0 specification (`Backend---Market-Platform/docs/openapi.json`). The connection is implemented in the Data layer and strictly validated by contract tests:

### 1. API Configuration
The core connection to the backend environment is established using `Dio`. It defines the base path (e.g., `/api/v1`) that prefixes all endpoint calls defined in the spec.
- **Location:** `lib/src/config/app_config.dart`

### 2. Remote Data Sources
The frontend implements the API contract through "Remote Data Sources". These classes use the `DioService` to make HTTP requests to the exact endpoints laid out in the OpenAPI spec.
- **Location:** `lib/src/core/data/remote/`
- **Examples:** `farmer_remote_data_source.dart`, `transaction_remote_data_source.dart`, `catalog_remote_data_source.dart`

### 3. Contract Tests (The Safety Net)
The most explicit link to the `openapi.json` spec lives in the tests. The app uses **Contract Tests** to ensure frontend Data Models can perfectly parse the JSON structures defined by the backend spec.
- **Location:** `test/contract/api_response_snapshot_test.dart`
- **Mechanism:** Sample JSON responses are derived directly from the OpenAPI spec and pasted here. If the backend spec changes a field name, this test fails immediately.

---

## State Management (Riverpod)

| Provider Type | Purpose | Example |
|---------------|---------|---------|
| `Provider<T>` | Singletons (repositories, services) | `catalogRepositoryProvider` |
| `FutureProvider<T>` | Async read operations | `categoriesProvider`, `farmersProvider` |
| `FutureProvider.family<T, Arg>` | Parameterized reads | `farmerProvider(id)`, `productsByCategoryProvider(id)` |
| `StateNotifierProvider` | Stateful controllers | `authControllerProvider`, `cartProvider` |
| `AsyncNotifierProvider` | Modern async mutations | `createTransactionProvider`, `createRepaymentProvider` |

Side effects (navigation, toasts) are decoupled from controllers via wrapper widgets:
- `AuthListenerWrapper` — listens to auth state, handles login/logout navigation + error toasts
- `SessionListenerWrapper` — listens to session changes
- `StateWrapper` — wraps the app in `ProviderScope`

---

## Routing

Uses `go_router` with a `StatefulShellRoute.indexedStack` for the main 4-tab bottom navigation:

| Tab | Route | Screen |
|-----|-------|--------|
| Home | `/` | `HomePage` |
| Catalogue | `/catalogue` | `CatalogueScreen` |
| Producteurs | `/producteurs` | `ProducteursScreen` |
| Crédit | `/credit` | `CreditScreen` |

**Drill-in routes** (non-tab):
- `/farmer/:id` → `FarmerDetailScreen`
- `/product/:id` → `ProductDetailScreen`
- `/checkout` → `CheckoutScreen`
- `/repayment/record` → `RecordRepaymentScreen`
- `/login` → `LoginScreen` (initial route)

---

## Flutter Development Commands

### Dependencies & Code Generation

```bash
cd Frontend---Market-Platform/market-connect

# Install dependencies
flutter pub get

# Run code generation (Hive adapters, localization, etc.)
dart run build_runner build --delete-conflicting-outputs

# Watch for changes and auto-generate (useful during active development)
dart run build_runner watch --delete-conflicting-outputs

# Clean generated files and rebuild
dart run build_runner build --delete-conflicting-outputs
```

### Localization

```bash
# Generate localization files from ARB (auto-runs with `flutter gen-l10n` via build)
flutter gen-l10n
```

ARB files live in `lib/l10n/`:
- `app_fr.arb` — French (template)
- `app_en.arb` — English
- `app_ar.arb` — Arabic

Generated output: `lib/generated/app_localizations.dart`

### Native Splash Screen

```bash
# Configure in flutter_native_splash.yaml, then apply:
dart run flutter_native_splash:create --path=flutter_native_splash.yaml
```

### Running & Building

```bash
# Run on connected device / emulator
flutter run

# Run in debug mode with hot reload
flutter run --debug

# Run in profile mode (performance testing)
flutter run --profile

# Run in release mode
flutter run --release

# Build APK (Android)
flutter build apk

# Build App Bundle (Android Play Store)
flutter build appbundle

# Build iOS (requires macOS + Xcode)
flutter build ios
```

### Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/unit/catalog_repository_test.dart

# Run widget tests
flutter test test/widget/
```

### Code Quality

```bash
# Analyze for errors, warnings, and lints
flutter analyze

# Format all Dart files
dart format .

# Check formatting without modifying files
dart format --output=none --set-exit-if-changed .
```

### iOS Setup (macOS only)

```bash
cd ios
pod install
cd ..
```

---

## Key Dependencies

| Category | Package | Purpose |
|----------|---------|---------|
| **Navigation** | `go_router` | Declarative routing |
| **State** | `flutter_riverpod` + `hooks_riverpod` | Reactive state management |
| **Functional** | `fpdart` | `Either<Failure, T>` error handling |
| **Network** | `dio` | HTTP client with interceptors |
| **Offline** | `hive_ce` + `hive_ce_flutter` | Local NoSQL storage |
| **Auth** | `flutter_secure_storage` | Encrypted JWT token storage |
| **UI** | `flutter_screenutil` | Responsive sizing |
| | `flutter_animate` | Animations |
| | `skeletonizer` | Loading skeletons |
| | `hugeicons` | Icon library |
| **Dev** | `build_runner` | Code generation |
| | `hive_ce_generator` | Hive adapter generation |
| | `mocktail` | Unit/widget test mocking |

---

## Testing


The project follows Laravel conventions:
- **Resource controllers** for pure CRUD features (Catalog, Farmers, Users, Settings) — multi-method controllers under `app/Features/{Feature}/`
- **Single-action classes** (`__invoke`) for complex operations (StoreTransaction, StoreRepayment, ValidateTransaction, Auth)
- Feature-based folder structure under `app/Features/`
- Form Request validation classes
- Domain modules (e.g. `CreditAccount`) encapsulate business rules with a small public interface
- Service classes for shared business logic (TransactionPricing, TransactionEngine, RepaymentAllocator)
- Native Gates and Policies for authorization

## License

MIT
