import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../core_importer.dart';

class WebViewScreen extends StatefulWidget {
  final String url;

  const WebViewScreen({Key key, this.url}) : super(key: key);

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  InAppWebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: kmColors, title: Text('إضافة شكوى', style: appBarStyle)),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
        onWebViewCreated: (controller) => webViewController = controller,
        androidOnPermissionRequest: (controller, origin, resources) async =>
            PermissionRequestResponse(resources: resources, action: PermissionRequestResponseAction.GRANT),
      ),
    );
  }
}
