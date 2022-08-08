import 'package:flutter/material.dart';
import '../../../core/core_importer.dart';

class BlockedUserView extends StatelessWidget {
  static const String routeName = '/blocked-user';

  const BlockedUserView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Image.asset('assets/blocked_user.png', width: 100, height: 150),
                ),
                Text(
                  'تم منعك من الوصول',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 25.0,
                      fontWeight: FontWeight.w500,
                      fontFamily: StringUtils.fontFamily),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 10, left: 30, right: 15),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'يبدو أن هناك مشكلة على حسابكم ضمن تطبيق كمون للمزيد من المعلومات بإمكانكم التواصل مع خدمة العملاء على أحد منصات التواصل',
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
                Padding(padding: const EdgeInsets.all(8.0), child: _showRestartButton(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _showRestartButton(context) {
  final GestureDetector loginButtonWithGesture = GestureDetector(
    onTap: () => RestartWidget.restartApp(context),
    child: Container(
      height: 50.0,
      decoration:
          BoxDecoration(color: ColorUtils.primaryColor, borderRadius: const BorderRadius.all(Radius.circular(6.0))),
      child: Center(
        child: Text(
          StringUtils.tryAgain,
          style: TextStyle(
              color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w500, fontFamily: StringUtils.fontFamily),
        ),
      ),
    ),
  );

  return Padding(padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 10.0), child: loginButtonWithGesture);
}
