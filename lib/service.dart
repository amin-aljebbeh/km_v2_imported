import 'package:flushbar/flushbar.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import 'core/core_importer.dart';
import 'views/loading/loading_services.dart';

class Services {
  static List<Role> roles = [];
  static ShopperModel shopper;
  static bool updateOption = false;

  static String productToAddName = 'null';

  static int deliveryPrice = 50;

  static Future<List<OrdersOriginalData>> getAllOrders({int pageNumber = 1}) async {
    try {
      var response =
          await ApiProvider.sendRequest(url: order, method: HttpMethods.get, queryParameters: {'page': pageNumber});

      if (response.statusCode == successCode) {
        LoadingScreenServices.allOrdersList = ordersFromJson(jsonEncode(response.data)).data.data;
      }
      return LoadingScreenServices.allOrdersList;
    } catch (e) {
      return null;
    }
  }

  static Future<void> logOutAdmin(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    baseUrl = appUrl;
    await preferences.clear();
    KammunRestart.restartApp(context);
  }

  static Future<List<ShopperModel>> getShoppers() async {
    try {
      var response = await ApiProvider.sendRequest(url: getShopper, method: HttpMethods.get);

      if (response.statusCode == successCode) {
        LoadingScreenServices.allShoppers = shoppersFromJson(jsonEncode(response.data)).data;
      }
      return LoadingScreenServices.allShoppers;
    } catch (e) {
      return null;
    }
  }

