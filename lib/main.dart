import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:slide_maker/app/provider/google_sign_in.dart';
import 'package:slide_maker/app/utills/ThemeNotifier.dart';

import 'app/routes/app_pages.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // MobileAds.instance.initialize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    // DeviceOrientation.landscapeRight,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // runApp(const MyApp());
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
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
          child: GetMaterialApp(
            navigatorObservers: <NavigatorObserver>[observer],
            builder: EasyLoading.init(),
            debugShowCheckedModeBanner: false,
            // theme: ThemeData.dark(),
            theme: ThemeData.light(), // Default light theme

            darkTheme: ThemeData(
              useMaterial3: true,
            ),

            themeMode: themeNotifier.themeMode,

            title: "Application",
            initialRoute: AppPages.INITIAL,
            getPages: AppPages.routes,
          ),
        ));
  }
}
