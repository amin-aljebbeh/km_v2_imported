import '../../../core/core_importer.dart';
import '../../error/view/internet_error.dart';

class StartupService {
  static Future<StartModel> getStartScreenInformation() async {
    try {
      var response = await ApiProvider.sendRequest(url: getStartRequest, method: HttpMethods.get);

      if (response != null) {
        if (response.statusCode == successCode && response.data['success']) {
          StartModel startModel = startModelFromJson(jsonEncode(response.data));
          return startModel;
        }
      }
      StoreProvider.of<AppState>(navigatorKey.currentContext)
          .dispatch(PushAndReplace(routeName: InternetError.routeName));
      return null;
    } catch (e) {
      StoreProvider.of<AppState>(navigatorKey.currentContext)
          .dispatch(PushAndReplace(routeName: InternetError.routeName));
      return null;
    }
  }
}
