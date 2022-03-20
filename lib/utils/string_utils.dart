import 'package:intl/intl.dart';
import 'package:kammun_app/core/core_importer.dart';

class StringUtils {
  static String kammun = 'كمُّون';

  //Font
  static String fontFamilyHKGrotesk = 'Tajawal';

  // App Name
  static String ratingOrder = 'تقييم الطلب';

  static String cancelOrder = 'إلغاء الطلب';
  static String edit = 'تعديل';

  static String editOrder = 'تعديل الطلب';
  static String submitFeedback = 'تقييم الطلب';

  //Labels
  static String signIn = 'تسجيل الدخول';
  static String bill = 'الفاتورة : ';
  static String phoneNumber = 'الهاتف :';
  static String entrance = 'المدخل: ';

  // Tabs
  static String store = 'الرئيسية';
  static String cart = 'السلة';
  static String allOrders = 'كل الطلبات';
  static String profile = 'الملف الشخصي';
  static String financial = 'الحسابات';
  static String inventory = 'جرد المنتجات';
  static String productManagement = 'إدارة المنتجات';
  static String adminPanel = 'لوحة تحكم المدير';

  static String search = 'بحث';
  static String shopByCategory = 'الأصناف';

  static String shoppingCart = 'سلة  المشتريات';
  static String confirmOrder = 'تأكيد الطلب';

  static String subtotal = 'المجموع';
  static String delivery = 'إجرة التوصيل';
  static String total = 'المجموع الكلي';

  static String note = 'ملاحظة';

  static String thankYou = 'شكراً لطلبك عن طريق كمّـون';
  static String thankYouDescribe =
      'تم إستلام طلبك بنجاح، يمكنك الآن العودة للقائمة الرئيسة و الذهاب لصفحة الطلبات لتفقد حالة الطلب';

  static String continueShopping = 'متابعة التسوق';

  static String address = 'العنوان';
  static String city = 'المدينة: ';

  //Roles:
  static String shopperRole = 'shopper';
  static String deliveryRole = 'delivery';
  static String adminRole = 'admin';
  static String superAdminRole = 'super-admin';
  static String operationManager = 'operation-manager';
  static String productsController = 'product-management';
  static String supplierRol = 'supplier-role';
  static String accountingRole = 'accounting-role';

  //Order icons:
  static String myOrders = 'طلباتي';

  //Buttons text:
  static String watchNote = 'مشاهدة ملاحظة العميل';
  static String close = 'إغلاق';
  static String unLock = 'إلغاء التعليق';
  static String yes = 'نعم';
  static String no = 'لا';
  static String save = 'حفظ';
  static String tryAgain = 'إعادة المحاولة';
  static String next = 'التالي';
  static String addToCart = 'الإضافة للسلة';
  static String send = 'إرسال';
  static String add = 'إضافة';
  static String addTransaction = 'إضافة مناقلة';

//Labels:
  static String shopperName = 'مسؤول الطلب : ';
  static String orderDate = 'تاريخ الطلب : ';
  static String quantity = 'الكمية';
  static String price = 'السعر ';
  static String description = 'الوصف ';
  static String outOfStock = 'المنتج نفذ من المستودعات';
  static String supplierCode = 'رمز المادة';
  static String priceFactor = 'معدل الضرب';
  static String name = 'الاسم :';
  static String unit = 'الوحدة';
  static String priority = 'الأولوية';
  static String logout = 'تسجيل الخروج';
  static String shopper = 'متسوق';

  //Dialogs:
  static String costumerNote = 'ملاحظة العميل';
  static String unLockConfirm =
      'هل أنت متأكد انك تريد إلغاء تعليق الطلب قيامك بهذه العملية قد يلغي التعديلات التي يقوم بها الزبون او شريكك في العمل';

  //Messages:
  static String chooseShopper = 'اختر متسوق';
  static String errorMessage = 'حدث خطأ اثناء محاولة جلب البيانات';
  final oCcy = new NumberFormat('#,##0', 'en_US');

  static List<String> productFilter = ['الغير مفعلة', 'عدد مرات البيع', 'عدد مرات العرض', 'المنتجات المحذوفة'];

  static List<String> productFilterUrls = [
    FILTER_BY_LAST_ACTIVATION_DATE,
    FILTER_BY_NUMBER_OF_SALES,
    FILTER_BY_NUMBER_OF_VISITS,
    PRODUCTS_DELETED_FROM_ORDERS
  ];

  static List<String> productFilterParams = ['number_of_days', 'number_of_sale', 'number_of_visit'];

  static List<String> orderTypes = ['مسند لكابتن', 'بحاجة لكابتن', 'مسند لمتسوق', 'بحاجة لمتسوق'];

  static List<String> orderStatus = [
    'فلترة الطلبات',
    'قيد المعالجة',
    'تم قبولها',
    'تم تجهيزها',
    'مع التوصيل',
    'تم توصيلها',
    'تم إلغائها',
    'تم رفضها'
  ];

  static List<String> phoneOrderStatus = [
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

  static List<String> dropdownValues = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15'
  ];
}
