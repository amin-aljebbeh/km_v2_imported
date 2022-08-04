import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:kammun_app/views/restart/kammunapp_restart.dart';
import 'package:kammun_app/views/widget/widgets_importer.dart';

class InternetError extends StatelessWidget {
  const InternetError({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.transparent),
        backgroundColor: const Color.fromARGB(255, 210, 178, 2),
        automaticallyImplyLeading: false, // hides leading widget
        flexibleSpace: SafeArea(
          top: true,
          left: false,
          bottom: false,
          right: false,
          child: Column(
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Transform.scale(scale: 2, child: Image.asset('assets/logobw.png', width: 150, height: 50)),
                    ),
                  ]),
            ],
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 20),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset('assets/no-wifi.png', width: 125, height: 200),
            Text(
              'لايوجد إتصال بالإنترنت',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: StringUtils.fontFamilyHKGrotesk,
                fontWeight: FontWeight.w500,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'يرجى التحقق من إتصالك بالإنترنت والمحاولة من جديد ',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 15,
                  fontFamily: StringUtils.fontFamilyHKGrotesk,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: KammunButton(
                height: 50,
                text: StringUtils.tryAgain,
                color: Theme.of(context).primaryColor,
                onTap: () => KammunRestart.restartApp(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
