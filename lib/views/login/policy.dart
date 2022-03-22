import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kammun_app/utils/utils_importer.dart';
import 'package:url_launcher/url_launcher.dart';

class UsagePolicy extends StatefulWidget {
  final Function(bool) onApprove;
  const UsagePolicy(this.onApprove, {Key key}) : super(key: key);
  @override
  _UsagePolicyState createState() => _UsagePolicyState();
}

class _UsagePolicyState extends State<UsagePolicy> {
  final ScrollController _scroll = ScrollController();

  Widget _approvePolicy() {
    final GestureDetector showConfirmButtonWithGesture = GestureDetector(
      onTap: () {
        widget.onApprove(true);
      },
      child: Container(
        height: 60.0,
        decoration: const BoxDecoration(color: Colors.green, borderRadius: BorderRadius.all(Radius.circular(6.0))),
        child: Center(
          child: Text(
            StringUtils.approveUsagePolicy,
            style: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
                fontWeight: FontWeight.w500,
                fontFamily: StringUtils.fontFamilyHKGrotesk),
          ),
        ),
      ),
    );

    return Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 20),
        child: showConfirmButtonWithGesture);
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

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
                padding: EdgeInsets.fromLTRB(0, screenHeight * 0.02, 0, screenHeight * 0.02),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide()),
                ),
                child: Text(
                  'سياسة الإستخدام',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: StringUtils.fontFamilyHKGrotesk,
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
                            fontFamily: StringUtils.fontFamilyHKGrotesk,
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
                            fontFamily: StringUtils.fontFamilyHKGrotesk,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(
                          text: "الخاصة بتطبيق كمّون حتى تتمكن من إستعمال التطبيق",
                          style: TextStyle(
                            color: Colors.grey[900],
                            fontFamily: StringUtils.fontFamilyHKGrotesk,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              _approvePolicy(),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          recognizer: TapGestureRecognizer()..onTap = () => Navigator.of(context).pop(),
                          text: "غير موافق",
                          style: TextStyle(
                            color: Colors.red[800],
                            fontFamily: StringUtils.fontFamilyHKGrotesk,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
