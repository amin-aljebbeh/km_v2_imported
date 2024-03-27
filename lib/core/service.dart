import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../features/general_information/presentation/redux/general_information_action.dart';
import 'core_importer.dart';

class Services {
  static List<DropdownMenuItem<int>> inventorySubWarehouseNames(BuildContext context) {
    List<String> names = StoreProvider.of<AppState>(context)
        .state
        .generalInformationState
        .subWarehouses
        .map((subWarehouse) => subWarehouse.name)
        .toList();
    names.add('الجميع');
    return dropdownStringList(names);
  }

  static List<DropdownMenuItem<String>> productSubWarehouseNames(BuildContext context) =>
      StoreProvider.of<AppState>(context)
          .state
          .generalInformationState
          .subWarehouses
          .map((subWarehouse) => DropdownMenuItem<String>(
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.68,
                  child: Text(subWarehouse.name, style: warehouseStyle)),
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

  static String selectedShopperId(String name, BuildContext context) => StoreProvider.of<AppState>(context)
      .state
      .shoppersState
      .shoppers
      .firstWhere((shopper) => shopper.name == name.replaceAll(' ✅', '').replaceAll(' ❌', ''))
      .id
      .toString();

  static String selectedAdmin(String name, BuildContext context) => StoreProvider.of<AppState>(context)
      .state.adminsState.transactionsActors
      .firstWhere((admin) => admin.name == name)
      .id
      .toString();
  static String selectedAdminTransction(String name, BuildContext context) => StoreProvider.of<AppState>(context)
      .state.adminsState.admins
      .firstWhere((admin) => admin.name == name)
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

  static openUrl(String selected, BuildContext context, {String mobileNumber}) async {
    var info = StoreProvider.of<AppState>(context).state.generalInformationState.companyInformation;

    String url = '';
    switch (selected) {
      case 'whatsapp':
        url = 'whatsapp://send?phone=' + info.whatsappNumber;
        break;
      case 'messenger':
        url = info.messengerUrl;
        break;
      case 'facebook':
        url = 'fb://page/' + info.facebookUrl;
        break;
      case 'instagram':
        url = info.instagramUrl;
        break;
      case 'website':
        url = info.websiteUrl;
        break;
      case 'email':
        String platform = 'Android';
        if (Platform.isIOS) platform = 'iPhone';
        url = 'mailto:${info.email}?subject=Support Request From $platform Application&body=';
        break;
      case 'number':
        url = 'tel:${info.supportNumber}';
        break;
      case 'customer_whatsapp':
        url = 'whatsapp://send?phone=+963' + mobileNumber;
        break;
    }
    launch(url);
  }

  static shareApp(BuildContext context) {
    var info = StoreProvider.of<AppState>(context).state.generalInformationState.companyInformation;
    String infoMessage = 'تطبيق كمّون لتوصيل المنتجات الغذائية لباب بيتك و بأسعار منافسة\n';
    String androidGrating = '\n لتحميل التطبيق على الأندوريد \n';

    String androidUrl = androidGrating + info.androidShareUrl;
    String iosGrating = '\n لتحميل التطبيق على الآيفون \n';
    String iPhoneUrl = iosGrating + info.iOSShareUrl;

    Share.share(infoMessage + androidUrl + iPhoneUrl);
  }

  static setPreferLeftSide(bool side) async {
    StaticVariables.preferLeftSide = side;
    SharedPreferences prefs = sl<SharedPreferences>();
    prefs.setBool('preferLeftSide', side);
  }

  static Future<bool> initializeVariables(BuildContext context) async {
    String buildNumber = '100';
    int lastSupported;

    StoreProvider.of<AppState>(context).dispatch(SetCompanyInfo(
        info: CompanyInfoEntity(
            email: 'support@kammun.com',
            whatsappNumber: '+963969999204',
            supportNumber: '0969999204',
            facebookUrl: '106414764313952',
            instagramUrl: 'https://www.instagram.com/kammunapp',
            messengerUrl: 'http://m.me/KammunApp',
            androidShareUrl: 'https://play.google.com/store/apps/details?id=com.kammun.app',
            iOSShareUrl: 'https://apps.apple.com/us/app/%D9%83%D9%85-%D9%88%D9%86/id1505291329',
            supportUrl: 'https://www.instagram.com/',
            currency: 'S.P',
            imagePrefixUrl: 'https://kammun.app/images/',
            additionalInfo: 'http://m.me/KammunApp')));

    if (Platform.isIOS) {
      lastSupported = 100;

      LoadingScreen.updateUrl = 'https://apps.apple.com/us/app/%D9%83%D9%85-%D9%88%D9%86/id1505291329';
    } else {
      lastSupported = 100;
      LoadingScreen.updateUrl = 'https://play.google.com/store/apps/details?id=com.kammun.app';
    }

    if (int.parse(buildNumber) < lastSupported) StoreProvider.of<AppState>(context).dispatch(UpdateRequired());

    return true;
  }
}
