import 'package:kammun_app/modules/map/redux/map_action.dart';
import '../../../core/core_importer.dart';

showCityNotSupportedDialog({double lat, double lng}) {
  showMyDialog(
    title: 'للأسف هذه المنطقة غير متاحة',
    text:
        'للأسف التوصيل لهذه المنطقة غير متاح حاليا نعمل على توسيع مناطق التوصيل بكل طاقتنا بإمكانك طلب إتاحة التوصيل لهذه المنطقة  ',
    dialogButtons: [
      KOutlinedButton(
          onTap: () {
            StoreProvider.of<AppState>(navigatorKey.currentContext).dispatch(Pop());
            StoreProvider.of<AppState>(navigatorKey.currentContext).dispatch(StartLoading());
            StoreProvider.of<AppState>(navigatorKey.currentContext).dispatch(VoteForSupportedCity(lat: lat, lng: lng));
          },
          width: MediaQuery.of(navigatorKey.currentContext).size.width,
          color: ColorUtils.primaryColor,
          text: 'التصويت لهذه المنطقة')
    ],
  );
}
