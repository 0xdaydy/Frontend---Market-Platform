# Design System Specification — Farmers Market Platform (Flutter)

## 1. Overview

This document defines the complete design system for the Farmers Market Platform Flutter frontend. It governs all visual, structural, and interaction decisions across the six frontend modules: Authentication, Farmer Management, Product Catalog, Transaction Checkout, Debt & Repayment, and Offline Sync.

**Target context**: Rural field operators in Côte d'Ivoire and North Africa using budget Android and iOS devices, often in direct sunlight, with intermittent connectivity.

**Foundation**: Material 3 with a strict override layer for field constraints.

---

## 2. Design Language Foundation

| Decision | Value |
|---|---|
| Base Framework | Material 3 |
| Customization Layer | Strict override layer for rural field constraints |
| Rationale | Accessibility scaffolding, component stability, and reduced maintenance risk vs. fully custom system. Material gives us tested motion, elevation, and accessibility behavior out of the box. |

### 2.1 Material Overrides

| Override | Value | Justification |
|---|---|---|
| Minimum touch target | 56 × 56 dp | Exceeds Material 3's 48dp minimum. Accommodates gloved fingers, motor-impaired users, and outdoor glove use. |
| High-contrast palette | WCAG AA minimum, AAA preferred | Outdoor readability on low-brightness budget LCD panels. |
| Offline-state affordances | Persistent global banner + status chips | Connectivity is critical to the domain; disconnected state must be visible at all times without blocking interaction. |
| Compact density for data | Taller list items with larger tap areas | Debt lists, transaction history, and catalogs are data-dense but must remain finger-friendly. |

---

## 3. Color System

### 3.1 Theme Modes

| Decision | Value |
|---|---|
| Light Mode | Default on first launch. Optimized for outdoor direct sunlight. |
| Dark Mode | **Opt-in via Settings** (`SettingsRepository` + Riverpod). Not system-adaptive by default to prevent auto-switching in bright daylight. |
| `MaterialApp` default | `themeMode: ThemeMode.light` |

### 3.2 Core Palette

| Token | Light Mode Hex | Dark Mode Hex | Usage |
|---|---|---|---|
| `primary` | `#00695C` | `#4DB6AC` | Brand color. Primary actions, AppBar background (light), key interactive elements, progress indicators. |
| `onPrimary` | `#FFFFFF` | `#000000` | Text and icons placed on primary surfaces. |
| `primaryContainer` | `#B2DFDB` | `#004D40` | Contained button backgrounds, selected states, emphasis fills. |
| `onPrimaryContainer` | `#004D40` | `#B2DFDB` | Text on primary container surfaces. |
| `secondary` | `#E65100` | `#FF8F00` | Credit/debt attention states, offline warnings, sync-pending badges, emphasis chips. |
| `onSecondary` | `#FFFFFF` | `#000000` | Text and icons on secondary surfaces. |
| `secondaryContainer` | `#FFE0B2` | `#E65100` | Secondary chip backgrounds, low-priority emphasis, banner backgrounds. |
| `onSecondaryContainer` | `#BF360C` | `#FFE0B2` | Text on secondary container surfaces. |
| `surface` | `#FFFFFF` | `#1E1E1E` | Card backgrounds, bottom sheet backgrounds, dialog backgrounds. |
| `onSurface` | `#212121` | `#E0E0E0` | Primary text on card and sheet surfaces. |
| `surfaceVariant` | `#F5F5F5` | `#2C2C2C` | Subtle backgrounds, list item hover/press states, divider-adjacent areas. |
| `onSurfaceVariant` | `#616161` | `#BDBDBD` | Secondary text, captions, helper text, disabled states. |
| `background` | `#FAFAFA` | `#121212` | Screen scaffold background behind cards and lists. |
| `onBackground` | `#212121` | `#E0E0E0` | Text directly on the scaffold background. |
| `error` | `#B3261E` | `#F2B8B5` | Validation errors, destructive actions, sync failures, critical alerts. |
| `onError` | `#FFFFFF` | `#601410` | Text on error surfaces. |
| `outline` | `#79747E` | `#938F99` | Borders, dividers, inactive form field outlines. |
| `outlineVariant` | `#C4C7C5` | `#444746` | Subtle dividers inside cards and lists. |
| `shadow` | `#000000` | `#000000` | Elevation shadows (opacity varies by elevation). |
| `inverseSurface` | `#313033` | `#F4EFF4` | Snackbar background, inverse emphasis surfaces. |
| `inverseOnSurface` | `#F4EFF4` | `#313033` | Text on inverse surfaces. |

