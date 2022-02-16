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
  var postData = Uint8List.fromList(utf8.encode("firstname=Foo&lastname=Bar"));

  var controller;

  _PaymentViewState();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Expanded(
              child: InAppWebView(
                initialUrl: "https://google.com",
                initialHeaders: {'method': 'POST'},
                

                initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(debuggingEnabled: true)),

                // URLRequest(
                //   url: Uri.parse("https://example.com/my-post-endpoint"),
                //   method: 'POST',
                //   body: Uint8List.fromList(utf8.encode("firstname=Foo&lastname=Bar")),
                //   headers: {
                //     'Content-Type': 'application/x-www-form-urlencoded'
                //     }
                //     ),
                onWebViewCreated: (controller) {},
              ),
            )
          ],
        ));
  }
}
