import 'package:kammun_app/features/home/presentation/redux/home_action.dart';

import '../../../core/core_importer.dart';
import '../../orders/presentation/redux/orders_action.dart';

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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: Image.asset('assets/like.png', width: 200, height: 200),
                  ),
                  Text(thankYou,
                      style: mainStyle.copyWith(color: primaryColor, fontWeight: FontWeight.w700, fontSize: 30)),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, top: 10, right: 0, bottom: 10),
                    child: Text(
                      thankYouDescribe,
                      textAlign: TextAlign.justify,
                      style: mainStyle.copyWith(fontWeight: FontWeight.w600, color: primaryColor, fontSize: 16.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, top: 10, right: 0, bottom: 50),
                    child: Text(
                      widget.orderMessage.toString(),
                      textAlign: TextAlign.justify,
                      style: mainStyle.copyWith(fontWeight: FontWeight.bold, color: kmColors, fontSize: 16.0),
                    ),
                  ),
                  KammunButton(
                    text: continueShopping,
                    color: Theme.of(context).primaryColor,
                    height: 50,
                    onTap: () {
                      StoreProvider.of<AppState>(context).dispatch(SetPageIndex(index: 2));
                      StoreProvider.of<AppState>(context).dispatch(GetOrdersAction());
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil(HomePage.routeName, (Route<dynamic> route) => false);
                    },
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
