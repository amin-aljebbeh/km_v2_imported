import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:kammun_app/modules/payment/redux/payment_action.dart';

import '../../../core/core_importer.dart';
import '../services/payment_services.dart';

class PaymentView extends StatefulWidget {
  static String routeName = '/PaymentView';
  const PaymentView({Key key}) : super(key: key);
  @override
  createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  var postData = Uint8List.fromList(utf8.encode(PaymentServices.getEPayRequest()));

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        distinct: true,
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
                appBar: PreferredSize(
                  child: AppBar(
                    backgroundColor: const Color.fromARGB(255, 210, 178, 2),
                    automaticallyImplyLeading: false,
                    flexibleSpace: SafeArea(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start, //22256
                        children: const <Widget>[
                          Padding(padding: EdgeInsets.only(right: 120), child: AppBarKammunImage(fromPayment: true))
                        ], //24761
                      ),
                    ),
                  ),
                  preferredSize: const Size.fromHeight(35),
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: InAppWebView(
                        initialOptions: InAppWebViewGroupOptions(crossPlatform: InAppWebViewOptions()),
                        onLoadStart: (controller, url) {
                          if (url.toString() == state.paymentState.redirectBackUrl) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const Scaffold(body: Center(child: Loader()), backgroundColor: Colors.white)));
                            StoreProvider.of<AppState>(navigatorKey.currentContext).dispatch(CheckPayment(
                                orderId: StoreProvider.of<AppState>(navigatorKey.currentContext)
                                    .state
                                    .orderState
                                    .orderResponse
                                    .ePaymentInfo
                                    .orderId
                                    .toString()));
                          }
                        },
                        onLoadStop: (controller, url) async {},
                        onTitleChanged: (controller, title) {},
                        onReceivedServerTrustAuthRequest: (controller, challenge) async {
                          return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
                        },
                        onWebViewCreated: (controller) async {
                          await controller.postUrl(
                              url: Uri(
                                      scheme: 'https',
                                      host: 'tecom.albaraka.com.sy',
                                      port: 8433,
                                      path: '/ss-ecom-merchant-kit/buyForm/completeTransaction')
                                  .toString(),
                              postData: postData);
                          controller.addJavaScriptHandler(handlerName: 'callBackUrl', callback: (args) {});
                        },
                      ),
                    )
                  ],
                )),
          );
        });
  }
}
