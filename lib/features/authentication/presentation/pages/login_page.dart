import 'package:animated_background/animated_background.dart';

import '../../../../core/core_importer.dart';
import '../redux/authentication_action.dart';
import '../widgets/password_text_field_widget.dart';
import '../widgets/user_name_text_field_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: kmColors,
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
                state.errorState.isError
                    ? AlertMessages(
                        text: errorMessage, messageType: 'internetError', headerText: state.errorState.errorMessage)
                    : Container(padding: EdgeInsets.zero),
                ListView(
                  shrinkWrap: true,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: Center(child: Image.asset('assets/kmlogoo.png', height: 150, width: 200))),
                    AutofillGroup(
                      child: Column(
                        children: [
                          Container(
                              padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 0, top: 5),
                              child: UserNameTextField(usernameController: usernameController)),
                          Container(
                              padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 0, top: 5),
                              child: PasswordTextFiled(passwordController: passwordController)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 20, top: 5),
                      child: state.loadingState.loading.isNotEmpty
                          ? const Padding(padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 10.0), child: Loader())
                          : KammunButton(
                              text: signIn,
                              height: 50,
                              color: primaryColor,
                              onTap: () {
                                if (usernameController.text.isEmpty) {
                                  snackBar(context: context, message: 'يرجى إدخال اسم المستخدم', success: false);
                                } else if (passwordController.text.isEmpty) {
                                  snackBar(context: context, message: 'يرجى إدخال كلمة المرور', success: false);
                                } else {
                                  StoreProvider.of<AppState>(context).dispatch(LoginAction(
                                      password: passwordController.text,
                                      context: context,
                                      name: usernameController.text));
                                }
                              }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
