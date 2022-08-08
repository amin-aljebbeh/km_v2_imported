import 'package:flutter/material.dart';
import '../../../core/core_importer.dart';
import '../redux/payment_action.dart';

class PaymentFailedView extends StatefulWidget {
  static const String routeName = '/PaymentFailed';
  const PaymentFailedView({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return PaymentFailedViewState();
  }
}

class PaymentFailedViewState extends State<PaymentFailedView> {
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
            appBar: AppBar(backgroundColor: Theme.of(context).primaryColorLight, elevation: 0.0),
            body: SafeArea(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(top: 50, bottom: 50),
                        child:
                            Image.asset('assets/failed-to-pay@3x.png', width: MediaQuery.of(context).size.width * 0.8)),
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
                                  'فشلت عملية الدفع',
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
                                  'يمكنك المحاولة من جديد أو العودة للقائمة الرئيسية',
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
                      padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            KButton(
                              color: ColorUtils.primaryColor,
                              onTap: () => StoreProvider.of<AppState>(context)
                                  .dispatch(RetryPayment(order: state.paymentState.order)),
                              text: 'المحاولة من جديد',
                              width: MediaQuery.of(context).size.width * 0.45,
                              height: 50,
                            ),
                            KButton(
                              color: ColorUtils.kmColors2,
                              onTap: () => RestartWidget.restartApp(context),
                              text: 'القائمة الرئيسية',
                              width: MediaQuery.of(context).size.width * 0.45,
                              height: 50,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
