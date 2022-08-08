import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/core/core_importer.dart';
import 'package:url_launcher/url_launcher.dart';

class UsagePolicy extends StatefulWidget {
  final Function onApprove;
  const UsagePolicy({this.onApprove, Key key}) : super(key: key);
  @override
  _UsagePolicyState createState() => _UsagePolicyState();
}

class _UsagePolicyState extends State<UsagePolicy> {
  final ScrollController _scroll = ScrollController();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              reverse: true,
              controller: _scroll,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(
                        0, MediaQuery.of(context).size.height * 0.02, 0, MediaQuery.of(context).size.height * 0.02),
                    decoration: const BoxDecoration(border: Border(bottom: BorderSide())),
                    child: Text(
                      'سياسة الإستخدام',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: StringUtils.fontFamily,
                        color: ColorUtils.primaryColor,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "تحتاج للموافقة على ",
                              style: TextStyle(
                                color: Colors.grey[900],
                                fontFamily: StringUtils.fontFamily,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap =
                                    () => launch('http://kammun.com/privacy-policy.html', enableJavaScript: false),
                              text: " سياسة الإستخدام ",
                              style: TextStyle(
                                color: Colors.blue[800],
                                fontFamily: StringUtils.fontFamily,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(
                              text: "الخاصة بتطبيق كمون حتى تتمكن من إستعمال التطبيق",
                              style: TextStyle(
                                color: Colors.grey[900],
                                fontFamily: StringUtils.fontFamily,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  KButton(
                    color: Colors.green,
                    onTap: () => widget.onApprove(),
                    text: StringUtils.approve,
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.95,
                  ),
                  const SizedBox(height: 15),
                  KButton(
                    color: Colors.red[800],
                    onTap: () => StoreProvider.of<AppState>(context).dispatch(Pop()),
                    text: "غير موافق",
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.95,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
