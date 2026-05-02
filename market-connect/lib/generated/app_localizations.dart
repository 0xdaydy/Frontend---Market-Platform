import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @appName.
  ///
  /// In fr, this message translates to:
  /// **'Marché Connect'**
  String get appName;

  /// No description provided for @appVersion.
  ///
  /// In fr, this message translates to:
  /// **'v1.0.0'**
  String get appVersion;

  /// No description provided for @loginTitle.
  ///
  /// In fr, this message translates to:
  /// **'Marché Connect'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Connectez-vous pour continuer'**
  String get loginSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In fr, this message translates to:
  /// **'Adresse email'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In fr, this message translates to:
  /// **'operateur@marche.ci'**
  String get emailHint;

  /// No description provided for @passwordLabel.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get passwordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In fr, this message translates to:
  /// **'••••••••'**
  String get passwordHint;

  /// No description provided for @rememberMe.
  ///
  /// In fr, this message translates to:
  /// **'Se souvenir de moi'**
  String get rememberMe;

  /// No description provided for @signIn.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get signIn;

  /// No description provided for @forgotPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié ?'**
  String get forgotPassword;

  /// No description provided for @logout.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get logout;

  /// No description provided for @logoutConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous vraiment vous déconnecter ?'**
  String get logoutConfirm;

  /// No description provided for @homeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get homeTitle;

  /// No description provided for @newSale.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle vente'**
  String get newSale;

  /// No description provided for @recordRepayment.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer remboursement'**
  String get recordRepayment;

  /// No description provided for @todayStats.
  ///
  /// In fr, this message translates to:
  /// **'Aujourd\'hui'**
  String get todayStats;

  /// No description provided for @salesToday.
  ///
  /// In fr, this message translates to:
  /// **'Ventes aujourd\'hui'**
  String get salesToday;

  /// No description provided for @totalFcfa.
  ///
  /// In fr, this message translates to:
  /// **'Total FCFA'**
  String get totalFcfa;

  /// No description provided for @offlineBanner.
  ///
  /// In fr, this message translates to:
  /// **'Mode hors ligne — Les données seront synchronisées automatiquement'**
  String get offlineBanner;

  /// No description provided for @catalogTitle.
  ///
  /// In fr, this message translates to:
  /// **'Catalogue'**
  String get catalogTitle;

  /// No description provided for @searchProduct.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un produit...'**
  String get searchProduct;

  /// No description provided for @all.
  ///
  /// In fr, this message translates to:
  /// **'Tout'**
  String get all;

  /// No description provided for @cereals.
  ///
  /// In fr, this message translates to:
  /// **'Céréales'**
  String get cereals;

  /// No description provided for @tubers.
  ///
  /// In fr, this message translates to:
  /// **'Tubercules'**
  String get tubers;

  /// No description provided for @fruits.
  ///
  /// In fr, this message translates to:
  /// **'Fruits'**
  String get fruits;

  /// No description provided for @vegetables.
  ///
  /// In fr, this message translates to:
  /// **'Légumes'**
  String get vegetables;

  /// No description provided for @oils.
  ///
  /// In fr, this message translates to:
  /// **'Huiles'**
  String get oils;

  /// No description provided for @add.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter'**
  String get add;

  /// No description provided for @addToCart.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter au panier'**
  String get addToCart;

  /// No description provided for @productDetail.
  ///
  /// In fr, this message translates to:
  /// **'Détail produit'**
  String get productDetail;

  /// No description provided for @category.
  ///
  /// In fr, this message translates to:
  /// **'Catégorie'**
  String get category;

  /// No description provided for @unit.
  ///
  /// In fr, this message translates to:
  /// **'Unité'**
  String get unit;

  /// No description provided for @description.
  ///
  /// In fr, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @quantity.
  ///
  /// In fr, this message translates to:
  /// **'Quantité'**
  String get quantity;

  /// No description provided for @farmersTitle.
  ///
  /// In fr, this message translates to:
  /// **'Producteurs'**
  String get farmersTitle;

  /// No description provided for @searchFarmer.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher par carte ou téléphone...'**
  String get searchFarmer;

  /// No description provided for @newFarmer.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau producteur'**
  String get newFarmer;

  /// No description provided for @farmerRegistration.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau producteur'**
  String get farmerRegistration;

  /// No description provided for @fullName.
  ///
  /// In fr, this message translates to:
  /// **'Nom complet'**
  String get fullName;

  /// No description provided for @cardNumber.
  ///
  /// In fr, this message translates to:
  /// **'Numéro de carte'**
  String get cardNumber;

  /// No description provided for @phone.
  ///
  /// In fr, this message translates to:
  /// **'Téléphone'**
  String get phone;

  /// No description provided for @location.
  ///
  /// In fr, this message translates to:
  /// **'Localisation'**
  String get location;

  /// No description provided for @creditLimit.
  ///
  /// In fr, this message translates to:
  /// **'Limite de crédit'**
  String get creditLimit;

  /// No description provided for @creditLimitOptional.
  ///
  /// In fr, this message translates to:
  /// **'Limite de crédit (optionnel)'**
  String get creditLimitOptional;

  /// No description provided for @save.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get save;

  /// No description provided for @farmerDetail.
  ///
  /// In fr, this message translates to:
  /// **'Détail producteur'**
  String get farmerDetail;

  /// No description provided for @profile.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get profile;

  /// No description provided for @debts.
  ///
  /// In fr, this message translates to:
  /// **'Dettes'**
  String get debts;

  /// No description provided for @history.
  ///
  /// In fr, this message translates to:
  /// **'Historique'**
  String get history;

  /// No description provided for @newSaleForFarmer.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle vente pour ce producteur'**
  String get newSaleForFarmer;

  /// No description provided for @noDebts.
  ///
  /// In fr, this message translates to:
  /// **'Aucune dette'**
  String get noDebts;

  /// No description provided for @allDebtsPaid.
  ///
  /// In fr, this message translates to:
  /// **'Toutes les dettes sont soldées'**
  String get allDebtsPaid;

  /// No description provided for @creditTitle.
  ///
  /// In fr, this message translates to:
  /// **'Crédit'**
  String get creditTitle;

  /// No description provided for @recordRepaymentTitle.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer remboursement'**
  String get recordRepaymentTitle;

  /// No description provided for @selectFarmer.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionner un producteur'**
  String get selectFarmer;

  /// No description provided for @paymentType.
  ///
  /// In fr, this message translates to:
  /// **'Type de paiement'**
  String get paymentType;

  /// No description provided for @cash.
  ///
  /// In fr, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @credit.
  ///
  /// In fr, this message translates to:
  /// **'Crédit'**
  String get credit;

  /// No description provided for @commodity.
  ///
  /// In fr, this message translates to:
  /// **'Commodité'**
  String get commodity;

  /// No description provided for @amount.
  ///
  /// In fr, this message translates to:
  /// **'Montant'**
  String get amount;

  /// No description provided for @kg.
  ///
  /// In fr, this message translates to:
  /// **'kg'**
  String get kg;

  /// No description provided for @allocationPreview.
  ///
  /// In fr, this message translates to:
  /// **'Aperçu de l\'allocation'**
  String get allocationPreview;

  /// No description provided for @appliedTo.
  ///
  /// In fr, this message translates to:
  /// **'Appliqué à'**
  String get appliedTo;

  /// No description provided for @confirmRepayment.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer le remboursement'**
  String get confirmRepayment;

  /// No description provided for @repaymentRecorded.
  ///
  /// In fr, this message translates to:
  /// **'Remboursement enregistré'**
  String get repaymentRecorded;

  /// No description provided for @newRepayment.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau remboursement'**
  String get newRepayment;

  /// No description provided for @back.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get back;

  /// No description provided for @debtDetail.
  ///
  /// In fr, this message translates to:
  /// **'Détail dette'**
  String get debtDetail;

  /// No description provided for @originalAmount.
  ///
  /// In fr, this message translates to:
  /// **'Montant original'**
  String get originalAmount;

  /// No description provided for @paidAmount.
  ///
  /// In fr, this message translates to:
  /// **'Montant payé'**
  String get paidAmount;

  /// No description provided for @remainingBalance.
  ///
  /// In fr, this message translates to:
  /// **'Solde restant'**
  String get remainingBalance;

  /// No description provided for @status.
  ///
  /// In fr, this message translates to:
  /// **'Statut'**
  String get status;

  /// No description provided for @open.
  ///
  /// In fr, this message translates to:
  /// **'Ouvert'**
  String get open;

  /// No description provided for @partiallyPaid.
  ///
  /// In fr, this message translates to:
  /// **'Partiellement payé'**
  String get partiallyPaid;

  /// No description provided for @closed.
  ///
  /// In fr, this message translates to:
  /// **'Soldé'**
  String get closed;

  /// No description provided for @repayments.
  ///
  /// In fr, this message translates to:
  /// **'Remboursements'**
  String get repayments;

  /// No description provided for @checkoutTitle.
  ///
  /// In fr, this message translates to:
  /// **'Caisse'**
  String get checkoutTitle;

  /// No description provided for @paymentMethod.
  ///
  /// In fr, this message translates to:
  /// **'Mode de paiement'**
  String get paymentMethod;

  /// No description provided for @subtotal.
  ///
  /// In fr, this message translates to:
  /// **'Sous-total'**
  String get subtotal;

  /// No description provided for @interest.
  ///
  /// In fr, this message translates to:
  /// **'Intérêt'**
  String get interest;

  /// No description provided for @total.
  ///
  /// In fr, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @finalizeSale.
  ///
  /// In fr, this message translates to:
  /// **'Finaliser la vente'**
  String get finalizeSale;

  /// No description provided for @itemsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} articles'**
  String itemsCount(Object count);

  /// No description provided for @onlineSynced.
  ///
  /// In fr, this message translates to:
  /// **'En ligne — synchronisé'**
  String get onlineSynced;

  /// No description provided for @offlinePending.
  ///
  /// In fr, this message translates to:
  /// **'Hors ligne — en attente de sync'**
  String get offlinePending;

  /// No description provided for @transactionConfirmation.
  ///
  /// In fr, this message translates to:
  /// **'Transaction confirmée'**
  String get transactionConfirmation;

  /// No description provided for @transactionDetail.
  ///
  /// In fr, this message translates to:
  /// **'Détail transaction'**
  String get transactionDetail;

  /// No description provided for @newSaleCTA.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle vente'**
  String get newSaleCTA;

  /// No description provided for @shareReceipt.
  ///
  /// In fr, this message translates to:
  /// **'Partager reçu'**
  String get shareReceipt;

  /// No description provided for @reference.
  ///
  /// In fr, this message translates to:
  /// **'Référence'**
  String get reference;

  /// No description provided for @date.
  ///
  /// In fr, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @syncStatus.
  ///
  /// In fr, this message translates to:
  /// **'Statut de sync'**
  String get syncStatus;

  /// No description provided for @synced.
  ///
  /// In fr, this message translates to:
  /// **'Synchronisé'**
  String get synced;

  /// No description provided for @offline.
  ///
  /// In fr, this message translates to:
  /// **'Hors ligne'**
  String get offline;

  /// No description provided for @pending.
  ///
  /// In fr, this message translates to:
  /// **'En attente'**
  String get pending;

  /// No description provided for @syncTitle.
  ///
  /// In fr, this message translates to:
  /// **'Synchronisation'**
  String get syncTitle;

  /// No description provided for @syncInProgress.
  ///
  /// In fr, this message translates to:
  /// **'Synchronisation en cours...'**
  String get syncInProgress;

  /// No description provided for @syncNow.
  ///
  /// In fr, this message translates to:
  /// **'Synchroniser maintenant'**
  String get syncNow;

  /// No description provided for @pendingSection.
  ///
  /// In fr, this message translates to:
  /// **'En attente'**
  String get pendingSection;

  /// No description provided for @failedSection.
  ///
  /// In fr, this message translates to:
  /// **'Échoué'**
  String get failedSection;

  /// No description provided for @retry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get retry;

  /// No description provided for @syncIssues.
  ///
  /// In fr, this message translates to:
  /// **'Problèmes de synchronisation'**
  String get syncIssues;

  /// No description provided for @settingsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get settingsTitle;

  /// No description provided for @appearance.
  ///
  /// In fr, this message translates to:
  /// **'Apparence'**
  String get appearance;

  /// No description provided for @theme.
  ///
  /// In fr, this message translates to:
  /// **'Thème'**
  String get theme;

  /// No description provided for @light.
  ///
  /// In fr, this message translates to:
  /// **'Clair'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In fr, this message translates to:
  /// **'Sombre'**
  String get dark;

  /// No description provided for @language.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get language;

  /// No description provided for @french.
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get french;

  /// No description provided for @english.
  ///
  /// In fr, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In fr, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @lastSync.
  ///
  /// In fr, this message translates to:
  /// **'Dernière sync'**
  String get lastSync;

  /// No description provided for @account.
  ///
  /// In fr, this message translates to:
  /// **'Compte'**
  String get account;

  /// No description provided for @changePassword.
  ///
  /// In fr, this message translates to:
  /// **'Changer mot de passe'**
  String get changePassword;

  /// No description provided for @about.
  ///
  /// In fr, this message translates to:
  /// **'À propos'**
  String get about;

  /// No description provided for @cancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer'**
  String get confirm;

  /// No description provided for @delete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get edit;

  /// No description provided for @close.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get close;

  /// No description provided for @error.
  ///
  /// In fr, this message translates to:
  /// **'Erreur'**
  String get error;

  /// No description provided for @success.
  ///
  /// In fr, this message translates to:
  /// **'Succès'**
  String get success;

  /// No description provided for @warning.
  ///
  /// In fr, this message translates to:
  /// **'Attention'**
  String get warning;

  /// No description provided for @loading.
  ///
  /// In fr, this message translates to:
  /// **'Chargement...'**
  String get loading;

  /// No description provided for @noResults.
  ///
  /// In fr, this message translates to:
  /// **'Aucun résultat'**
  String get noResults;

  /// No description provided for @tryAgain.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get tryAgain;

  /// No description provided for @requiredField.
  ///
  /// In fr, this message translates to:
  /// **'Ce champ est obligatoire'**
  String get requiredField;

  /// No description provided for @invalidEmail.
  ///
  /// In fr, this message translates to:
  /// **'Adresse email invalide'**
  String get invalidEmail;

  /// No description provided for @invalidPhone.
  ///
  /// In fr, this message translates to:
  /// **'Numéro de téléphone invalide'**
  String get invalidPhone;

  /// No description provided for @minLength.
  ///
  /// In fr, this message translates to:
  /// **'Minimum {min} caractères'**
  String minLength(Object min);

  /// No description provided for @currency.
  ///
  /// In fr, this message translates to:
  /// **'FCFA'**
  String get currency;

  /// No description provided for @noFarmers.
  ///
  /// In fr, this message translates to:
  /// **'Aucun producteur enregistré'**
  String get noFarmers;

  /// No description provided for @noSearchResults.
  ///
  /// In fr, this message translates to:
  /// **'Aucun résultat pour cette recherche'**
  String get noSearchResults;

  /// No description provided for @noProducts.
  ///
  /// In fr, this message translates to:
  /// **'Aucun produit disponible'**
  String get noProducts;

  /// No description provided for @uncategorized.
  ///
  /// In fr, this message translates to:
  /// **'Non catégorisé'**
  String get uncategorized;

  /// No description provided for @errorLoading.
  ///
  /// In fr, this message translates to:
  /// **'Erreur de chargement'**
  String get errorLoading;

  /// No description provided for @noData.
  ///
  /// In fr, this message translates to:
  /// **'Aucune donnée disponible'**
  String get noData;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
