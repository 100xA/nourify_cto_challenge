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
    apiKey: 'AIzaSyB5ikIX8vIL2gAO-9G_UnR1eUMdrmGmCkM',
    appId: '1:861990325708:web:8fa31564553bfdf1e26169',
    messagingSenderId: '861990325708',
    projectId: 'nf-garmin-development',
    authDomain: 'nf-garmin-development.firebaseapp.com',
    databaseURL: 'https://nf-garmin-development-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'nf-garmin-development.appspot.com',
    measurementId: 'G-LZG9MW8X0L',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBtxrNrGBe76uZRhZrclT_aXyInqApAdRQ',
    appId: '1:861990325708:android:2c930588b557585ee26169',
    messagingSenderId: '861990325708',
    projectId: 'nf-garmin-development',
    databaseURL: 'https://nf-garmin-development-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'nf-garmin-development.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyATuU2JGAW-Nfvjilh7ACcfRvT7SarLNPw',
    appId: '1:861990325708:ios:449c36849438b976e26169',
    messagingSenderId: '861990325708',
    projectId: 'nf-garmin-development',
    databaseURL: 'https://nf-garmin-development-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'nf-garmin-development.appspot.com',
    iosBundleId: 'com.example.nourifyCtoChallenge',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyATuU2JGAW-Nfvjilh7ACcfRvT7SarLNPw',
    appId: '1:861990325708:ios:012726d722caaaa9e26169',
    messagingSenderId: '861990325708',
    projectId: 'nf-garmin-development',
    databaseURL: 'https://nf-garmin-development-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'nf-garmin-development.appspot.com',
    iosBundleId: 'com.example.nourifyCtoChallenge.RunnerTests',
  );
}
