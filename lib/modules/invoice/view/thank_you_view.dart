import 'package:flutter/material.dart';
import '../../../core/core_importer.dart';

class ThankYouView extends StatefulWidget {
  static const String routeName = '/thankYou';
  const ThankYouView({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return ThankYouViewState();
  }
}

class ThankYouViewState extends State<ThankYouView> {
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
            body: Padding(
              padding: const EdgeInsets.only(left: 30, top: 0, right: 30, bottom: 10),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Image.asset('assets/thank-you-cash@3x.png',
                              width: MediaQuery.of(context).size.width * 0.8),
                        ),
                        const SizedBox(height: 50),
                        KCard(
                          radius: 6,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
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
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    StringUtils.thankYouDescribe,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: ColorUtils.kmColors,
                                      fontFamily: StringUtils.fontFamily,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        KButton(
                          color: ColorUtils.primaryColor,
                          onTap: () => RestartWidget.restartApp(navigatorKey.currentContext),
                          text: StringUtils.continueShopping,
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 50,
                        ),
                      ],
                    ),
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
