import 'package:animated_background/animated_background.dart';
import 'package:kammun_app/views/restart/kammunapp_restart.dart';
import '../../core/core_importer.dart';
import 'Services/login_services.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = '/login';
  static String phoneNumber = "";
  static String supportedCityId;

  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  String currentText = "";
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool errorCode = false;
  bool loadingScreen = false;
  String errorMessage = ' يرجى المحاولى مرة أُخرى و التأكد من إتصالك بالإنترنت';

  @override
  void initState() {
    super.initState();
  }

  Future adminLogin() async {
    setState(() => loadingScreen = true);
    if (_usernameController.text.isEmpty) {
      setState(() {
        errorCode = true;
        loadingScreen = false;

        errorMessage = 'يرجى إدخال اسم المستخدم';
      });
    } else if (_passwordController.text.isEmpty) {
      setState(() {
        errorCode = true;
        loadingScreen = false;

        errorMessage = 'يرجى إدخال كلمة السر';
      });
    } else {
      if (['rabie', 'supplier', 'rabia'].contains(_usernameController.text)) {
        baseUrl = testUrl;
      }
      bool response =
          await LoginServices.loginAdmin(username: _usernameController.text, password: _passwordController.text);
      if (response) {
        TextInput.finishAutofillContext();
        KammunRestart.restartApp(context);
      } else {
        setState(() {
          errorCode = true;
          loadingScreen = false;

          errorMessage = 'خطأ بإسم المستخدم أو كلمة المرور';
        });
      }
    }
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
      child: TextFormField(
        textDirection: TextDirection.ltr,
        maxLines: 1,
        controller: _passwordController,
        keyboardType: TextInputType.text,
        onEditingComplete: () => TextInput.finishAutofillContext(),
        autofillHints: const [AutofillHints.password],
        enableSuggestions: false,
        autocorrect: false,
        obscureText: true,
        cursorColor: ColorUtils.primaryColor,
        decoration: InputDecoration(
          floatingLabelStyle:
              TextStyle(fontFamily: StringUtils.fontFamilyHKGrotesk, fontSize: 30, color: ColorUtils.primaryColor),
          labelText: 'كلمة المرور',
          labelStyle: TextStyle(fontFamily: StringUtils.fontFamilyHKGrotesk, fontSize: 30),
          hintStyle: const TextStyle(color: Colors.black45),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: ColorUtils.primaryColor), borderRadius: BorderRadius.circular(5.0)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ColorUtils.kmColors), borderRadius: BorderRadius.circular(5.0)),
        ),
      ),
    );
  }

  Widget _showUsernameInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
      child: TextFormField(
        textDirection: TextDirection.ltr,
        maxLines: 1,
        controller: _usernameController,
        keyboardType: TextInputType.text,
        onEditingComplete: () => TextInput.finishAutofillContext(),
        cursorColor: ColorUtils.primaryColor,
        autofillHints: const [AutofillHints.username],
        decoration: InputDecoration(
          labelText: 'اسم المستخدم',
          floatingLabelStyle:
              TextStyle(fontFamily: StringUtils.fontFamilyHKGrotesk, fontSize: 30, color: ColorUtils.primaryColor),
          labelStyle: TextStyle(fontFamily: StringUtils.fontFamilyHKGrotesk, fontSize: 30),
          hintStyle: const TextStyle(color: Colors.black45),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: ColorUtils.primaryColor), borderRadius: BorderRadius.circular(5.0)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ColorUtils.kmColors), borderRadius: BorderRadius.circular(5.0)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            errorCode
                ? AlertMessages(text: errorMessage, messageType: 'internetError', headerText: 'مشكلة بالبيانات المدخلة')
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
                          child: _showUsernameInput()),
                      Container(
                          padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 0, top: 5),
                          child: _showPasswordInput()),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 20, top: 5),
                  child: loadingScreen
                      ? const Padding(padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 10.0), child: Loader())
                      : KammunButton(
                          text: StringUtils.signIn, height: 50, color: ColorUtils.primaryColor, onTap: adminLogin),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
