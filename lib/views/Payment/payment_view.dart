import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentView extends StatefulWidget {
  PaymentView();
  @override
  createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  final _key = UniqueKey();
  var postData = Uint8List.fromList(utf8.encode(
      "pspId=PSP_001&mpiId=mpi-test&cardAcceptor=77000001&mcc=3633&merchantKitId=mki-test&authenticationToken=BD43C384153FB0D1E0550250568EE9ED&currency=SYP&transactionTypeIndicator=SS&transactionReference=123456&transactionAmount=3065.0&cardHolderMailAddress=example@example.com&cardHolderPhoneNumber=0999999999&dateTimeSIC=20210222134953&cardHolderIPAddress=196.12.213.90&countryCode=SYR&dateTimeBuyer=20210222134953&redirectBackUrl=http=//google.com/&callBackUrl=http=//google.com/&language=ar"));

  var controller;

  _PaymentViewState();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          child: AppBar(
            backgroundColor: Color.fromARGB(255, 210, 178, 2),
            automaticallyImplyLeading: false,
            // hides leading widget

            flexibleSpace: SafeArea(
              // top: true,
              // left: false,
              // bottom: false,
              // right: false,
              child: Column(
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Opacity(
                          opacity: 0.0,
                          child: Icon(
                            Icons.home,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Transform.scale(
                            scale: 2,
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/home',
                                  (Route<dynamic> route) => false,
                                );
                              },
                              child: Image.asset(
                                "assets/logobw.png",
                                width: 150,
                                height: 50,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 5.0, left: 0),
                            child: IconButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                icon: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                  size: 40,
                                ))),
                      ]),
                ],
              ),
            ),
          ),
          preferredSize: Size.fromHeight(65),
        ),
        body: Column(
          children: [
            Expanded(
              child: InAppWebView(
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(debuggingEnabled: true),
                ),

                // URLRequest(
                //   url: Uri.parse("https://example.com/my-post-endpoint"),
                //   method: 'POST',
                //   body: Uint8List.fromList(utf8.encode("firstname=Foo&lastname=Bar")),
                //   headers: {
                //     'Content-Type': 'application/x-www-form-urlencoded'
                //     }
                //     ),

                onWebViewCreated: (controller) {
                  controller.postUrl(
                      url:
                          "http://10.9.248.2:8080/ss-ecom-merchant-kit/buyForm/completeTransaction",
                      postData: postData);

                  controller.addJavaScriptHandler(
                      handlerName: "callBackUrl",
                      callback: (args) {
                        print("From the JavaScript side:");
                        print(args);
                      });

                  print("====================");
                  print(postData.toString());

                  print(controller.getOptions().asStream().first);
                  print(controller.getTitle());
                  print(controller.getUrl());
                  print(controller.getProgress());
                  print(controller.getCertificate());

                  print("====================");
                },
              ),
            )
          ],
        ));
  }
}