### 3.3 Custom Design Tokens

The following tokens extend `ColorScheme` via `ThemeExtension`. They must be accessed through `Theme.of(context).extension<AppColorExtension>()!`.

| Token | Light Mode Hex | Dark Mode Hex | Usage |
|---|---|---|---|
| `offlineIndicator` | `#E65100` | `#FF8F00` | Global offline banner background, sync-pending badges, connectivity warning icons. |
| `success` | `#2E7D32` | `#81C784` | Sync completed, debt fully repaid, positive confirmation states. |
| `warning` | `#F9A825` | `#FFD54F` | Partial sync, partial debt repayment, non-critical cautions. |

### 3.4 Usage Prohibitions

- **No hardcoded color literals** anywhere outside `lib/core/design_system/tokens/app_colors.dart`.
- All color references must route through `Theme.of(context).colorScheme` or the `AppColorExtension`.
- No `Color.withOpacity()` ad hoc in feature code. Use Material's opacity tokens (`onSurface.withOpacity(0.38)` for disabled) only within the design system token file.

---

## 4. Localization & Internationalization

### 4.1 Supported Languages

| Language | Locale Code | Default | Script Direction |
|---|---|---|---|
| French | `fr` | Yes | LTR |
| English | `en` | No | LTR |
| Arabic | `ar` | No | LTR (Arabic content rendered left-to-right; no RTL mirroring) |

**Rationale**: French is the primary operating language for Côte d'Ivoire field operators. English supports regional admin and expat supervisors. Arabic supports North African deployments. Arabic is kept in LTR layout to avoid full UI mirroring complexity in the MVP; Arabic text renders correctly inside LTR containers.

### 4.2 File Format & Tooling

- **Format**: ARB (Application Resource Bundle) JSON files.
- **Tooling**: `flutter_gen` for type-safe string access.
- **Dependencies**: `flutter_localizations`, `intl`, `flutter_gen_runner`.

### 4.3 ARB File Structure

```
lib/l10n/
├── app_en.arb
├── app_fr.arb
└── app_ar.arb
```

**Key rules**:
- All user-facing strings must be defined in `.arb` files. **No hardcoded strings** in widget code.
- Use placeholders with types for dynamic values: `"{amount}"` with `"placeholders": { "amount": { "type": "int" } }`.
- Use `select` for grammatical gender/plural where necessary (primarily French and Arabic).
- The `@@locale` key must be present in each file.

### 4.4 Locale Resolution

1. On first launch, attempt to match the device locale to supported locales (`fr`, `en`, `ar`).
2. If no match, fallback to **French** (`fr`).
3. User can override via Settings screen. Override persists in local SQLite (`SettingsRepository`).
4. `MaterialApp` uses `localeResolutionCallback` to enforce fallback logic.

### 4.5 Number & Date Formatting

All number and date formatting must use the `intl` package with the **active UI locale**.

| Data Type | French (`fr`) | English (`en`) | Arabic (`ar`) |
|---|---|---|---|
| FCFA Amount | `12 500 FCFA` | `12,500 FCFA` | `١٢٬٥٠٠ FCFA` |
| Date (short) | `01/05/2026` | `5/1/2026` | `١/٥/٢٠٢٦` |
| Date (long) | `1 mai 2026` | `May 1, 2026` | `١ مايو ٢٠٢٦` |
| Phone display | `+225 01 23 45 67 89` | `+225 01 23 45 67 89` | `+225 01 23 45 67 89` |

**Important**: FCFA amounts must include the currency label "FCFA" suffix in all locales. The digit grouping and numeral script follow the active UI locale.

### 4.6 LTR-Only Layout Policy