  static Future<Level> getLevelService(String levelId) async {
    try {
      var response = await ApiProvider.sendRequest(url: getLevel + levelId, method: HttpMethods.get);

      if (response.statusCode == successCode) {
        Level level = LevelModelResponse.fromJson(response.data).data;
        return level;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<List<Level>> getLevels() async {
    try {
      var response = await ApiProvider.sendRequest(url: getLevel, method: HttpMethods.get);

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
      var response = await ApiProvider.sendRequest(url: getWarehouses, method: HttpMethods.get);

      if (response.statusCode == successCode && response.data['success'].toString() == 'true') {
        LoadingScreenServices.warehouses =
            List<Warehouse>.from(response.data['data'].map((x) => Warehouse.fromJson(x)));
      }
      return LoadingScreenServices.warehouses;
    } catch (e) {
      return null;
    }
  }

  static List<DropdownMenuItem<int>> inventorySubWarehouseNames() {
    List<String> names = LoadingScreenServices.subWarehouses.map((subWarehouse) => subWarehouse.name).toList();
    names.add('الجميع');
    return dropdownStringList(names);
  }

  static List<DropdownMenuItem<int>> transactionTypesNames() {
    List<String> names = LoadingScreenServices.transactionTypes
        .where((type) => type.automatic == 0)
        .map((type) => type.arabicName)
        .toList();
    return dropdownStringList(names);
  }

  static List<DropdownMenuItem<String>> productSubWarehouseNames(BuildContext context) {
    List<DropdownMenuItem<String>> names = LoadingScreenServices.subWarehouses
        .map((subWarehouse) => DropdownMenuItem<String>(
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.68,
                  child: Text(subWarehouse.name, style: warehouseStyle)),
              value: subWarehouse.id.toString(),
            ))
        .toList();
    return names;
  }

  static List<DropdownMenuItem<int>> dropdownIntList(List<String> inputList) {
    List<DropdownMenuItem<int>> list = inputList
        .asMap()
        .map((value, string) =>
            MapEntry(value, DropdownMenuItem<int>(child: Text(string, style: dropdownItemStyle), value: value + 1)))
        .values
        .toList();
    return list;
  }

  static List<DropdownMenuItem<int>> dropdownStringList(List<String> inputList) {
    List<DropdownMenuItem<int>> list = inputList
        .asMap()
        .map((value, string) => MapEntry(
            value, DropdownMenuItem<int>(child: Center(child: Text(string, style: dropdownItemStyle)), value: value)))
        .values
        .toList();
    return list;
  }

  static List<DropdownMenuItem<String>> shoppersNameList() {
    List<DropdownMenuItem<String>> list = LoadingScreenServices.allShoppers
        .where((shopper) => shopper.status == 1)
        .map((shopper) => DropdownMenuItem<String>(
            child: Center(child: Text(shopper.name + ' ✅', style: dropdownItemStyle)), value: shopper.name))
        .toList();
    list.addAll(
      LoadingScreenServices.allShoppers
          .where((shopper) => shopper.status == 0)
          .map((shopper) => DropdownMenuItem<String>(
              child: Center(child: Text(shopper.name + ' ❌', style: dropdownItemStyle)), value: shopper.name))
          .toList(),
    );
    return list;
  }

  static bool isAdmin() => Services.roles.where((element) => element.slug.contains(StringUtils.adminRole)).isNotEmpty;

  static bool isOperationManager() =>
      Services.roles.where((element) => element.slug.contains(StringUtils.operationManager)).isNotEmpty;

  static bool isProductsController() =>
      Services.roles.where((element) => element.slug.contains(StringUtils.productsController)).isNotEmpty;

  static bool isSuperAdmin() =>
      Services.roles.where((element) => element.slug.contains(StringUtils.superAdminRole)).isNotEmpty;

  static bool isAccounting() =>
      Services.roles.where((element) => element.slug.contains(StringUtils.accountingRole)).isNotEmpty;

  static bool isShopper() =>
      Services.roles.where((element) => element.slug.contains(StringUtils.shopperRole)).isNotEmpty;

  static bool isSupplierManager() =>
      Services.roles.where((element) => element.slug.contains(StringUtils.supplierRol)).isNotEmpty;

  static errorFlushBar(BuildContext context) => Flushbar(
        backgroundColor: Colors.red[900],
        messageText: Text('فشل في العملية يرجى المحاولة من جديد', style: flushBarStyle),
        boxShadows: const [BoxShadow(color: Colors.red, offset: Offset(0.0, 2.0), blurRadius: 3.0)],
        icon: const Icon(Icons.close, size: 28.0, color: Colors.white),
        duration: const Duration(seconds: 2),
      )..show(context);

  static successFlushBar(BuildContext context) => Flushbar(
        backgroundColor: Colors.green,
        messageText: Text('تمت العملية بنجاح', style: flushBarStyle),
        boxShadows: [BoxShadow(color: ColorUtils.primaryColor, offset: const Offset(0.0, 2.0), blurRadius: 3.0)],
        icon: const Icon(Icons.assignment_turned_in, size: 28.0, color: Colors.white),
        duration: const Duration(seconds: 1),
        leftBarIndicatorColor: ColorUtils.kmColors,
      )..show(context);

  static resultFlushBar({@required BuildContext context, @required bool result}) {
    if (result) {
      Services.successFlushBar(context);
    } else {
      Services.errorFlushBar(context);
    }
  }

  static List<ProductData> productListSort(List<ProductData> productsList) {
    productsList.sort((a, b) {
      if (a.categories.isNotEmpty && b.categories.isNotEmpty) {
        if (a.categories[0].id > b.categories[0].id) {
          return 1;
        } else {
          return -1;
        }
      } else {
        return -1;
      }
    });
    return productsList;
  }

  static String selectedShopperId(String name) => LoadingScreenServices.allShoppers
      .firstWhere((shopper) => shopper.name == name.replaceAll(' ✅', '').replaceAll(' ❌', ''))
      .id
      .toString();

  static int selectedShopperLevelId(String name) => LoadingScreenServices.allShoppers
      .firstWhere((shopper) => shopper.name == name.replaceAll(' ✅', '').replaceAll(' ❌', ''))
      .levelId;

  static int kRound(double number) {
    double doubleSum = number / 100;
    String stringSum = doubleSum.toString().split('.')[0];
    int result = int.parse(stringSum);
    result *= 100;
    return result;
  }

  static makePhoneCall(String number) async {
    String url = 'tel:$number';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static openUrl(String selected, {String mobileNumber}) async {
    String url = '';
    switch (selected) {
      case 'whatsapp':
        url = 'whatsapp://send?phone=' + LoadingScreenServices.companyInformation.whatsappNumber;
        break;
      case 'messenger':
        url = LoadingScreenServices.companyInformation.messengerUrl;
        break;
      case 'facebook':
        url = 'fb://page/' + LoadingScreenServices.companyInformation.facebookUrl.toString();
        break;
      case 'instagram':
        url = LoadingScreenServices.companyInformation.instagramUrl.toString();
        break;
      case 'website':
        url = LoadingScreenServices.companyInformation.websiteUrl.toString();
        break;
      case 'email':
        String platform = 'Android';
        if (Platform.isIOS) {
          platform = 'iPhone';
        }
        url =
            'mailto:${LoadingScreenServices.companyInformation.email}?subject=Support Request From $platform Application&body=';
        break;
      case 'number':
        url = 'tel:${LoadingScreenServices.supportPhoneNumber}';
        break;
      case 'customer_whatsapp':
        url = 'whatsapp://send?phone=' + mobileNumber;
        break;
    }
    launch(url);
  }

  static shareApp() {
    String infoMessage = 'تطبيق كمّون لتوصيل المنتجات الغذائية لباب بيتك و بأسعار منافسة\n';
    String androidGrating = '\n لتحميل التطبيق على الأندوريد \n';

    String androidUrl = androidGrating + LoadingScreenServices.iOSShareUrl;
    String iosGrating = '\n لتحميل التطبيق على الآيفون \n';
    String iPhoneUrl = iosGrating + LoadingScreenServices.androidShareUrl;

    Share.share(infoMessage + androidUrl + iPhoneUrl);
  }
}
