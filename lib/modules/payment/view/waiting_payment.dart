import 'package:flutter/material.dart';
import '../../../core/core_importer.dart';

class WaitingPaymentView extends StatefulWidget {
  static const String routeName = '/WaitingPaymentView';
  const WaitingPaymentView({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return WaitingPaymentViewState();
  }
}

class WaitingPaymentViewState extends State<WaitingPaymentView> {
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
                          child: Image.asset('assets/waiting-to-pay@3x.png',
                              width: MediaQuery.of(context).size.width * 0.8)),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: KCard(
                          radius: 6,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    'بانتظار الدفع',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: ColorUtils.primaryColor,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: StringUtils.fontFamily,
                                        fontSize: 30),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    'عذراً، لم تقم بتسديد قيمة الطلب إلكترونياً',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontFamily: StringUtils.fontFamily,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15, right: 36, left: 36),
                        child: KButton(
                          color: ColorUtils.primaryColor,
                          onTap: () => StoreProvider.of<AppState>(navigatorKey.currentContext)
                              .dispatch(PushAndReplace(routeName: PaymentView.routeName)),
                          text: 'العودة لصفحة الدفع',
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
