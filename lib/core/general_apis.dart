import '../features/admins/presentation/redux/admins_action.dart';
import '../features/general_information/data/models/supported_city_model.dart';
import '../features/general_information/data/models/warehouse_model.dart';
import '../features/general_information/domain/entities/warehouse_entity.dart';
import '../features/general_information/presentation/redux/general_information_action.dart';
import '../features/shoppers/data/models/get_shoppers_model.dart';
import '../features/shoppers/data/models/shopper_level_model.dart';
import '../features/shoppers/domain/entities/shopper_level_entity.dart';
import '../features/shoppers/presentation/redux/shoppers_action.dart';
import '../features/transactions/presentation/redux/transactions_action.dart';
import 'core_importer.dart';

class GeneralApis {
  static getShoppers({BuildContext context}) async {
    try {
      var response = await ApiProvider.sendRequest(url: shopperApi, method: HttpMethods.get);

      if (response.statusCode == successCode) {
        StoreProvider.of<AppState>(context)
            .dispatch(SetShoppers(shoppers: shoppersFromJson(jsonEncode(response.data)).data));
      }
    } catch (e) {
      return null;
    }
  }

  static Future<ShopperLevelModel> getLevelService(String levelId) async {
    try {
      var response = await ApiProvider.sendRequest(url: levelApi + levelId, method: HttpMethods.get);

      if (response.statusCode == successCode) return LevelModelResponse.fromJson(response.data).data;
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<List<ShopperLevelModel>> getLevels() async {
    try {
      var response = await ApiProvider.sendRequest(url: levelApi, method: HttpMethods.get);

      if (response.statusCode == successCode) return levelsFromJson(jsonEncode(response.data)).levels;
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> changeShopperStatusService({@required String shopperId, @required String newStatus}) async {
    Map changeStatus = {'status': newStatus};
    try {
      var response = await ApiProvider.sendRequest(
          url: changeShopperStatus + shopperId, method: HttpMethods.put, body: jsonEncode(changeStatus));

      return response.statusCode == successCode;
    } catch (e) {
      return false;
    }
  }

  static Future<List<WarehouseEntity>> getWarehousesService({BuildContext context}) async {
    try {
      var response = await ApiProvider.sendRequest(url: warehouse, method: HttpMethods.get);
      List<WarehouseEntity> warehouses;
      if (response.statusCode == successCode && response.data['success'].toString() == 'true') {
        warehouses = List<WarehouseModel>.from(response.data['data'].map((x) => WarehouseModel.fromJson(x)));
        warehouses.removeWhere((warehouse) => warehouse.isActive == 0);
        StoreProvider.of<AppState>(context).dispatch(SetWarehouses(warehouses: warehouses));
      }
      return warehouses;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> updateFirebaseTokenService(String firebaseToken) async {
    try {
      Map body = {'firebase_token': firebaseToken};
      await ApiProvider.sendRequest(url: updateFirebaseToken, method: HttpMethods.post, body: jsonEncode(body));
      return true;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> getSupportedCity(BuildContext context) async {
    try {
      var response = await ApiProvider.sendRequest(url: supportedCityApi, method: HttpMethods.get);
      if (response.statusCode == successCode) {
        final supportedCitiesResponse = SupportedCitiesResponse.fromJson((response.data)).cities;

        StoreProvider.of<AppState>(context).dispatch(SetSupportedCities(supportedCities: supportedCitiesResponse));

        return true;
      }
      return false;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> getCategoryService(BuildContext context) async {
    try {
      var response = await ApiProvider.sendRequest(url: getCategoryApi, method: HttpMethods.get);

      if (response.statusCode == successCode) {
        final categories = categoryOriginalFromJson(jsonEncode(response.data)).data;
        var fullCategoryList = categories
            .where((category) => category.parentCategoryId == 'null')
            .toList()
            .map((category) => DropdownMenuItem(
                child: Column(
                  children: [
                    SizedBox(
                        width: 287,
                        child: Text(category.name + ' من القائمة الرئيسية',
                            overflow: TextOverflow.visible, maxLines: 2, style: warehouseStyle)),
                    Padding(padding: const EdgeInsets.only(top: 8.0), child: Divider(thickness: 1, color: primaryColor))
                  ],
                ),
                value: category.name + ';' + category.id.toString()))
            .toList();

        fullCategoryList.addAll(categories
            .where((category) => category.parentCategoryId != null)
            .toList()
            .map((category) => DropdownMenuItem(
                child: Text(category.name, style: warehouseStyle.copyWith(fontSize: 18)),
                value: category.name + ';' + category.id.toString()))
            .toList());
        categories.sort((a, b) {
          if ((int.parse(a.warehouses[0].pivot.priority)) > (int.parse(b.warehouses[0].pivot.priority))) {
            return 1;
          } else if ((int.parse(a.warehouses[0].pivot.priority) < (int.parse(b.warehouses[0].pivot.priority)))) {
            return -1;
          } else {
            return 0;
          }
        });
        StoreProvider.of<AppState>(context).dispatch(SetCategoriesMenu(categories: fullCategoryList));
        StoreProvider.of<AppState>(context).dispatch(SetCategories(
            categories: categories
                .where((category) => category.warehouses.isNotEmpty && category.warehouses[0].pivot.isActive == '1')
                .toList()));

        return true;
      }
      return false;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> fetchStartInformation({BuildContext context}) async {
    try {
      SharedPreferences prefs = sl<SharedPreferences>();
      var store = StoreProvider.of<AppState>(context);
      List responses;
      responses = await Future.wait([
        getSupportedCity(context),
        store.dispatch(GetAdminAction(adminId: int.parse(prefs.getString('adminId')))),
        getCategoryService(context),
        GeneralApis.getWarehousesService(context: context),
        Services.initializeVariables(context)
      ]);
      if (Services.hasRole(context, operationManagerRole) ||
          Services.hasRole(context, adminRole) ||
          Services.hasRole(context, accountingRole)) {
        await GeneralApis.getShoppers(context: context);
        final List<ShopperLevelEntity> levels = await GeneralApis.getLevels();
        StoreProvider.of<AppState>(context).dispatch(SetLevels(levels: levels));
      }
      if (Services.hasPermission(context, transactionPermission)) {
        store.dispatch(GetTransactionCategoriesAction());
      }

      if (responses[1] == null) {
        Services.initializeVariables(context);
      } else {
        return responses[0] && responses[1];
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
