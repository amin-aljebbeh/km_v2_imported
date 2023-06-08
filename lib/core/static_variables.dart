import 'package:kammun_app/features/products/domain/entities/product_entity.dart';

import 'core_importer.dart';
import 'models/shopper_model.dart';

class StaticVariables {
  static List<Level> levels = [];

  static String imagePrefixUrl = '';

  // Mobile Configuration variables
  static bool updateRequired = false;

  // Supported City variables

  static List<IndigoDatum> supportedCitiesListIntro = [];

  // User Variables
  static List<ProductEntity> allProducts = [];
  static List<ProductEntity> notAddedProducts = [];
  static bool preferLeftSide = true;

  static ShopperModel shopper;

  static String productToAddName = 'null';
}
