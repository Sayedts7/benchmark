import 'package:benchmark_estimate/firebase_options.dart';
import 'package:benchmark_estimate/view/splash/splash_screen.dart';
import 'package:benchmark_estimate/view_model/firebase/global.dart';
import 'package:benchmark_estimate/view_model/firebase/notification_services.dart';
import 'package:benchmark_estimate/view_model/firebase/push_notifications.dart';
import 'package:benchmark_estimate/view_model/provider/category_provider.dart';
import 'package:benchmark_estimate/view_model/provider/checkbox_provider.dart';
import 'package:benchmark_estimate/view_model/provider/file_picker_provider.dart';
import 'package:benchmark_estimate/view_model/provider/homescreen_status_provider.dart';
import 'package:benchmark_estimate/view_model/provider/loader_view_provider.dart';
import 'package:benchmark_estimate/view_model/provider/obsecure_provider.dart';
import 'package:benchmark_estimate/view_model/provider/user_profile_edit%20_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

Future FirebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}


//testing nots
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

void main()async {
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
// .then((value) {
//   FirebaseMessaging.onBackgroundMessage(FirebaseMessagingBackgroundHandler);
// });

await NotificationServices().setupNotificationChannels();

//testing nots

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
@override
  void initState() {
  notificationServices.requestAndRegisterNotification(context);
  // notificationServices.setupInteractMessage(context);

  // TODO: implement initState
    super.initState();
  }

//test nots
// void initState() {
//   super.initState();
//   NotificationService notificationService = NotificationService();
//   NotificationService.initialize();
//
//   // Check and request permissions
//   notificationService.checkAndRequestPermissions(context);
//
//
//   // For handling notification when the app is in foreground
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     print('hrllllooooooooooooooo');
//     print(message.notification?.title);
//     print(message.notification?.body);
//
//     NotificationService.display(message);
//   });
//
//   // For handling notification when the app is in background but not terminated
//   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//     print(' here in For handling notification when the app is in background but not terminated');
//     // TODO: handle the message and navigate if needed
//     print(message.notification?.title);
//     print(message.notification?.body);
//     NotificationService.display(message);
//
//   });
//
//   // For handling notification when the app is terminated
//   FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
//     print(' here in        For handling notification when the app is terminated');
//     print(message?.notification?.title);
//     print(message?.notification?.body);
//     if (message != null) {
//       // TODO: handle the message and navigate if needed
//       NotificationService.display(message);
//
//     }
//   });
//
//   // Get and save FCM token
// }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => CheckBoxProvider()),
      ChangeNotifierProvider(create: (_) => ObscureProvider()),
      ChangeNotifierProvider(create: (_) => FilePickerProvider()),
      ChangeNotifierProvider(create: (_) => LoaderViewProvider()),
      ChangeNotifierProvider(create: (_) => UserProfileProvider()),
      ChangeNotifierProvider(create: (_) => CategoryProvider()),
      ChangeNotifierProvider(create: (_) => HomeScreenStatusProvider()),
      //test nots need to uncomment code below
      ChangeNotifierProvider(create: (_) => NotificationServices()),




    ],
      child: OverlaySupport.global(
      child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,

          ),
          home: const SplashScreen()
      ),
    ),);
  }
}
