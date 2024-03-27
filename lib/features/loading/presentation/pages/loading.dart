import 'package:firebase_core/firebase_core.dart';

import '../../../../core/core_importer.dart';
import '../../../authentication/login_services.dart';
import '../../../error/presentation/pages/internet_error.dart';
import '../../../update_screen/pages/update_required_screen.dart';

class LoadingScreen extends StatefulWidget {
  static String userToken = 'Bearer ';
  static String updateUrl = '';

  const LoadingScreen({Key key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Future fetchInformation;
  Future checkUpdate;

  dynamic notificationValue;

  @override
  void initState() {
    fetchInformation = _getClientInfo();

    super.initState();
  }

  _getClientInfo() async {
    try {
      await Firebase.initializeApp();
      bool userLoggedIn = await LoginServices.checkIfUserLoggedIn();
      if (userLoggedIn) {
        bool x = await GeneralApis.fetchStartInformation(context: context);
        return x;
      }
      return 'userNotLoggedIn';
    } catch (e) {
      /**/
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      distinct: true,
      builder: (context, state) {
        return FutureBuilder(
          future: fetchInformation,
          builder: (context, snapShot) {
            if (snapShot.data == 'userNotLoggedIn') return const LoginPage();

            if (snapShot.connectionState == ConnectionState.done) {
              if (snapShot.hasError || snapShot.data == false) {
                return const InternetError();
              } else if (state.generalInformationState.companyInformation.updateRequired) {
                return const UpdateScreen();
              } else {
                return HomePage(notificationValue: notificationValue);
              }
            } else {
              return Scaffold(
                backgroundColor: kmColors,
                body: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                      image: DecorationImage(image: AssetImage('assets/welcome_screen.png'), fit: BoxFit.contain)),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                          left: MediaQuery.of(context).size.width - 80,
                          bottom: MediaQuery.of(context).size.height / 2 - 37,
                          height: 100,
                          width: 100,
                          child: Image.asset('assets/Loading.gif')),
                    ],
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}
