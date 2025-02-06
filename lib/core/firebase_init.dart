import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:just_audio/just_audio.dart';
import 'package:overlay_support/overlay_support.dart';

import '../../core/core_importer.dart';
import '../../firebase_options.dart';
import '../features/admins/domain/entities/admins_entity.dart';

class FirebaseInitPage extends StatefulWidget {
  final Widget child;

  const FirebaseInitPage({Key key, this.child}) : super(key: key);

  @override
  _FirebaseInitPageState createState() => _FirebaseInitPageState();
}

class _FirebaseInitPageState extends State<FirebaseInitPage> {
  bool _firebaseInitDone = false;
  AudioPlayer player;
  OverlaySupportEntry entry;

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    _initializeFirebaseMessaging();
  }

  /// Initialize Firebase and set up messaging without blocking other app actions.
  Future<void> _initializeFirebaseMessaging() async {
    // Get SharedPreferences instance for storing tokens.
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      // Initialize Firebase.
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      // Proceed to set up messaging services.
      await _setupMessaging(prefs);
    } catch (e, stack) {
      // Log errors so they can be diagnosed; do not block further app usage.
      Tools.logToConsole('Error during Firebase initialization: $e\n$stack');
    } finally {
      // Mark initialization as complete regardless of success/failure.
      if (mounted) setState(() => _firebaseInitDone = true);
    }
  }

  /// Sets up Firebase Messaging (permissions, token retrieval, and listeners).
  Future<void> _setupMessaging(SharedPreferences prefs) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await player.setAsset('assets/cool.mp3');

    // For iOS: request notification permissions.
    if (Platform.isIOS) {
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        announcement: false,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
      );

      if (settings.authorizationStatus != AuthorizationStatus.authorized) {
        Tools.logToConsole('User declined or has not accepted notification permissions.');
        // Exit early if permissions are not granted.
        return;
      }
    }

    // Retrieve the FCM token once and update if needed.
    try {
      AdminEntity admin = StoreProvider.of<AppState>(context).state.adminsState.admin;
      String token = await messaging.getToken();
      if (token != null) {
        // Save token if it has changed or is not set.
        if (prefs.getString('FCM_token_v3') != token) {
          await prefs.setString('FCM_token_v3', token);
          if (admin.apiToken != null) await GeneralApis.updateFirebaseTokenService(token);
        }
      }
    } catch (e) {
      Tools.logToConsole('Error getting FCM token: $e');
    }

    // Set up foreground message listener.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.data['type'] != null) if (message.data['type'] == 1) KammunRestart.restartApp(context);
      if (message.notification != null) _showOverlayNotification(message);
    });

    // Set up listener for when a notification is tapped/opened.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) =>
        showMyDialog(title: message.notification.title, text: message.notification.body, context: context));

    // Optionally handle the case when the app is launched from a terminated state.
    messaging.getInitialMessage().then((RemoteMessage message) {
      if (message != null) _showOverlayNotification(message);
    });
  }

  /// Displays a notification overlay using the overlay_support package.
  void _showOverlayNotification(RemoteMessage message) {
    final RemoteNotification notification = message.notification;
    if (notification != null) {
      entry = showOverlayNotification(
        (context) => Card(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: SafeArea(
            child: ListTile(
              onTap: () {},
              leading:
                  SizedBox.fromSize(size: const Size(40, 40), child: ClipOval(child: Image.asset('assets/kmIcon.png'))),
              title: Text(message.notification.title ?? 'Kammun', style: mainStyle),
              subtitle: Text(message.notification.body ?? '', style: mainStyle),
              trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    if (!Services.hasRole(context, shopperRole)) entry.dismiss();
                  }),
            ),
          ),
        ),
        duration: const Duration(milliseconds: 5000),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_firebaseInitDone) return Container();
    return widget.child;
  }
}