Since Arabic uses LTR layout:
- Use standard `EdgeInsets` (not `EdgeInsetsDirectional`).
- Use `Row` and `Column` with `mainAxisAlignment` and `crossAxisAlignment` as usual.
- `TextAlign.left` and `TextAlign.right` behave normally; Arabic text is shaped correctly by the Flutter text renderer within LTR containers.
- No `Directionality` wrapper changes needed for Arabic.

---

## 5. Typography

### 5.1 Font Family

| Decision | Value |
|---|---|
| Font | System default (`Roboto` on Android, `SF Pro` on iOS) |
| Custom fonts | **None** in MVP |
| Rationale | Minimize APK/IPA size. Avoid rural connectivity issues for asset downloads. Eliminate font licensing friction. Material 3 type scale is engineered for system fonts. |

### 5.2 Base Size & Minimums

| Decision | Value |
|---|---|
| Base body size | `16sp` (`bodyLarge`), up from Material's default `14sp` |
| Minimum tappable text | `16sp` |
| Small text allowance | `12sp` (`labelSmall`) **only** for non-essential metadata (timestamps, reference numbers, version labels) that operators do not need to read under time pressure. |

### 5.3 Type Scale

| Token | Size | Weight | Line Height | Letter Spacing | Usage |
|---|---|---|---|---|---|
| `displaySmall` | 32sp | Regular (400) | 40sp | 0 | Empty states, onboarding headers, welcome screens. |
| `headlineMedium` | 28sp | Bold (700) | 36sp | 0 | Cart grand total, debt grand total, checkout summary total, confirmation screen headline. |
| `headlineSmall` | 24sp | Bold (700) | 32sp | 0 | Card primary amounts, farmer name in detail header, modal sheet titles. |
| `titleLarge` | 20sp | Medium (500) | 28sp | 0 | Screen titles, AppBar titles, page headers. |
| `titleMedium` | 18sp | Medium (500) | 26sp | 0.015 | Section headers, category names in catalog, form section titles. |
| `titleSmall` | 16sp | Medium (500) | 24sp | 0.01 | List item primary text (when not a title), dialog option labels. |
| `bodyLarge` | 16sp | Regular (400) | 24sp | 0.05 | Primary readable text, form labels, body paragraphs, button text. |
| `bodyMedium` | 14sp | Regular (400) | 20sp | 0.025 | Descriptions, secondary text, hints, helper text under fields. |
| `bodySmall` | 12sp | Regular (400) | 16sp | 0.04 | Captions under images, tertiary descriptions, long metadata. |
| `labelLarge` | 16sp | Medium (500) | 24sp | 0.1 | Button text, tab labels, segmented control labels. Same size as `bodyLarge` for touch-target consistency. |
| `labelMedium` | 14sp | Medium (500) | 20sp | 0.05 | Input text, compact button labels, chip text. |
| `labelSmall` | 12sp | Medium (500) | 16sp | 0.05 | **Metadata only**: transaction reference numbers, sync timestamps, version labels, badge counts. |

### 5.4 Amount Typography

- FCFA amounts must use `FontFeature.tabularFigures()` to prevent column jitter when values change.
- Amount widgets always pair the numeric value in `headlineSmall` (or larger) with the "FCFA" suffix in `labelSmall`.
- Negative amounts (credit balance overpayment shown as negative debt) use the `error` color.
- Zero amounts use `onSurfaceVariant` at 60% opacity.

### 5.5 Usage Prohibitions

- **No hardcoded `TextStyle` literals** outside `lib/core/design_system/tokens/app_text_theme.dart`.
- All text must use `Theme.of(context).textTheme.<token>` or the `AppLocalizations` generated strings.
- No `Text` widget without explicit style or inherited theme style. Default `textTheme.bodyLarge` is the implicit fallback via `DefaultTextStyle` at the screen level.

---

## 6. Spacing, Density & Touch Targets

### 6.1 Touch Targets

| Rule | Value |
|---|---|
| Minimum tappable size | 56 × 56 dp |
| Visual bounds vs. hit area | Visual bounds may be smaller (e.g., 40dp icon) if the `InkWell` or `GestureDetector` hit area expands to 56dp using `Material` or `Padding`. |
| Rationale | Android accessibility guidelines for motor-impaired users; gloved finger accommodation. |

### 6.2 Spacing Scale

