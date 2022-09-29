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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBWrnIRUacuVgtBuYPY9SZLeCzyNfCK55E',
    appId: '1:980705884915:web:d90dc15f25759902d21586',
    messagingSenderId: '980705884915',
    projectId: 'flutter-login-ff4c5',
    authDomain: 'flutter-login-ff4c5.firebaseapp.com',
    storageBucket: 'flutter-login-ff4c5.appspot.com',
    measurementId: 'G-9QNEE1ZK46',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDuvkK4enDHejavFcQqYV_PMPOTfq9m9kE',
    appId: '1:980705884915:android:de2440c608d01a3ed21586',
    messagingSenderId: '980705884915',
    projectId: 'flutter-login-ff4c5',
    storageBucket: 'flutter-login-ff4c5.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA2-SBIB-xTXIV8T1dZCDPu0xvo1W52P_c',
    appId: '1:980705884915:ios:b7c09a376ea5a688d21586',
    messagingSenderId: '980705884915',
    projectId: 'flutter-login-ff4c5',
    storageBucket: 'flutter-login-ff4c5.appspot.com',
    iosClientId: '980705884915-t3hoso40ibh0d3b7fl2tvld64ud47t8d.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterApp2',
  );
}
