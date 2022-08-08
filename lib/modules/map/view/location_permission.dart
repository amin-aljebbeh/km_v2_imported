import 'package:permission_handler/permission_handler.dart';
import '../../../core/core_importer.dart';

askForLocationPermission({BuildContext context}) {
  showMyDialog(
    title: 'لا يمكن المتابعة',
    text: 'نحن بحاجة لمعرفة موقعك لتأمين أفضل خدمة لك\nالرجاء السماح للتطبيق بتحديد موقعك',
    dialogButtons: [
      KButton(
          onTap: () async {
            StoreProvider.of<AppState>(navigatorKey.currentContext).dispatch(Pop());
            await locationPermission(context: context);
          },
          width: MediaQuery.of(context).size.width,
          color: ColorUtils.primaryColor,
          text: 'موافق')
    ],
  );
}

locationPermission({BuildContext context}) async {
  await Permission.location.request();
  var locationStatus = await Permission.location.status;

  if (locationStatus != PermissionStatus.granted) askForLocationPermission(context: context);
  if (locationStatus == PermissionStatus.granted) RestartWidget.restartApp(context);
}