All spacing derives from an **8dp base unit**. Use named constants, not magic numbers.

| Token | Value | Usage |
|---|---|---|
| `space_4` | 4dp | Tight icon inset padding, very compact internal gaps. |
| `space_8` | 8dp | Inline gap between icon and adjacent text, compact row internal spacing. |
| `space_12` | 12dp | Gap between cards in a `ListView`, gap between related buttons in a row. |
| `space_16` | 16dp | Horizontal screen padding on scrollable screens, form field vertical spacing, card internal padding. |
| `space_20` | 20dp | Large card internal padding, expanded list item internal padding. |
| `space_24` | 24dp | Vertical gap between major sections, horizontal padding in dialogs and bottom sheets. |
| `space_32` | 32dp | Large vertical gaps, empty state vertical padding, hero section spacing. |
| `space_48` | 48dp | **Offline banner height**. |
| `space_56` | 56dp | FAB visual height, minimum touch target dimension. |
| `space_64` | 64dp | Large button height, expanded bottom bar items. |
| `space_72` | 72dp | **Single-line list item minimum height** (e.g., `FarmerListTile`). |
| `space_80` | 80dp | **Bottom app bar / action bar height**, `CartSummaryBar` height. |
| `space_96` | 96dp | **Two-line card/list item height** (e.g., `ProductCatalogCard`). |
| `space_120` | 120dp | **Three-line card height** (e.g., `DebtCard` with reference, amount, status, date). |

### 6.3 Layout Rules

| Rule | Value |
|---|---|
| Screen horizontal padding | 16dp on all scrollable screens. |
| Dialog / BottomSheet horizontal padding | 24dp. |
| Layout paradigm | **Single-pane only**. No master-detail split. |
| Tablet support | None in MVP. Layout remains single-column scrollable on tablets. |
| Landscape orientation | Supported. Layout stays identical (scrollable single column). No landscape-specific rearrangement. |
| SafeArea | Respected on all edges. No content drawn under the system status bar unless explicitly full-bleed (rare in this app). |
| Bottom inset | Respected for on-screen keyboards. Forms must scroll when keyboard opens. |

---

## 7. Elevation & Shadows

### 7.1 Elevation Strategy

| Surface | Elevation (dp) | Usage |
|---|---|---|
| AppBar | 0dp (flat) | Modern Material 3 style. Use `surface` color with bottom `Divider` or `outlineVariant` bottom border if separation is needed. |
| Cards | 1dp (default) | List items, catalog cards, debt cards. Subtle shadow for depth in light mode; minimal shadow in dark mode. |
| Bottom Sheets | 1dp | Modal bottom sheets for checkout review, farmer quick actions. |
| Dialogs | 6dp | Confirmation dialogs, error dialogs, picker dialogs. |
| FAB | 3dp | Primary floating action buttons (e.g., add farmer, checkout). |
| Snackbar | 6dp | Transient confirmation messages, sync status toasts. |
| Offline Banner | 0dp (flat) | Sits flush against the content below. Color contrast (`offlineIndicator`) provides separation, not shadow. |

### 7.2 Prohibitions

- **No ad hoc `Container` box shadows**. Elevation only via `Card.elevation`, `Material.elevation`, or themed component defaults.
- Do not use `BoxShadow` directly in feature code.

---

## 8. Component Library

### 8.1 Folder Structure

```
lib/core/design_system/
├── tokens/
│   ├── app_colors.dart              // ColorScheme + AppColorExtension
│   ├── app_text_theme.dart          // TextTheme definitions
│   ├── app_spacing.dart             // Spacing constants
│   └── app_theme.dart               // ThemeData assembly (light/dark)
├── components/
│   ├── amount_display.dart          // FCFA amount with locale formatting
│   ├── farmer_list_tile.dart        // 72dp farmer row
│   ├── debt_card.dart               // 120dp debt summary card
│   ├── product_catalog_card.dart    // 96dp product row with quantity
│   ├── status_chip.dart             // Sync/debt status indicator
│   ├── offline_banner.dart          // Global connectivity overlay
│   └── cart_summary_bar.dart        // Fixed bottom checkout bar
└── helpers/
    └── locale_aware_formatter.dart  // Number/date formatting helpers
```

