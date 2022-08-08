import 'package:flutter/material.dart';
import '../../../core/core_importer.dart';

class GoToBank extends StatefulWidget {
  static const String routeName = '/GoToBank';
  const GoToBank({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return GoToBankState();
  }
}

class GoToBankState extends State<GoToBank> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () {
            RestartWidget.restartApp(context);
            return;
          },
          child: Scaffold(
            body: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: SafeArea(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Image.asset('assets/thank-you-online@3x.png',
                            width: MediaQuery.of(context).size.width * 0.8),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: KCard(
                          radius: 6,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    StringUtils.thankYou,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: ColorUtils.primaryColor,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: StringUtils.fontFamily,
                                        fontSize: 30),
                                  ),
                                ),
                                Text(
                                  'بإمكانك الآن التوجه إلى صفحة الدفع لتسديد ثمن الطلب',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: ColorUtils.kmColors,
                                    fontFamily: StringUtils.fontFamily,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: KButton(
                          color: ColorUtils.primaryColor,
                          onTap: () => StoreProvider.of<AppState>(navigatorKey.currentContext)
                              .dispatch(PushAndReplace(routeName: PaymentView.routeName)),
                          text: 'الذهاب لصفحة البنك',
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
