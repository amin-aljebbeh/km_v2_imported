import 'package:url_launcher/url_launcher.dart';

import '../../../core/core_importer.dart';

class UpdateScreen extends StatelessWidget {
  const UpdateScreen({Key key}) : super(key: key);
  static const String routeName = '/UpdateScreen';

  _iosUpdateLink() async {
    String url = LoadingScreen.updateUrl;

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _androidUpdateLink() async {
    String url = LoadingScreen.updateUrl;

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/update.png', width: 100, height: 150),
              Text('تحديث مطلوب',
                  style: mainStyle.copyWith(color: Colors.black, fontSize: 25.0, fontWeight: FontWeight.w500)),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 10, left: 30, right: 15),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    ' لديك نسخة قديمة من التطبيق يرجى التحديث حتى تتمكن من الإستفادة من التطبيق ',
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    style: mainStyle.copyWith(color: Colors.grey[700], fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: KammunButton(
                  text: ' التحديث الآن ',
                  height: 50,
                  color: primaryColor,
                  onTap: Platform.isAndroid ? () => _androidUpdateLink() : () => _iosUpdateLink(),
                ),
              ),
            ],
          ),
        ),
        color: Colors.white,
        // color: Color.fromARGB(255, 40, 51, 140),
      ),
    );
  }
}