### 8.2 Base Component Strategy

- **Wrap Material components, never rebuild them.** Use the following as bases:
  - `FilledButton`, `OutlinedButton`, `TextButton`
  - `Card`, `ListTile`
  - `TextField` (with `InputDecorationTheme`)
  - `Chip`, `FilterChip`, `ActionChip`
  - `BottomSheet`, `Dialog`, `AlertDialog`
  - `Snackbar`
  - `AppBar`, `BottomAppBar`
  - `FloatingActionButton`, `FloatingActionButton.extended`
- Customization happens through `ThemeData` and `ColorScheme`.

### 8.3 Theme Configuration

`AppTheme` provides a single source of truth:

```dart
class AppTheme {
  static ThemeData lightTheme(BuildContext context) { ... }
  static ThemeData darkTheme(BuildContext context) { ... }
}
```

**Required theme keys** (all must be populated, none left to Material defaults):
- `colorScheme` (complete with all 28 Material 3 tokens)
- `textTheme` (complete type scale)
- `inputDecorationTheme`
- `elevatedButtonTheme`
- `filledButtonTheme`
- `outlinedButtonTheme`
- `textButtonTheme`
- `chipTheme`
- `cardTheme`
- `appBarTheme`
- `bottomSheetTheme`
- `dialogTheme`
- `floatingActionButtonTheme`
- `snackBarTheme`
- `dividerTheme`
- `listTileTheme`
- `bottomAppBarTheme`
- `extensions` (for `AppColorExtension`)

**Color generation**: Hand-coded `ColorScheme` with exact hex values. Do **not** use `ColorScheme.fromSeed()` — it does not produce the required deep teal and warm amber tones with sufficient saturation control.

### 8.4 Domain-Specific Composite Widgets

#### `AmountDisplay`

| Property | Value |
|---|---|
| Height | Intrinsic |
| Props | `int amount`, `bool showSign = false`, `TextStyle? overrideStyle`, `bool showCurrency = true` |
| Behavior | Formats `amount` using locale-aware number formatting (`intl.NumberFormat` with active locale). Displays numeric value in `headlineSmall` bold with `FontFeature.tabularFigures()`. Appends "FCFA" in `labelSmall`. Handles negative values (red color) and zero (muted color). |
| Usage | Anywhere a monetary value is displayed: cards, lists, totals, summaries. |

#### `FarmerListTile`

| Property | Value |
|---|---|
| Height | 72dp |
| Props | `Farmer farmer`, `VoidCallback onTap`, `bool showCreditBalance = true` |
| Layout | Leading: Circular avatar with farmer initials (2 chars) in `primaryContainer`. Title: Farmer name in `titleMedium`. Subtitle: Phone or `card_id` in `bodyMedium`. Trailing: `AmountDisplay` for `credit_balance_fcfa` if non-zero and `showCreditBalance` is true. |
| Touch target | Entire row tappable to 72dp height (exceeds 56dp minimum). |
| Usage | Farmer lookup results, supervisor dashboard lists, checkout farmer selection. |

#### `DebtCard`

| Property | Value |
|---|---|
| Height | 120dp |
| Props | `Debt debt`, `VoidCallback? onTap` |
| Layout | Top row: Transaction reference in `labelSmall` (`outline` color). Middle row: `AmountDisplay` for `remaining_balance` in `headlineSmall`. Bottom row: `StatusChip` for debt status + creation date in `bodySmall`. |
| Colors | `open` status = `offlineIndicator` (amber). `partially_paid` = `warning` (yellow). `closed` = `success` (green). |
| Usage | Farmer debt summary screen, supervisor portfolio risk view. |

#### `ProductCatalogCard`

| Property | Value |
|---|---|
| Height | 96dp |
| Props | `Product product`, `ValueChanged<int> onQuantityChanged`, `bool inCart`, `int quantity` |
| Layout | Title: Product name in `titleSmall`. Subtitle: Category breadcrumb in `bodySmall` (`outline` color). Trailing area: `AmountDisplay` for unit price + quantity stepper (`IconButton` + `Text` + `IconButton`) or an "Add" `FilledButton` if `quantity == 0`. |
| Touch targets | Stepper buttons at 48dp visual but wrapped in 56dp `InkWell`. "Add" button is 40dp visual height with 56dp tap padding. |
| Usage | Product catalog browsing, category product lists, checkout item review. |

