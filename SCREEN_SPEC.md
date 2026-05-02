# Flutter Screen Specification — Farmers Market Platform

## Session: Grill-me alignment on all Flutter app screens
## Date: 2026-05-01
## Status: ✅ CONFIRMED

---

## Tab Bar Architecture

- **Tab bar exists on 4 primary browse roots only**: Accueil, Catalogue, Producteurs, Crédit
- **Drill-in screens push full-screen without tab bar**, with back arrow
- **4 tabs total** (no 5th tab added)

| Tab | Archetype | Purpose |
|-----|-----------|---------|
| Accueil | F — Focus | Quick-action dashboard: new sale, record repayment, daily stats |
| Catalogue | A — Feed | Browse products by category, search, add to cart |
| Producteurs | A — Feed | Search farmers, view recent, register new |
| Crédit | A — Feed | Global debt overview, grouped by status, record repayment CTA |

---

## Complete Screen Inventory (16 screens)

| # | Screen | Archetype | Tab Bar | Notes |
|---|--------|-----------|---------|-------|
| 1 | Login | C — Onboarding | No | Email + password, "Se connecter", "Se souvenir de moi" |
| 2 | Sync Loader | - | No | "Synchronisation en cours..." progress bar → Accueil |
| 3 | Accueil | F — Focus | Yes | Two 64dp hero buttons + daily stats card |
| 4 | Producteurs | A — Feed | Yes | Search-first + recent farmers list + FAB (+) |
| 5 | Farmer Detail | D — Profile / B — Detail | No | 3 tabs: Profil, Dettes, Historique |
| 6 | Catalogue | A — Feed | Yes | Search bar + category pills + product cards with stepper |
| 7 | Checkout | E — Checkout | No | Farmer card + cart items + `[Cash] [Crédit]` + totals + "Finaliser" |
| 8 | Transaction Confirmation | B — Detail | No | Receipt: reference, items, total, payment method, "Nouvelle vente" CTA |
| 9 | Transaction Detail | B — Detail | No | Read-only receipt view from Historique tab |
| 10 | Record Repayment | E — Checkout / Form | No | Single scroll: farmer picker + `[Cash] [Commodity]` + allocation preview |
| 11 | Repayment Confirmation | B — Detail | No | Allocation breakdown, proof for farmer |
| 12 | Sync Issues | A — Feed | No | Pending + failed syncs with retry buttons |
| 13 | Settings | E — Checkout / Form | No | Theme, language, last sync, version, logout, password change |
| 14 | Farmer Registration | E — Checkout / Form | No | Name, card_id, phone, location, credit_limit (optional) |
| 15 | Product Detail | B — Detail | No | Name, category, price, description, stepper, "Ajouter" |
| 16 | Debt Detail | B — Detail | No | Debt breakdown + repayments applied list |

---

## Screen-by-Screen Details

### 1. Login
- **Fields**: Email, Password, "Se souvenir de moi" checkbox
- **Actions**: "Se connecter" primary button
- **Links**: "Mot de passe oublié?"
- **Success**: Push to Sync Loader
- **No registration** — operators created by supervisors

### 2. Sync Loader
- **Content**: "Synchronisation en cours..." + progress bar
- **Purpose**: First-time data cache (farmers, products, categories)
- **Success**: Push to Accueil
- **Failure**: Retry button + error message

### 3. Accueil
- **Primary actions** (64dp height):
  - "Nouvelle vente" (accent fill, primary)
  - "Enregistrer remboursement" (outlined, secondary)
- **Stats card**: Today's transaction count + total FCFA
- **Header**: Date greeting + settings icon + sync icon
- **Offline banner**: Global overlay when offline

### 4. Producteurs
- **Search bar**: "Rechercher par carte ou téléphone..."
- **Recent farmers**: Last 5 farmers looked up today
- **List**: `FarmerListTile` (72dp) — avatar, name, card_id/phone, credit balance
- **FAB (+)**: Register new farmer
- **Empty search**: "Nouveau producteur" button visible
- **Tap**: Push to Farmer Detail

### 5. Farmer Detail
- **Profil tab**: Credit-card-shaped ID card
  - Name, card_id (large, like card number), phone, location
  - Credit limit + credit balance chips
  - "Nouvelle vente pour ce producteur" button
