// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAksmtFgY6DzAuDrkTJ29GwJHayNpQQQe4',
    appId: '1:980994258161:web:5a8261cbcd59410a04e550',
    messagingSenderId: '980994258161',
    projectId: 'ai-slide-generator',
    authDomain: 'ai-slide-generator.firebaseapp.com',
    storageBucket: 'ai-slide-generator.appspot.com',
    measurementId: 'G-VZQGEJGD5V',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAyrWprbGaFpvcHjPQ0XuoVsP1fU--JntI',
    appId: '1:980994258161:android:b1eade4531a637fb04e550',
    messagingSenderId: '980994258161',
    projectId: 'ai-slide-generator',
    storageBucket: 'ai-slide-generator.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBbCH83nJ7_5-9QChBmUleCOK6pPJP5uZA',
    appId: '1:980994258161:ios:7a679d7db6f3a14504e550',
    messagingSenderId: '980994258161',
    projectId: 'ai-slide-generator',
    storageBucket: 'ai-slide-generator.appspot.com',
    iosBundleId: 'com.genius.aislides.generator',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBbCH83nJ7_5-9QChBmUleCOK6pPJP5uZA',
    appId: '1:980994258161:ios:b6592e3f76dcfb3704e550',
    messagingSenderId: '980994258161',
    projectId: 'ai-slide-generator',
    storageBucket: 'ai-slide-generator.appspot.com',
    iosBundleId: 'com.example.slideMaker.RunnerTests',
  );
}