#### `StatusChip`

| Property | Value |
|---|---|
| Height | Intrinsic (minimum 32dp visual) |
| Props | `Status status`, `bool compact = false` |
| Variants | `synced` (`success`), `pending` (`offlineIndicator`), `offline` (`secondaryContainer`), `error` (`error`), `open` (`offlineIndicator`), `partiallyPaid` (`warning`), `closed` (`success`). |
| Layout | Wraps `Chip` with preset `backgroundColor` and `labelStyle`. Label text is localized via ARB. |
| Usage | Transaction history items, sync queue list, debt cards, offline sync screen. |

#### `OfflineBanner`

| Property | Value |
|---|---|
| Height | 48dp |
| Visibility | Controlled by global connectivity state (Riverpod). |
| Position | **Global overlay** at the top of the widget tree, above all routes. |
| Layout | Full-width bar. Background: `offlineIndicator` color. Text: "Mode hors ligne — Les données seront synchronisées automatiquement" (localized via ARB) in `labelLarge` with `onSecondary` color. |
| Behavior | Non-dismissible. Slides in from top (`AnimatedContainer` or `SlideTransition`) when connectivity is lost. Slides out when connectivity returns. Persists across navigation. Does not block `AppBar` taps if `SafeArea` and `MediaQuery` padding are respected. |
| Z-index | Rendered in an `OverlayPortal` or `Stack` at the `MaterialApp` root. |

#### `CartSummaryBar`

| Property | Value |
|---|---|
| Height | 80dp |
| Position | Fixed at bottom of screen, above bottom navigation if present. |
| Props | `int itemCount`, `int totalFcfa`, `String ctaLabel` (localized), `VoidCallback onCta`, `bool isEnabled = true` |
| Layout | Left: Item count in `bodyMedium` (`onSurfaceVariant`). Center: `AmountDisplay` for `totalFcfa` in `headlineSmall`. Right: `FilledButton` with `ctaLabel`. |
| Background | `surface` color with top `Divider` (1dp, `outlineVariant`). Optional subtle top shadow (elevation 1dp). |
| Behavior | If `isEnabled` is false, CTA button is disabled and total is muted. |
| Usage | Checkout screen, cart review modal, transaction confirmation. |

---

## 9. Global Offline Banner (Overlay) Specification

Since connectivity is central to the domain, the offline indicator must be globally persistent and non-intrusive.

### 9.1 Architecture

```dart
// Root app widget
Stack(
  children: [
    MaterialApp(
      // ... routes, theme, locale
    ),
    Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AnimatedSlide(
        offset: isOffline ? Offset.zero : const Offset(0, -1),
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        child: const OfflineBanner(),
      ),
    ),
  ],
)
```

### 9.2 Behavior

| State | Visual |
|---|---|
| Online | Banner is off-screen (hidden). |
| Offline | Banner slides down to 48dp height. |
| Transition | 250ms ease-in-out slide. |
| Text | Localized: "Offline mode — data will sync automatically" (FR/EN/AR). |
| Interaction | Non-blocking. Content below remains scrollable and tappable. |

### 9.3 SafeArea Handling

The banner must respect `MediaQueryData.padding.top` (status bar height). The `Stack` is placed inside a `SafeArea` wrapper, or the banner's `Positioned.top` is set to `0` and the banner itself includes `SafeArea` top padding so text is not hidden behind the status bar.

---

## 10. Theme Mode Persistence

### 10.1 Default

- `ThemeMode.light` on first launch.

### 10.2 User Override

- Toggle located in Settings screen.
- Options: "Light", "Dark", "System" (system-adaptive).
- **MVP default**: Only "Light" and "Dark" options. "System" can be added post-MVP.
- Persisted in local SQLite via `SettingsRepository`.

### 10.3 State Management

- A Riverpod provider exposes the current `ThemeMode`.
- The root `ConsumerWidget` rebuilds `MaterialApp` when the provider changes.
- No `SharedPreferences` — all settings persist in the app's SQLite database for consistency with offline-first architecture.

