import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:slide_maker/app/modules/showppt/views/ppt_viewer.dart';
import 'package:slide_maker/app/notificationservice/local_notification_service.dart';
import 'package:slide_maker/app/provider/google_sign_in.dart';
import 'package:slide_maker/app/utills/ThemeNotifier.dart';

import 'app/routes/app_pages.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // MobileAds.instance.initialize();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //? Push Notification Implementation
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  LocalNotificationService.initialize();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    // DeviceOrientation.landscapeRight,
  ]);

  // runApp(const MyApp());

  const fatalError = true;

  // Non-async exceptions
  FlutterError.onError = (errorDetails) {
    if (fatalError) {
      // If you want to record a "fatal" exception
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      // ignore: dead_code
    } else {
      // If you want to record a "non-fatal" exception
      FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    }
  };

  // Async exceptions
  PlatformDispatcher.instance.onError = (error, stack) {
    if (fatalError) {
      // If you want to record a "fatal" exception
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      // ignore: dead_code
    } else {
      // If you want to record a "non-fatal" exception
      FirebaseCrashlytics.instance.recordError(error, stack);
    }
    return true;
  };

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Message Title: ${message.notification!.title.toString()}");
  print("Message body: ${message.notification!.body.toString()}");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  @override
  Widget build(BuildContext context) {
    analytics.setAnalyticsCollectionEnabled(true);
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    // EasyLoading.init();
    observer.analytics.setAnalyticsCollectionEnabled(kReleaseMode);
    return ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus!.unfocus();
            }
          },
          child: ScreenUtilInit(
              minTextAdapt: true,
              designSize: const Size(1428, 2000),
              builder: (BuildContext context, Widget? child) {
                return GetMaterialApp(
                  navigatorObservers: <NavigatorObserver>[observer],
                  builder: EasyLoading.init(),
                  debugShowCheckedModeBanner: false,
                  // theme: ThemeData.dark(),
                  theme: ThemeData.light(), // Default light theme

                  darkTheme: ThemeData(
                    useMaterial3: true,
                  ),

                  themeMode: themeNotifier.themeMode,
                  // home: CustomPDFViewer(),
                  // title: "Application",
                  initialRoute: AppPages.INITIAL,
                  getPages: AppPages.routes,
                );
              }),
        ));
  }
}
