import 'package:intl/intl.dart';
import 'package:kammun_app/core/core_importer.dart';

String kammun = 'كمُّون';

//Font
String fontFamily = 'Tajawal';

// App Name
String ratingOrder = 'تقييم الطلب';

String cancelOrder = 'إلغاء الطلب';
String edit = 'تعديل';

String editOrder = 'تعديل الطلب';
String submitFeedback = 'تقييم الطلب';

//Labels
String signIn = 'تسجيل الدخول';
String bill = 'الفاتورة : ';
String phoneNumberString = 'الهاتف :';
String entrance = 'المدخل: ';

// Tabs
String store = 'الرئيسية';
String cart = 'السلة';
String orders = 'الطلبات';
String profile = 'الملف الشخصي';
String financial = 'الحسابات';
String inventory = 'جرد المنتجات';
String productManagement = 'إدارة المنتجات';
String adminPanel = 'لوحة تحكم المدير';

String search = 'بحث';
String shopByCategory = 'الأصناف';

String shoppingCart = 'سلة  المشتريات';
String confirmOrder = 'تأكيد الطلب';

String subtotalString = 'المجموع';
String delivery = 'إجرة التوصيل';
String totalString = 'المجموع الكلي';

String note = 'ملاحظة';

String thankYou = 'شكراً لطلبك عن طريق كمّـون';
String thankYouDescribe =
    'تم إستلام طلبك بنجاح، يمكنك الآن العودة للقائمة الرئيسة و الذهاب لصفحة الطلبات لتفقد حالة الطلب';

String continueShopping = 'متابعة التسوق';

String address = 'العنوان';
String city = 'المدينة: ';

//Roles:
String shopperRole = 'shopper';
String adminRole = 'admin';
String superAdminRole = 'super-admin';
String operationManager = 'operation-manager';
String productsController = 'product-management';
String supplierRol = 'supplier-role';
String accountingRole = 'accounting-role';
String viewPriceRate = 'view-price-rate';

//Order icons:
String myOrders = 'طلباتي';

//Buttons text:
String watchNote = 'مشاهدة ملاحظة العميل';
String close = 'إغلاق';
String unLock = 'إلغاء التعليق';
String yes = 'نعم';
String no = 'لا';
String save = 'حفظ';
String tryAgain = 'إعادة المحاولة';
String next = 'التالي';
String addToCart = 'الإضافة للسلة';
String send = 'إرسال';
String add = 'إضافة';
String addTransaction = 'إضافة مناقلة';

//Labels:
String shopperName = 'مسؤول الطلب : ';
String orderDate = 'تاريخ الطلب : ';
String quantity = 'الكمية';
String priceString = 'السعر ';
String description = 'الوصف ';
String outOfStock = 'المنتج نفذ من المستودعات';
String supplierCode = 'رمز المادة';
String priceFactor = 'معدل الضرب';
String name = 'الاسم :';
String unit = 'الوحدة';
String priority = 'الأولوية';
String logout = 'تسجيل الخروج';
String shopper = 'متسوق';
String shoppingProfits = 'مرابح التسوق';
String deliveryProfits = 'مرابح التوصيل';
String totalSales = 'إجمالي المبيعات';
String ordersCount = 'عدد الطلبات';

//Dialogs:
String costumerNote = 'ملاحظة العميل';
String unLockConfirm =
    'هل أنت متأكد انك تريد إلغاء تعليق الطلب قيامك بهذه العملية قد يلغي التعديلات التي يقوم بها الزبون او شريكك في العمل';

//Messages:
String chooseShopper = 'اختر متسوق';
String errorMessage = 'حدث خطأ اثناء محاولة جلب البيانات';

List<String> productFilter = ['الغير مفعلة', 'عدد مرات البيع', 'عدد مرات العرض', 'المنتجات المحذوفة'];

List<String> productFilterUrls = [
  filterByLastActivationDate,
  filterByNumberOfSales,
  filterByNumberOfVisits,
  productsDeletedFromOrders
];

List<String> productFilterParams = ['number_of_days', 'number_of_sale', 'number_of_visit'];

List<String> orderTypes = ['جميع الطلبات', 'مسند لمتسوق', 'بحاجة لمتسوق'];

List<String> orderStatus = [
  'فلترة الطلبات',
  'قيد المعالجة',
  'تم قبولها',
  'تم تجهيزها',
  'مع التوصيل',
  'تم توصيلها',
  'تم إلغائها',
  'تم رفضها'
];

List<String> phoneOrderStatus = [
  'بدون فلترة',
  'فلترة الطلبات',
  'قيد المعالجة',
  'تم قبولها',
  'تم تجهيزها',
  'مع التوصيل',
  'تم توصيلها',
  'تم إلغائها',
  'تم رفضها'
];

List<String> dropdownValues = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15'];

class StringUtils {
  final oCcy = NumberFormat('#,##0', 'en_US');
}