---

## 11. Accessibility & Field Constraints

| Constraint | Strategy |
|---|---|
| **Sunlight readability** | Light-mode default. High contrast palette (AAA where possible). 16sp base text. No thin font weights. |
| **Gloved / clumsy touch** | 56dp minimum touch targets. 80dp bottom bars. Large CTA buttons. Generous internal padding on cards. |
| **Low-end devices** | System fonts only. No heavy image assets. Single-pane layouts. Minimal animations (reduce battery and jank). |
| **Connectivity awareness** | Global `OfflineBanner`. `StatusChip` on every transaction and sync queue item. Local pre-validation feedback. |
| **Localization** | ARB files with `flutter_gen`. French default. English and Arabic supported. Arabic in LTR layout. |
| **Motion reduction** | Respect `MediaQueryData.disableAnimations` or system accessibility settings. Banner slide can be instant if animations are disabled. |
| **Screen reader** | All icon buttons must have `tooltip` (localized). All images must have `semanticLabel`. `MergeSemantics` used on composite cards. |

---

## 12. Anti-Drift Prohibitions

To keep the UI consistent across six frontend modules and multiple developers:

1. **No hardcoded `Color` literals** outside `lib/core/design_system/tokens/app_colors.dart`.
2. **No hardcoded `TextStyle` literals** outside `lib/core/design_system/tokens/app_text_theme.dart`.
3. **No hardcoded strings** outside `lib/l10n/*.arb` files. All user-facing text must use `AppLocalizations`.
4. **No ad hoc `Container` box shadows**. Elevation only via `Card.elevation` or `Material` widget with `elevation`.
5. **No custom `TextField` decorations** outside `InputDecorationTheme`. All inputs must inherit from the theme.
6. **No `Text` widget without explicit style or inherited theme style**.
7. **No list items smaller than 72dp height** (single-line).
8. **No tappable elements smaller than 56dp**.
9. **No system-adaptive dark mode** as the default. Dark mode is opt-in only.
10. **No hardcoded numbers** for spacing outside `lib/core/design_system/tokens/app_spacing.dart`.
11. **No direct `intl` or `NumberFormat` calls** in feature code. Use `LocaleAwareFormatter` helpers.

---

## 13. Dependencies

Add the following to `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  intl: ^0.19.0
  flutter_riverpod: ^2.5.0
  sqflite: ^2.3.0

flutter:
  generate: true
```

Add `l10n.yaml` at project root:

```yaml
arb-dir: lib/l10n
template-arb-file: app_fr.arb
output-localization-file: app_localizations.dart
output-dir: lib/generated/
synthetic-package: false
output-class: AppLocalizations
```

Run `flutter gen-l10n` after creating `.arb` files.

---

## 14. Summary of Decisions

| Topic | Decision |
|---|---|
| Framework | Material 3 with strict rural-field overrides |
| Light/Dark | Both supported. Light default. Dark opt-in via Settings. |
| Primary color | Deep Teal `#00695C` (light) / `#4DB6AC` (dark) |
| Secondary color | Warm Amber `#E65100` (light) / `#FF8F00` (dark) |
| Fonts | System default (Roboto / SF Pro). No custom fonts. |
| Base text size | 16sp (`bodyLarge`) |
| Touch target min | 56 × 56 dp |
| List item heights | 72dp (single), 96dp (double), 120dp (triple) |
| Layout | Single-pane only. No tablet split. LTR for all languages. |
| Localization | ARB files with `flutter_gen`. French (default), English, Arabic. |
| Arabic layout | LTR (no RTL mirroring) |
| Number formatting | Locale-aware (`intl`). FCFA suffix preserved across locales. |
| Offline banner | Global overlay, 48dp, non-dismissible, animated slide. |
| Component strategy | Wrap Material components. Domain composites in `core/design_system/components/`. |
| Elevation | Only via themed components. No ad hoc shadows. |
| Theme config | Hand-coded `ColorScheme`. No `fromSeed()`. |

---

*This specification is ready for implementation. The next step is scaffolding `lib/core/design_system/` and `lib/l10n/` with the token files, theme assembly, ARB stubs, and composite widget shells.*
