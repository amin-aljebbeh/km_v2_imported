import 'package:adv_image_cache/adv_image_cache.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/core_importer.dart';

class HomePageService {
  static Future<bool> updateFirebaseTokenService(String firebaseToken) async {
    Map body = {'firebase_token': firebaseToken};
    await ApiProvider.sendRequest(url: updateFirebaseToken, method: HttpMethods.post, body: jsonEncode(body));
    return true;
  }

  static List<Image> getBanner(BuildContext context) {
    String imagePrefixUrl = StoreProvider.of<AppState>(context).state.startupState.startModel.company.imageBaseUrl;
    if (StoreProvider.of<AppState>(context).state.startupState.startModel.banners.isNotEmpty) {
      return StoreProvider.of<AppState>(context)
          .state
          .startupState
          .startModel
          .banners
          .map((image) => Image(
              image: AdvImageCache(imagePrefixUrl + image.imageFileName,
                  useMemCache: true, diskCacheExpire: const Duration(days: 100))))
          .toList();
    } else {
      return [const Image(image: AssetImage('assets/kmlogoo.png'))];
    }
  }

  static updateApplication() async {
    String url = StoreProvider.of<AppState>(navigatorKey.currentContext).state.updateState.updateUrl;

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<CategoryProduct> getSpecialProducts({String url, int pageNumber}) async {
    try {
      var response =
          await ApiProvider.sendRequest(url: url, method: HttpMethods.get, queryParameters: {'page': pageNumber});
      if (response != null) {
        if (response.statusCode == successCode) {
          return categoryProductFromJson(jsonEncode(response.data));
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}
