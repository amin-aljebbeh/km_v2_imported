import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/core_importer.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../redux/authentication_action.dart';
import 'policy.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = '/login';

  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  settingModalBottomSheet(context) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
        ),
        child: UsagePolicy(
          onApprove: () {
            StoreProvider.of<AppState>(context).dispatch(Pop());
            StoreProvider.of<AppState>(context).dispatch(FetchVerificationCode(phoneNumber: myController.text));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return TemporaryLoading(
          child: Scaffold(
            backgroundColor: ColorUtils.kmColors,
            body: SafeArea(
              child: Stack(
                children: <Widget>[
                  AnimatedBackground(
                    behaviour: RandomParticleBehaviour(),
                    vsync: this,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.90,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(MediaQuery.of(context).viewInsets.bottom != 0 ? 0 : 180),
                          bottomRight: Radius.circular(MediaQuery.of(context).viewInsets.bottom != 0 ? 0 : 180),
                        ),
                      ),
                    ),
                  ),
                  ListView(
                    shrinkWrap: true,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: Center(child: Image.asset('assets/kmlogoo.png', height: 150, width: 200)),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 0, top: 5),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
                          child: TextField(
                            maxLength: 10,
                            maxLines: 1,
                            controller: myController,
                            keyboardType: const TextInputType.numberWithOptions(),
                            cursorColor: ColorUtils.primaryColor,
                            decoration: InputDecoration(
                              labelText: 'رقم الموبايل',
                              labelStyle: TextStyle(fontFamily: StringUtils.fontFamily, fontSize: 30),
                              hintStyle: const TextStyle(color: Colors.black45),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: ColorUtils.primaryColor),
                                  borderRadius: BorderRadius.circular(5.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: ColorUtils.kmColors),
                                  borderRadius: BorderRadius.circular(5.0)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 20, top: 20),
                        child: KButton(
                          color: ColorUtils.primaryColor,
                          onTap: () {
                            if (myController.text.length == 10) {
                              settingModalBottomSheet(context);
                            } else {
                              flushbar(
                                  message: 'يجب إدخال رقم كامل من عشر خانات',
                                  color: Colors.red,
                                  icon: Icons.error,
                                  duration: 2);
                            }
                          },
                          height: 50,
                          text: 'تأكيد رقم الموبايل',
                        ),
                      ),
                    ],
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
