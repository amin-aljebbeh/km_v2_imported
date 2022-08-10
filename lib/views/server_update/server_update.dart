import 'package:kammun_app/views/loading/loading_services.dart';

import '../../core/core_importer.dart';

class ServerUpdate extends StatelessWidget {
  static const String routeName = '/server-update';

  const ServerUpdate({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/system_update.gif'),
                Text(
                  'تحديثات ضمن النظام',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 25.0,
                      fontWeight: FontWeight.w500,
                      fontFamily: StringUtils.fontFamilyHKGrotesk),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 10, left: 30, right: 15),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      LoadingScreenServices.systemMaintenanceMessages,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 18,
                        fontFamily: StringUtils.fontFamilyHKGrotesk,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: KammunButton(
                    text: StringUtils.tryAgain,
                    height: 50,
                    color: ColorUtils.primaryColor,
                    onTap: () => KammunRestart.restartApp(context),
                  ),
                ),
              ],
            ),
          ),
          color: Colors.white,
        ),
      ),
    );
  }
}
