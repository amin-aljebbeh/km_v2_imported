import 'package:flutter/material.dart';

import '../../../core/core_importer.dart';

class ServerUpdate extends StatelessWidget {
  static const String routeName = '/server-update';

  const ServerUpdate({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Scaffold(
          body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 50, bottom: 25),
                    child: Image.asset('assets/system_update.gif'),
                  ),
                  Text(
                    'تحديثات ضمن النظام',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25.0,
                        fontWeight: FontWeight.w500,
                        fontFamily: StringUtils.fontFamily),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 10, left: 30, right: 15),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        state.startupState.message,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 18,
                          fontFamily: StringUtils.fontFamily,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: KButton(
                      color: ColorUtils.primaryColor,
                      onTap: () => RestartWidget.restartApp(context),
                      height: 50,
                      text: StringUtils.tryAgain,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