- **Dettes tab**: `DebtCard` list (120dp), grouped by status
  - Order: open → partially_paid → closed
  - Empty state: "Aucune dette" with green checkmark
- **Historique tab**: Transaction list
  - Each row: reference, date, total FCFA, payment method chip
  - Tap: Push to Transaction Detail
- **No tab bar**, back arrow in header

### 6. Catalogue
- **Search bar**: "Rechercher un produit..."
- **Category filters**: Horizontal scrollable pills (Tout, Céréales, Tubercules, Fruits, Légumes, Huiles)
- **Product cards**: 96dp height
  - Leading: Category color dot
  - Title: Product name
  - Subtitle: Category + unit
  - Price: `headlineSmall` with "FCFA"
  - Trailing: "Ajouter" button OR quantity stepper (± + count)
- **Tap product**: Push to Product Detail
- **Tab bar**: Catalogue tab active

### 7. Checkout
- **Header**: "Caisse" + back arrow
- **Farmer card**: Compact row (avatar, name, card_id, item count pill)
- **Cart items**: `card.flat` rows
  - Product name, quantity × unit price, line total
- **Payment method**: Segmented control `[Cash] [Crédit]`
  - Cash: subtotal = total
  - Credit: shows interest line + updated total
  - Credit limit exceeded: disables "Finaliser" + red warning
- **Totals card**: Subtotal, interest (if credit), total in `headlineMedium`
- **CTA**: "Finaliser la vente" primary button
- **Status row**: Sync status dot + "En ligne — synchronisé"
- **No tab bar**

### 8. Transaction Confirmation
- **Reference**: `TXN-YYYYMMDD-XXXX` in `headlineSmall`
- **Summary**: Items list, payment method chip, total
- **Primary action**: "Nouvelle vente" (big button)
- **Secondary action**: "Partager reçu" (outlined)
- **No tab bar**, back arrow hidden (this is a terminal screen)

### 9. Transaction Detail
- **Read-only receipt view**
- **Header**: Transaction reference + back arrow
- **Status**: Date, payment method chip, sync status chip
- **Farmer summary**: Compact card (name, card_id)
- **Items list**: Product, quantity, unit price, line total
- **Totals**: Subtotal, interest (if credit), total
- **Credit link**: If credit, tap to view associated debt
- **No actions** (read-only for MVP)

### 10. Record Repayment
- **Header**: "Enregistrer remboursement" + back arrow
- **Farmer picker card**: Selected farmer or "Sélectionner un producteur"
- **Payment type**: Segmented control `[Cash] [Commodity]`
- **Cash mode**: Amount input (FCFA, numeric keyboard)
- **Commodity mode**:
  - Dropdown: Commodity name + rate (e.g., "Cacao — 1 200 FCFA/kg")
  - kg input (decimal)
  - Live FCFA calculation
- **Allocation preview**: Card showing FIFO breakdown
  - "Appliqué à: Dette TXN-... — 8 500 FCFA"
- **CTA**: "Confirmer le remboursement"
- **No tab bar**

### 11. Repayment Confirmation
- **Header**: "Remboursement enregistré" + back arrow
- **Allocation breakdown**: List of debts affected
  - Debt reference, amount applied, remaining balance
- **Summary**: Total repaid, type (cash/commodity), date
- **Primary action**: "Nouveau remboursement" or "Retour"
- **No tab bar**

### 12. Sync Issues
- **Header**: "Synchronisation" + back arrow
- **Pending section**: Count + total FCFA
- **Failed section**: List of failed syncs
  - Each item: reference, farmer name, error message, "Réessayer" button
- **Primary action**: "Synchroniser maintenant" button
- **No tab bar**

### 13. Settings
- **Header**: "Paramètres" + back arrow
- **Appearance**: Theme toggle `[Light] [Dark]`
- **Language**: Selector `Français | English | العربية`
- **Sync**: "Dernière sync: DD/MM/YYYY HH:MM" + "Synchroniser maintenant"
- **Account**: "Changer mot de passe", "Se déconnecter"
- **About**: "Marché Connect v1.0.0"
- **No tab bar**

