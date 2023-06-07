import 'package:kammun_app/features/categories/domain/entities/category_entity.dart';
import 'package:kammun_app/features/products/domain/entities/product_entity.dart';

import 'core_importer.dart';
import 'models/shopper_model.dart';

class StaticVariables {
  static CompanyOriginalData companyInformation = CompanyOriginalData();
  static List<Level> levels = [];

  static List<CategoryEntity> categoryList = [];

  static List<SubWarehouse> subWarehouses = [];
  static List<Warehouse> warehouses = [];

  static List<DropdownMenuItem> fullCategoryList = [];

  static String imagePrefixUrl = '';

  static List<FadeInImage> bannerListNetwork = [];

  // Mobile Configuration variables
  static String androidShareUrl = '';
  static String iOSShareUrl = '';
  static bool updateRequired = false;
  static bool updateOptional = false;

  static String systemMaintenanceMessages;

  // Supported City variables

  static List<IndigoDatum> supportedCitiesListIntro = [];

  // User Variables
  static List<ProductEntity> allProducts = [];
  static List<ProductEntity> notAddedProducts = [];
  static bool preferLeftSide = true;

  static ShopperModel shopper;
  static bool updateOption = false;

  static String productToAddName = 'null';

  static int deliveryPrice = 50;
}
