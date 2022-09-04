import '../../core/core_importer.dart';

class ThankYouView extends StatefulWidget {
  final String orderMessage;

  const ThankYouView({Key key, this.orderMessage}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ThankYouViewState();
}

class ThankYouViewState extends State<ThankYouView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => showMyDialog(
        context: context, title: costumerNote, text: widget.orderMessage, dialogButtons: [const CloseWidget()]));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        KammunRestart.restartApp(context);
        return;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColorLight,
        appBar: AppBar(backgroundColor: Theme.of(context).primaryColorLight, elevation: 0.0),
        body: Padding(
          padding: const EdgeInsets.only(left: 30, top: 0, right: 30, bottom: 10),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset('assets/like.png', width: 200, height: 200),
                  const SizedBox(height: 50),
                  Text(
                    thankYou,
                    style: TextStyle(
                        color: primaryColor, fontWeight: FontWeight.w700, fontFamily: fontFamily, fontSize: 30),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, top: 10, right: 0, bottom: 10),
                    child: Text(
                      thankYouDescribe,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                        fontFamily: fontFamily,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, top: 10, right: 0, bottom: 10),
                    child: Text(
                      widget.orderMessage.toString(),
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kmColors,
                        fontFamily: fontFamily,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  KammunButton(
                    text: continueShopping,
                    color: Theme.of(context).primaryColor,
                    height: 50,
                    onTap: () => Navigator.of(context)
                        .pushNamedAndRemoveUntil(OrdersView.routeName, (Route<dynamic> route) => false),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
