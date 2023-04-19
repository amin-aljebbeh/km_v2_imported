import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import 'core_importer.dart';

class Services {
  static List<DropdownMenuItem<int>> inventorySubWarehouseNames() {
    List<String> names = StaticVariables.subWarehouses.map((subWarehouse) => subWarehouse.name).toList();
    names.add('الجميع');
    return dropdownStringList(names);
  }

  static List<DropdownMenuItem<String>> productSubWarehouseNames(BuildContext context) => StaticVariables.subWarehouses
      .map((subWarehouse) => DropdownMenuItem<String>(
          child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.68, child: Text(subWarehouse.name, style: warehouseStyle)),
          value: subWarehouse.id.toString()))
      .toList();

  static List<DropdownMenuItem<int>> dropdownIntList({List<String> inputList}) => inputList
      .asMap()
      .map((value, string) =>
          MapEntry(value, DropdownMenuItem<int>(child: Text(string, style: dropdownItemStyle), value: value + 1)))
      .values
      .toList();

  static List<DropdownMenuItem<int>> reverseDropdownIntList({List<String> inputList}) {
    List<DropdownMenuItem<int>> result = [];
    for (int i = 0; i < inputList.length; i++) {
      result.add(DropdownMenuItem<int>(
          child: Text(inputList[i], style: dropdownItemStyle), value: inputList.length - (i + 1)));
    }
    return result;
  }

  static List<DropdownMenuItem<int>> dropdownStringList(List<String> inputList) => inputList
      .asMap()
      .map((value, string) => MapEntry(
          value, DropdownMenuItem<int>(child: Center(child: Text(string, style: dropdownItemStyle)), value: value)))
      .values
      .toList();

  static List<DropdownMenuItem<String>> shoppersNameList(BuildContext context) {
    List<DropdownMenuItem<String>> list = [];

    list.addAll(StoreProvider.of<AppState>(context)
        .state
        .shoppersState
        .shoppers
        .where((shopper) => shopper.status == 1)
        .map((shopper) => DropdownMenuItem<String>(
            child: Center(child: Text(shopper.name + ' ✅', style: dropdownItemStyle)), value: shopper.name)));
    list.addAll(StoreProvider.of<AppState>(context)
        .state
        .shoppersState
        .shoppers
        .where((shopper) => shopper.status == 0)
        .map((shopper) => DropdownMenuItem<String>(
            child: Center(child: Text(shopper.name + ' ❌', style: dropdownItemStyle)), value: shopper.name)));
    return list;
  }

  static bool hasRole(BuildContext context, String slug) => StoreProvider.of<AppState>(context)
      .state
      .adminsState
      .admin
      .roles
      .where((element) => element.slug.contains(slug))
      .isNotEmpty;

  static bool hasPermission(BuildContext context, String slug) =>
      StoreProvider.of<AppState>(context).state.adminsState.admin.permissions.contains(slug);

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

  static String selectedShopperId(String name, BuildContext context) => StoreProvider.of<AppState>(context)
      .state
      .shoppersState
      .shoppers
      .firstWhere((shopper) => shopper.name == name.replaceAll(' ✅', '').replaceAll(' ❌', ''))
      .id
      .toString();

  static int selectedShopperLevelId(String name, BuildContext context) => StoreProvider.of<AppState>(context)
      .state
      .shoppersState
      .shoppers
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
        url = 'whatsapp://send?phone=' + StaticVariables.companyInformation.whatsappNumber;
        break;
      case 'messenger':
        url = StaticVariables.companyInformation.messengerUrl;
        break;
      case 'facebook':
        url = 'fb://page/' + StaticVariables.companyInformation.facebookUrl;
        break;
      case 'instagram':
        url = StaticVariables.companyInformation.instagramUrl;
        break;
      case 'website':
        url = StaticVariables.companyInformation.websiteUrl;
        break;
      case 'email':
        String platform = 'Android';
        if (Platform.isIOS) platform = 'iPhone';
        url =
            'mailto:${StaticVariables.companyInformation.email}?subject=Support Request From $platform Application&body=';
        break;
      case 'number':
        url = 'tel:${StaticVariables.companyInformation.supportNumber}';
        break;
      case 'customer_whatsapp':
        url = 'whatsapp://send?phone=+963' + mobileNumber;
        break;
    }
    launch(url);
  }

  static shareApp() {
    String infoMessage = 'تطبيق كمّون لتوصيل المنتجات الغذائية لباب بيتك و بأسعار منافسة\n';
    String androidGrating = '\n لتحميل التطبيق على الأندوريد \n';

    String androidUrl = androidGrating + StaticVariables.androidShareUrl;
    String iosGrating = '\n لتحميل التطبيق على الآيفون \n';
    String iPhoneUrl = iosGrating + StaticVariables.iOSShareUrl;

    Share.share(infoMessage + androidUrl + iPhoneUrl);
  }

  static setPreferLeftSide(bool side) async {
    StaticVariables.preferLeftSide = side;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('preferLeftSide', side);
  }

  static Future<bool> initializeVariables() async {
    String buildNumber = '100';
    int lastSupported;
    int currentVersion;

    StaticVariables.companyInformation = CompanyOriginalData(
        email: 'support@kammun.com',
        whatsappNumber: '+963969999204',
        supportNumber: '0969999204',
        facebookUrl: '106414764313952',
        instagramUrl: 'https://www.instagram.com/kammunapp',
        messengerUrl: 'http://m.me/KammunApp',
        supportUrl: 'https://www.instagram.com/',
        baseUrl: 'https://kammun.com',
        imageBaseUrl: 'https://kammun.app/images/',
        currency: 'S.P',
        additionalInfo: 'http://m.me/KammunApp');

    StaticVariables.imagePrefixUrl = 'https://kammun.app/images/';

    // Mobile Configuration

    StaticVariables.androidShareUrl = 'https://play.google.com/store/apps/details?id=com.kammun.app';
    StaticVariables.iOSShareUrl = 'https://apps.apple.com/us/app/%D9%83%D9%85-%D9%88%D9%86/id1505291329';

    if (Platform.isIOS) {
      lastSupported = 100;
      currentVersion = 100;

      LoadingScreen.updateUrl = 'https://apps.apple.com/us/app/%D9%83%D9%85-%D9%88%D9%86/id1505291329';
    } else {
      lastSupported = 100;
      currentVersion = 100;
      LoadingScreen.updateUrl = 'https://play.google.com/store/apps/details?id=com.kammun.app';
    }

    if (int.parse(buildNumber) < lastSupported) {
      StaticVariables.updateRequired = true;
    } else if (int.parse(buildNumber) < currentVersion) {
      StaticVariables.updateOptional = true;
    }

    StaticVariables.bannerListNetwork.clear();
    StaticVariables.bannerListNetwork.add(FadeInImage(
      image: AdvImageCache(StaticVariables.imagePrefixUrl + 'slide3.png',
          useMemCache: true, diskCacheExpire: const Duration(days: 400)),
      fadeInDuration: const Duration(seconds: 1),
      fadeInCurve: Curves.fastOutSlowIn,
      placeholderErrorBuilder: (ctx, err, trace) => Image.asset('assets/kmlogoo.png'),
      imageErrorBuilder: (ctx, err, trace) => Image.asset('assets/kmlogoo.png'),
      placeholder: const AssetImage('assets/kmlogoo.png'),
      fit: BoxFit.cover,
    ));
    return true;
  }

  static Future<bool> checkIfUserLoggedIn() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.clear();
      StaticVariables.preferLeftSide = prefs.getBool('preferLeftSide');
      String userToken = prefs.getString('userToken');
      if (userToken != null) {
        LoadingScreen.userToken = 'Bearer ' + userToken;
        if (userToken == 'APPLE_VERIFICATION') {
          baseUrl = appleBaseUrl;
        } else {
          baseUrl = productionBaseUrl;
        }
        if (['shopper', 'supplier', 'rabia', 'agent', 'collector'].contains(userToken)) baseUrl = testUrl;
        return true;
      }
      return false;
    } catch (e) {
      return null;
    }
  }
}
