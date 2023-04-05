import '../features/login/Services/login_services.dart';
import '../features/transactions/presentation/redux/transactions_action.dart';
import 'core_importer.dart';

class GeneralApis {
  static Future<List<ShopperModel>> getShoppers() async {
    try {
      var response = await ApiProvider.sendRequest(url: shopperApi, method: HttpMethods.get);

      if (response.statusCode == successCode) {
        StaticVariables.allShoppers = shoppersFromJson(jsonEncode(response.data)).data;
      }
      return StaticVariables.allShoppers;
    } catch (e) {
      return null;
    }
  }

  static Future<Level> getLevelService(String levelId) async {
    try {
      var response = await ApiProvider.sendRequest(url: level + levelId, method: HttpMethods.get);

      if (response.statusCode == successCode) return LevelModelResponse.fromJson(response.data).data;
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Level>> getLevels() async {
    try {
      var response = await ApiProvider.sendRequest(url: level, method: HttpMethods.get);

      if (response.statusCode == successCode) return LevelsResponse.fromJson(response.data).levels;
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

  static Future<List<Warehouse>> getWarehousesService() async {
    try {
      var response = await ApiProvider.sendRequest(url: warehouse, method: HttpMethods.get);

      if (response.statusCode == successCode && response.data['success'].toString() == 'true') {
        StaticVariables.warehouses = List<Warehouse>.from(response.data['data'].map((x) => Warehouse.fromJson(x)));
        StaticVariables.warehouses.removeWhere((warehouse) => warehouse.isActive == 0);
      }
      return StaticVariables.warehouses;
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

  static Future<bool> getSubWarehouse({BuildContext context}) async {
    try {
      StaticVariables.subWarehouses.clear();
      SharedPreferences prefs = await SharedPreferences.getInstance();

      List<SubWarehouse> response = await LoginServices.getAdmin(adminId: prefs.getString('adminId'), context: context);

      if (response != null) {
        StaticVariables.subWarehouses.addAll(response);
        return true;
      }
      return false;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> getSupportedCity() async {
    try {
      var response = await ApiProvider.sendRequest(url: supportedCity, method: HttpMethods.get);
      if (response.statusCode == successCode) {
        final supportedCitiesResponse = supportedCityOriginalFromJson(jsonEncode(response.data));

        StaticVariables.supportedCitiesListIntro.clear();

        StaticVariables.supportedCitiesListIntro.addAll(supportedCitiesResponse.data);

        return true;
      }
      return false;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> getCategoryService() async {
    try {
      var response = await ApiProvider.sendRequest(url: getCategory, method: HttpMethods.get);

      if (response.statusCode == successCode) {
        StaticVariables.categoryList.clear();
        StaticVariables.fullCategoryList.clear();
        final categories = categoryOriginalFromJson(jsonEncode(response.data)).data;
        StaticVariables.fullCategoryList = categories
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

        StaticVariables.fullCategoryList.addAll(categories
            .where((category) => category.parentCategoryId != null)
            .toList()
            .map((category) => DropdownMenuItem(
                child: Text(category.name, style: warehouseStyle.copyWith(fontSize: 18)),
                value: category.name + ';' + category.id.toString()))
            .toList());
        StaticVariables.categoryList = categories
            .where((category) => category.warehouses.isNotEmpty && category.warehouses[0].pivot.isActive == '1')
            .toList();

        StaticVariables.categoryList.sort((a, b) {
          if ((int.parse(a.warehouses[0].pivot.priority)) > (int.parse(b.warehouses[0].pivot.priority))) {
            return 1;
          } else if ((int.parse(a.warehouses[0].pivot.priority) < (int.parse(b.warehouses[0].pivot.priority)))) {
            return -1;
          } else {
            return 0;
          }
        });
        return true;
      }
      return false;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> fetchStartInformation({BuildContext context}) async {
    try {
      var store = StoreProvider.of<AppState>(context);
      bool userLoggedIn = await Services.checkIfUserLoggedIn();
      if (userLoggedIn) {
        List responses;
        responses = await Future.wait([
          getSupportedCity(),
          getSubWarehouse(context: context),
          getCategoryService(),
          GeneralApis.getWarehousesService(),
          Services.initializeVariables()
        ]);
        if (Services.isOperationManager() || Services.isAdmin() || Services.isAccounting()) {
          await GeneralApis.getShoppers();
          StaticVariables.levels = await GeneralApis.getLevels();
        }
        if (store.state.adminsState.admin.permissions.contains('transaction-permission')) {
          store.dispatch(GetTransactionCategoriesAction());
        }

        if (responses[1] == null) {
          Services.initializeVariables();
        } else {
          return responses[0] && responses[1];
        }
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
