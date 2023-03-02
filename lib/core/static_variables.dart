import '../features/admins/data/models/admin_model.dart';
import '../features/reports/models/transaction_type_model.dart';
import 'core_importer.dart';

class StaticVariables {
  static CompanyOriginalData companyInformation = CompanyOriginalData();
  static List<Level> levels = [];

  static List<CategoryOriginalData> categoryList = [];

  static List<SubWarehouse> subWarehouses = [];
  static List<Warehouse> warehouses = [];

  static List<DropdownMenuItem> fullCategoryList = [];

  static String imagePrefixUrl = '';

  static List<FadeInImage> bannerListNetwork = [];

  // Mobile Configuration variables
  static String androidShareUrl = '';
  static String iOSShareUrl = '';
  static bool serverMaintain = false;
  static bool updateRequired = false;
  static bool updateOptional = false;

  static String systemMaintenanceMessages;

  // Supported City variables

  static List<IndigoDatum> supportedCitiesListIntro = [];

  // User Variables
  static List<ProductData> allProducts = [];
  static List<ProductData> notAddedProducts = [];
  static List<OrdersOriginalData> myOrdersList = [];
  static List<OrdersOriginalData> allOrdersList = [];
  static List<OrdersOriginalData> phoneOrderList = [];
  static List<ShopperModel> allShoppers = [];
  static List<TransactionTypeModel> transactionTypes = [];
  static AdminModel admin = const AdminModel(phone: '0000000000');
  static bool preferLeftSide = true;
  static int ordersViewFilter = 0;

  static List<Role> roles = [];
  static ShopperModel shopper;
  static bool updateOption = false;

  static String productToAddName = 'null';

  static int deliveryPrice = 50;
}
