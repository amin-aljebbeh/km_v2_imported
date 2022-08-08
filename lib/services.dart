import 'package:kammun_app/core/core_importer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

class Services {
  static openUrl({String selected}) async {
    Company company =
        StoreProvider.of<AppState>(navigatorKey.currentContext).state.startupState.startModel.company;
    String url = '';
    if (selected == 'whatsapp') {
      url = 'whatsapp://send?phone=' + company.whatsappNumber;
    } else if (selected == 'messenger') {
      url = company.messengerUrl;
    } else if (selected == 'facebook') {
      if (Platform.isIOS) {
        url = 'fb://profile/${company.facebookUrl}';
      } else {
        url = 'fb://page/${company.facebookUrl}';
      }
    } else if (selected == 'instagram') {
      url = company.instagramUrl;
    } else if (selected == 'website') {
      url = company.websiteUrl;
    } else if (selected == 'email') {
      String platform = 'Android';
      if (Platform.isIOS) {
        platform = 'iPhone';
      }
      url = 'mailto:${company.email}?subject=Support Request From $platform Application&body=';
    } else if (selected == 'number') {
      url = 'tel:${company.supportNumber}';
    }

    launch(url, forceSafariVC: false);
  }

  static shareApp() {
    MobileAppConfigs mobileData =
        StoreProvider.of<AppState>(navigatorKey.currentContext).state.startupState.startModel.mobileAppConfigs;
    String infoMessage = 'تطبيق كمون لتوصيل المنتجات الغذائية لباب بيتك و بأسعار منافسة\n';
    String androidGrating = '\n لتحميل التطبيق على الأندوريد \n';

    String androidUrl = androidGrating + mobileData.appStoreUrl;
    String iosGrating = '\n لتحميل التطبيق على الآيفون \n';
    String iPhoneUrl = iosGrating + mobileData.googlePlayUrl;

    Share.share(infoMessage + androidUrl + iPhoneUrl);
  }
}
