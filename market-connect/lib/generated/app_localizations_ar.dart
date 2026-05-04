// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'مارشيه كونيكت';

  @override
  String get appVersion => 'v1.0.0';

  @override
  String get loginTitle => 'مارشيه كونيكت';

  @override
  String get loginSubtitle => 'سجل الدخول للمتابعة';

  @override
  String get emailLabel => 'عنوان البريد الإلكتروني';

  @override
  String get emailHint => 'operateur@marche.ci';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get passwordHint => '••••••••';

  @override
  String get rememberMe => 'تذكرني';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get logoutConfirm => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get homeTitle => 'الرئيسية';

  @override
  String get newSale => 'بيع جديد';

  @override
  String get recordRepayment => 'تسجيل سداد';

  @override
  String get todayStats => 'اليوم';

  @override
  String get salesToday => 'المبيعات اليوم';

  @override
  String get totalFcfa => 'المجموع FCFA';

  @override
  String get offlineBanner => 'وضع عدم الاتصال — سيتم مزامنة البيانات تلقائيًا';

  @override
  String get catalogTitle => 'الكتالوج';

  @override
  String get searchProduct => 'البحث عن منتج...';

  @override
  String get all => 'الكل';

  @override
  String get cereals => 'الحبوب';

  @override
  String get tubers => 'الدرنات';

  @override
  String get fruits => 'الفواكه';

  @override
  String get vegetables => 'الخضروات';

  @override
  String get oils => 'الزيوت';

  @override
  String get add => 'إضافة';

  @override
  String get addToCart => 'أضف إلى السلة';

  @override
  String get productDetail => 'تفاصيل المنتج';

  @override
  String get category => 'الفئة';

  @override
  String get unit => 'الوحدة';

  @override
  String get description => 'الوصف';

  @override
  String get quantity => 'الكمية';

  @override
  String get farmersTitle => 'المزارعون';

  @override
  String get searchFarmer => 'البحث بالبطاقة أو الهاتف...';

  @override
  String get newFarmer => 'مزارع جديد';

  @override
  String get farmerRegistration => 'مزارع جديد';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get cardNumber => 'رقم البطاقة';

  @override
  String get phone => 'الهاتف';

  @override
  String get location => 'الموقع';

  @override
  String get creditLimit => 'حد الائتمان';

  @override
  String get creditLimitOptional => 'حد الائتمان (اختياري)';

  @override
  String get save => 'حفظ';

  @override
  String get farmerDetail => 'تفاصيل المزارع';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get debts => 'الديون';

  @override
  String get history => 'السجل';

  @override
  String get newSaleForFarmer => 'بيع جديد لهذا المزارع';

  @override
  String get noDebts => 'لا توجد ديون';

  @override
  String get allDebtsPaid => 'جميع الديون مسددة';

  @override
  String get creditTitle => 'الائتمان';

  @override
  String get recordRepaymentTitle => 'تسجيل سداد';

  @override
  String get selectFarmer => 'اختيار مزارع';

  @override
  String get paymentType => 'نوع الدفع';

  @override
  String get cash => 'نقدي';

  @override
  String get credit => 'ائتمان';

  @override
  String get commodity => 'سلعة';

  @override
  String get amount => 'المبلغ';

  @override
  String get kg => 'كجم';

  @override
  String get allocationPreview => 'معاينة التخصيص';

  @override
  String get appliedTo => 'مطبق على';

  @override
  String get confirmRepayment => 'تأكيد السداد';

  @override
  String get repaymentRecorded => 'تم تسجيل السداد';

  @override
  String get newRepayment => 'سداد جديد';

  @override
  String get back => 'رجوع';

  @override
  String get debtDetail => 'تفاصيل الدين';

  @override
  String get originalAmount => 'المبلغ الأصلي';

  @override
  String get paidAmount => 'المبلغ المسدد';

  @override
  String get remainingBalance => 'الرصيد المتبقي';

  @override
  String get status => 'الحالة';

  @override
  String get open => 'مفتوح';

  @override
  String get partiallyPaid => 'مدفوع جزئيًا';

  @override
  String get closed => 'مغلق';

  @override
  String get repayments => 'السدادات';

  @override
  String get checkoutTitle => 'الدفع';

  @override
  String get paymentMethod => 'طريقة الدفع';

  @override
  String get subtotal => 'المجموع الفرعي';

  @override
  String get interest => 'الفائدة';

  @override
  String get total => 'المجموع';

  @override
  String get finalizeSale => 'إتمام البيع';

  @override
  String itemsCount(Object count) {
    return '$count عناصر';
  }

  @override
  String get onlineSynced => 'متصل — متزامن';

  @override
  String get offlinePending => 'غير متصل — في انتظار المزامنة';

  @override
  String get transactionConfirmation => 'تم تأكيد المعاملة';

  @override
  String get transactionDetail => 'تفاصيل المعاملة';

  @override
  String get newSaleCTA => 'بيع جديد';

  @override
  String get shareReceipt => 'مشاركة الإيصال';

  @override
  String get reference => 'المرجع';

  @override
  String get date => 'التاريخ';

  @override
  String get syncStatus => 'حالة المزامنة';

  @override
  String get synced => 'متزامن';

  @override
  String get offline => 'غير متصل';

  @override
  String get pending => 'معلق';

  @override
  String get syncTitle => 'المزامنة';

  @override
  String get syncInProgress => 'جاري المزامنة...';

  @override
  String get syncNow => 'مزامنة الآن';

  @override
  String get pendingSection => 'معلق';

  @override
  String get failedSection => 'فشل';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get syncIssues => 'مشاكل المزامنة';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get appearance => 'المظهر';

  @override
  String get theme => 'السمة';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get language => 'اللغة';

  @override
  String get french => 'Français';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get lastSync => 'آخر مزامنة';

  @override
  String get account => 'الحساب';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get about => 'حول';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تأكيد';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get close => 'إغلاق';

  @override
  String get error => 'خطأ';

  @override
  String get success => 'نجاح';

  @override
  String get warning => 'تحذير';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get noResults => 'لا توجد نتائج';

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String get requiredField => 'هذا الحقل مطلوب';

  @override
  String get invalidEmail => 'عنوان بريد إلكتروني غير صالح';

  @override
  String get invalidPhone => 'رقم هاتف غير صالح';

  @override
  String minLength(Object min) {
    return 'الحد الأدنى $min أحرف';
  }

  @override
  String get currency => 'FCFA';

  @override
  String get noFarmers => 'لا يوجد مزارعون مسجلون';

  @override
  String get noSearchResults => 'لا توجد نتائج لهذا البحث';

  @override
  String get noProducts => 'لا توجد منتجات متاحة';

  @override
  String get uncategorized => 'غير مصنف';

  @override
  String get errorLoading => 'خطأ في التحميل';

  @override
  String get creditSurplus => 'فائض الائتمان';

  @override
  String get noData => 'لا توجد بيانات متاحة';
}
