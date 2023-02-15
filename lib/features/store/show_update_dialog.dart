import 'package:kammun_app/core/core_importer.dart';
import 'package:url_launcher/url_launcher.dart';

void showUpdateDialog({BuildContext context}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(1.0),
                topRight: Radius.circular(1.0),
                bottomLeft: Radius.circular(2.0),
                bottomRight: Radius.circular(2.0))),
        contentPadding: const EdgeInsets.only(top: 10, bottom: 0, right: 10, left: 10),
        titlePadding: const EdgeInsets.all(0),
        title: Container(
          width: double.infinity,
          height: 50,
          color: const Color.fromARGB(255, 247, 247, 247),
          child: Align(
            child: Padding(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Text('تحديث متوفر',
                        style: mainStyle.copyWith(fontSize: 17, color: primaryColor, fontWeight: FontWeight.bold)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Services.updateOption = false;
                      Navigator.of(context).pop(true);
                    },
                  )
                ],
              ),
              padding: const EdgeInsets.only(left: 10),
            ),
          ),
        ),
        content: SizedBox(
          height: 150,
          child: Column(
            children: <Widget>[
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'إصدار جديد من التطبيق اصبح متوفراً ! ',
                      style: mainStyle.copyWith(color: Colors.grey[900], fontSize: 20, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
              Divider(color: Colors.grey[600]),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.8,
                    child: KammunButton(text: ' التحديث الآن ', height: 50, color: kmColors, onTap: _updateApplication),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.8,
                    child: KammunButton(
                      text: ' التحديث لاحقاً ',
                      height: 50,
                      color: Colors.grey[700],
                      onTap: () {
                        Services.updateOption = false;
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}

_updateApplication() async {
  String url = LoadingScreen.updateUrl;

  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
