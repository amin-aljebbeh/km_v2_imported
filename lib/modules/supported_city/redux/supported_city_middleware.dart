import 'package:kammun_app/core/core_importer.dart';
import 'package:kammun_app/modules/supported_city/redux/supported_city_action.dart';

import '../../map/redux/map_action.dart';
import '../services/supported_city_services.dart';

Future<void> supportedCityMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is UpdateUserSupportedCity) {
    store.dispatch(StartLoading());
    bool result = await SupportedCityServices.updateUserSupportedCityService(supportedCityId: action.supportedCityId);
    if (result) {
      store.dispatch(NoError());
      store.dispatch(UserSupportedCityUpdated(supportedCityId: action.supportedCityId));
    } else {
      store.dispatch(CatchError(
          errorMessage:
              'حدث خطأ أثناء محاولة إختيار المدينة الأقرب إليك يرجى التأكد من إتصالك بالإانترنت و المحاولة مجدداً'));
    }
  } else if (action is UserSupportedCityUpdated) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('supportedCitySelected', action.supportedCityId);
    RestartWidget.restartApp(navigatorKey.currentContext);
  } else if (action is GetSupportedCities) {
    List<SupportedCityModel> supportedCities = await SupportedCityServices.getSupportedCities();
    if (supportedCities != null) {
      store.dispatch(SupportedCitiesFetchedSuccessfully(supportedCities: supportedCities, initial: action.initial));
    }
  } else if (action is SupportedCitiesFetchedSuccessfully) {
    if (action.initPolygon) {
      store.dispatch(InitializePolygon(supportedCities: action.supportedCities, initial: action.initial));
    }
  }
  next(action);
}
