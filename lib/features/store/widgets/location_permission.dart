import 'package:location/location.dart';

import '../../../core/core_importer.dart';

askForLocationPermission({BuildContext context, Function onGrant}) {
  showMyDialog(
    context: context,
    title: 'لا يمكن المتابعة',
    text: 'الرجاء السماح للتطبيق بتحديد موقعك',
    dialogButtons: [
      KammunButton(
          onTap: () async {
            Navigator.of(context).pop();
            await locationPermission(context: context, onGrant: () => onGrant());
          },
          width: MediaQuery.of(context).size.width / 2 - 100,
          color: primaryColor,
          text: 'موافق'),
      KammunButton(
          onTap: () async {
            Navigator.of(context).pop();
            StoreProvider.of<AppState>(context).dispatch(StopLoading());
          },
          width: MediaQuery.of(context).size.width / 2 - 100,
          color: primaryColor,
          text: 'إلغاء')
    ],
  );
}

askForLocationActivation({BuildContext context, Function onGrant}) {
  showMyDialog(
    context: context,
    title: 'لا يمكن المتابعة',
    text: 'الرجاء تفعيل خدمة تحديد المواقع على الهاتف',
    dialogButtons: [
      KammunButton(
          onTap: () async {
            Navigator.of(context).pop();
            await locationAvailability(context: context, onGrant: () => onGrant());
          },
          width: MediaQuery.of(context).size.width / 2 - 100,
          color: primaryColor,
          text: 'موافق'),
      KammunButton(
          onTap: () async {
            Navigator.of(context).pop();
            StoreProvider.of<AppState>(context).dispatch(StopLoading());
          },
          width: MediaQuery.of(context).size.width / 2 - 100,
          color: primaryColor,
          text: 'إلغاء')
    ],
  );
}

locationPermission({BuildContext context, Function onGrant}) async {
  try {
    Location location = Location();
    PermissionStatus locationStatus = await location.hasPermission();

    if (locationStatus != PermissionStatus.granted) {
      await location.requestPermission();
      locationStatus = await location.hasPermission();
      if (locationStatus != PermissionStatus.granted) {
        askForLocationPermission(context: context, onGrant: () => onGrant());
      } else {
        locationAvailability(context: context, onGrant: () => onGrant());
      }
    } else {
      locationAvailability(context: context, onGrant: () => onGrant());
    }
  } catch (e) {
    Tools.logToConsole('location exception');
    Tools.logToConsole(e);
  }
}

locationAvailability({BuildContext context, Function onGrant}) async {
  Location location = Location();
  bool serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    await location.requestService();
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      askForLocationActivation(context: context, onGrant: () => onGrant());
    } else {
      onGrant();
    }
  } else {
    onGrant();
  }
}
