// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Marché Connect';

  @override
  String get appVersion => 'v1.0.0';

  @override
  String get loginTitle => 'Marché Connect';

  @override
  String get loginSubtitle => 'Connectez-vous pour continuer';

  @override
  String get emailLabel => 'Adresse email';

  @override
  String get emailHint => 'operateur@marche.ci';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get passwordHint => '••••••••';

  @override
  String get rememberMe => 'Se souvenir de moi';

  @override
  String get signIn => 'Se connecter';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get logout => 'Se déconnecter';

  @override
  String get logoutConfirm => 'Voulez-vous vraiment vous déconnecter ?';

  @override
  String get homeTitle => 'Accueil';

  @override
  String get newSale => 'Nouvelle vente';

  @override
  String get recordRepayment => 'Enregistrer remboursement';

  @override
  String get todayStats => 'Aujourd\'hui';

  @override
  String get salesToday => 'Ventes aujourd\'hui';

  @override
  String get totalFcfa => 'Total FCFA';

  @override
  String get offlineBanner =>
      'Mode hors ligne — Les données seront synchronisées automatiquement';

  @override
  String get catalogTitle => 'Catalogue';

  @override
  String get searchProduct => 'Rechercher un produit...';

  @override
  String get all => 'Tout';

  @override
  String get cereals => 'Céréales';

  @override
  String get tubers => 'Tubercules';

  @override
  String get fruits => 'Fruits';

  @override
  String get vegetables => 'Légumes';

  @override
  String get oils => 'Huiles';

  @override
  String get add => 'Ajouter';

  @override
  String get addToCart => 'Ajouter au panier';

  @override
  String get productDetail => 'Détail produit';

  @override
  String get category => 'Catégorie';

  @override
  String get unit => 'Unité';

  @override
  String get description => 'Description';

  @override
  String get quantity => 'Quantité';

  @override
  String get farmersTitle => 'Producteurs';

  @override
  String get searchFarmer => 'Rechercher par carte ou téléphone...';

  @override
  String get newFarmer => 'Nouveau producteur';

  @override
  String get farmerRegistration => 'Nouveau producteur';

  @override
  String get fullName => 'Nom complet';

  @override
  String get cardNumber => 'Numéro de carte';

  @override
  String get phone => 'Téléphone';

  @override
  String get location => 'Localisation';

  @override
  String get creditLimit => 'Limite de crédit';

  @override
  String get creditLimitOptional => 'Limite de crédit (optionnel)';

  @override
  String get save => 'Enregistrer';

  @override
  String get farmerDetail => 'Détail producteur';

  @override
  String get profile => 'Profil';

  @override
  String get debts => 'Dettes';

  @override
  String get history => 'Historique';

  @override
  String get newSaleForFarmer => 'Nouvelle vente pour ce producteur';

  @override
  String get noDebts => 'Aucune dette';

  @override
  String get allDebtsPaid => 'Toutes les dettes sont soldées';

  @override
  String get creditTitle => 'Crédit';

  @override
  String get recordRepaymentTitle => 'Enregistrer remboursement';

  @override
  String get selectFarmer => 'Sélectionner un producteur';

  @override
  String get paymentType => 'Type de paiement';

  @override
  String get cash => 'Cash';

  @override
  String get credit => 'Crédit';

  @override
  String get commodity => 'Commodité';

  @override
  String get amount => 'Montant';

  @override
  String get kg => 'kg';

  @override
  String get allocationPreview => 'Aperçu de l\'allocation';

  @override
  String get appliedTo => 'Appliqué à';

  @override
  String get confirmRepayment => 'Confirmer le remboursement';

  @override
  String get repaymentRecorded => 'Remboursement enregistré';

  @override
  String get newRepayment => 'Nouveau remboursement';

  @override
  String get back => 'Retour';

  @override
  String get debtDetail => 'Détail dette';

  @override
  String get originalAmount => 'Montant original';

  @override
  String get paidAmount => 'Montant payé';

  @override
  String get remainingBalance => 'Solde restant';

  @override
  String get status => 'Statut';

  @override
  String get open => 'Ouvert';

  @override
  String get partiallyPaid => 'Partiellement payé';

  @override
  String get closed => 'Soldé';

  @override
  String get repayments => 'Remboursements';

  @override
  String get checkoutTitle => 'Caisse';

  @override
  String get paymentMethod => 'Mode de paiement';

  @override
  String get subtotal => 'Sous-total';

  @override
  String get interest => 'Intérêt';

  @override
  String get total => 'Total';

  @override
  String get finalizeSale => 'Finaliser la vente';

  @override
  String itemsCount(Object count) {
    return '$count articles';
  }

  @override
  String get onlineSynced => 'En ligne — synchronisé';

  @override
  String get offlinePending => 'Hors ligne — en attente de sync';

  @override
  String get transactionConfirmation => 'Transaction confirmée';

  @override
  String get transactionDetail => 'Détail transaction';

  @override
  String get newSaleCTA => 'Nouvelle vente';

  @override
  String get shareReceipt => 'Partager reçu';

  @override
  String get reference => 'Référence';

  @override
  String get date => 'Date';

  @override
  String get syncStatus => 'Statut de sync';

  @override
  String get synced => 'Synchronisé';

  @override
  String get offline => 'Hors ligne';

  @override
  String get pending => 'En attente';

  @override
  String get syncTitle => 'Synchronisation';

  @override
  String get syncInProgress => 'Synchronisation en cours...';

  @override
  String get syncNow => 'Synchroniser maintenant';

  @override
  String get pendingSection => 'En attente';

  @override
  String get failedSection => 'Échoué';

  @override
  String get retry => 'Réessayer';

  @override
  String get syncIssues => 'Problèmes de synchronisation';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get appearance => 'Apparence';

  @override
  String get theme => 'Thème';

  @override
  String get light => 'Clair';

  @override
  String get dark => 'Sombre';

  @override
  String get language => 'Langue';

  @override
  String get french => 'Français';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get lastSync => 'Dernière sync';

  @override
  String get account => 'Compte';

  @override
  String get changePassword => 'Changer mot de passe';

  @override
  String get about => 'À propos';

  @override
  String get cancel => 'Annuler';

  @override
  String get confirm => 'Confirmer';

  @override
  String get delete => 'Supprimer';

  @override
  String get edit => 'Modifier';

  @override
  String get close => 'Fermer';

  @override
  String get error => 'Erreur';

  @override
  String get success => 'Succès';

  @override
  String get warning => 'Attention';

  @override
  String get loading => 'Chargement...';

  @override
  String get noResults => 'Aucun résultat';

  @override
  String get tryAgain => 'Réessayer';

  @override
  String get requiredField => 'Ce champ est obligatoire';

  @override
  String get invalidEmail => 'Adresse email invalide';

  @override
  String get invalidPhone => 'Numéro de téléphone invalide';

  @override
  String minLength(Object min) {
    return 'Minimum $min caractères';
  }

  @override
  String get currency => 'FCFA';

  @override
  String get noFarmers => 'Aucun producteur enregistré';

  @override
  String get noSearchResults => 'Aucun résultat pour cette recherche';

  @override
  String get noProducts => 'Aucun produit disponible';

  @override
  String get uncategorized => 'Non catégorisé';

  @override
  String get errorLoading => 'Erreur de chargement';

  @override
  String get creditSurplus => 'Surplus de crédit';

  @override
  String get noData => 'Aucune donnée disponible';
}