### 14. Farmer Registration
- **Header**: "Nouveau producteur" + back arrow
- **Fields**:
  - Nom complet (text)
  - Numéro de carte (text, unique)
  - Téléphone (phone input)
  - Localisation (text)
  - Limite de crédit (numeric, optional, pre-filled with system default)
- **CTA**: "Enregistrer" primary button
- **No tab bar**

### 15. Product Detail
- **Header**: Product name + back arrow
- **Content**:
  - Category breadcrumb (`bodySmall`, outline color)
  - Unit price: `headlineSmall` with "FCFA"
  - Description (`bodyMedium`)
  - Quantity stepper (± + count)
  - "Ajouter au panier" primary button
- **No tab bar**

### 16. Debt Detail
- **Header**: Debt reference + back arrow
- **Content**:
  - Original amount (`AmountDisplay`)
  - Paid amount (`AmountDisplay`)
  - Remaining balance (`AmountDisplay`, colored by status)
  - Status chip (open/partially_paid/closed)
  - Creation date
  - Repayments list: date, amount applied, type
- **No tab bar**

---

## Navigation Flow Map

```
Login → Sync Loader → Accueil (tab root)

Accueil:
  ├─ "Nouvelle vente" → Farmer Selection → Catalogue → Product Detail
  │                                         ↓
  │                                      Checkout → Transaction Confirmation
  │                                         ↑
  └─ "Enregistrer remboursement" → Record Repayment → Repayment Confirmation

Producteurs (tab):
  ├─ Search → Farmer Detail (Profil/Dettes/Historique)
  │              ├─ "Nouvelle vente" → Catalogue → Checkout
  │              ├─ Dettes tab → Debt Detail
  │              └─ Historique tab → Transaction Detail
  └─ FAB (+) → Farmer Registration

Catalogue (tab):
  └─ Product → Product Detail → Add to Cart → Checkout

Crédit (tab):
  └─ Debt → Farmer Detail (Dettes tab)
  └─ "Enregistrer remboursement" → Record Repayment

Global (header icons):
  ├─ Settings icon → Settings
  ├─ Sync icon → Sync Issues
  └─ Offline banner → Sync Issues (tap)
```

---

## Design System Alignment

### Colors
- Use existing `:root` tokens from `DESIGN_SYSTEM.md`
- Primary: `#00695C`, Secondary: `#E65100`
- Offline banner: `#E65100` (48dp, global overlay)

### Typography
- System fonts only (Roboto/SF Pro)
- Base: 16sp (`bodyLarge`)
- Display: `headlineSmall` (32sp) for empty states
- Amounts: `FontFeature.tabularFigures()` + "FCFA" suffix

### Touch Targets
- Minimum 56×56dp
- Hero buttons: 64dp height
- List items: 72dp (single), 96dp (product), 120dp (debt)

### Components Used
- `FarmerListTile` (72dp)
- `ProductCatalogCard` (96dp)
- `DebtCard` (120dp)
- `StatusChip` (sync, debt, payment method)
- `AmountDisplay` (FCFA formatting)
- `OfflineBanner` (48dp global)
- `CartSummaryBar` (80dp, fixed bottom)

### Accessibility
- All icon buttons have tooltips
- All images have semantic labels
- `MergeSemantics` on composite cards
- Respect `MediaQueryData.disableAnimations`

---

## Anti-Drift Rules

1. No hardcoded colors outside `app_colors.dart`
2. No hardcoded text styles outside `app_text_theme.dart`
3. No hardcoded strings outside `.arb` files
4. No ad hoc shadows — use `Card.elevation` or `Material.elevation`
5. No tappable elements < 56dp
6. No list items < 72dp height
7. All amounts include "FCFA" suffix
8. Arabic layout stays LTR (no RTL mirroring)

---

## Next Steps

1. ✅ Screen inventory confirmed (16 screens)
2. ⬜ Create HTML artifacts for each screen using `mobile-app` skill
3. ⬜ Ensure all artifacts use consistent design system tokens
4. ⬜ Validate navigation flows between screens
5. ⬜ Review with stakeholder before implementation

---

*This specification is the result of a grill-me session between product owner and AI designer. All decisions are documented and agreed upon.*
