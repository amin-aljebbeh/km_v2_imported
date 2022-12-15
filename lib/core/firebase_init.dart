import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:just_audio/just_audio.dart';
import 'package:overlay_support/overlay_support.dart';

import '../../core/core_importer.dart';
import '../../firebase_options.dart';

class FirebaseInitPage extends StatefulWidget {
  final Widget child;
  const FirebaseInitPage({Key key, this.child}) : super(key: key);

  @override
  _FirebaseInitPageState createState() => _FirebaseInitPageState();
}

class _FirebaseInitPageState extends State<FirebaseInitPage> {
  bool initialized = false;
  bool initialized1 = false;
  AudioPlayer player;

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  void initializeFlutterFire() async {
    await player.setAsset('assets/cool.mp3');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then((value) async {
        setState(() => initialized = true);
        String firebaseToken = prefs.getString('FCM_token_v3');
        FirebaseMessaging messaging = FirebaseMessaging.instance;
        if (Platform.isIOS) {
          NotificationSettings settings = await messaging.requestPermission(
            alert: true,
            announcement: false,
            badge: true,
            carPlay: false,
            criticalAlert: false,
            provisional: false,
            sound: true,
          );
          if (initialized && settings.authorizationStatus == AuthorizationStatus.authorized) {
            if (firebaseToken == null) {
              FirebaseMessaging.instance.getToken().then((value) {
                if (value != null) {
                  prefs.setString('FCM_token_v3', value);
                  if (prefs.getString('userToken') != null) LoadingScreenServices().updateFirebaseTokenService(value);
                }
              });
            }
            FirebaseMessaging.onMessage.listen((RemoteMessage message) {
              if (message.notification != null) {
                showOverlayNotification(
                  (context) => Card(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: SafeArea(
                      child: ListTile(
                        onTap: () {},
                        leading: SizedBox.fromSize(
                            size: const Size(40, 40), child: ClipOval(child: Image.asset('assets/kmIcon.png'))),
                        title: Text(message.notification.title ?? 'Kammun', style: mainStyle),
                        subtitle: Text(message.notification.body ?? '', style: mainStyle),
                        trailing: IconButton(icon: const Icon(Icons.close), onPressed: () {}),
                      ),
                    ),
                  ),
                  duration: const Duration(milliseconds: 5000),
                );
              }
            });
            FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) =>
                showMyDialog(title: message.notification.title, text: message.notification.body, context: context));
          }
        } else {
          if (firebaseToken == null) {
            FirebaseMessaging.instance.getToken().then((value) {
              if (value != null) {
                prefs.setString('FCM_token_v3', value);
                if (prefs.getString('userToken') != null) LoadingScreenServices().updateFirebaseTokenService(value);
              }
            });
          }
          FirebaseMessaging.instance.getToken();
          FirebaseMessaging.onMessage.listen((RemoteMessage message) {
            player.play();

            if (message.notification != null) {
              showOverlayNotification(
                (context) => Card(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: SafeArea(
                    child: ListTile(
                      onTap: () {},
                      leading: SizedBox.fromSize(
                          size: const Size(40, 40), child: ClipOval(child: Image.asset('assets/kmIcon.png'))),
                      title: Text(message.notification.title ?? 'Kammun', style: mainStyle),
                      subtitle: Text(message.notification.body ?? '', style: mainStyle),
                      trailing: IconButton(icon: const Icon(Icons.close), onPressed: () {}),
                    ),
                  ),
                ),
                duration: const Duration(milliseconds: 5000),
              );
            }
          });
          FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) =>
              showMyDialog(title: message.notification.title, text: message.notification.body, context: context));
        }
      });
    } catch (e) {/**/}
    setState(() => initialized1 = true);
  }

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();

    initializeFlutterFire();
  }

  @override
  Widget build(BuildContext context) {
    if (!initialized1) return Container();
    return widget.child;
  }
}
