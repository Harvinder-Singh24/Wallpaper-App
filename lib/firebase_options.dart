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
    apiKey: 'AIzaSyCwWcCcHrflvO2c3-2-k3Mp1wLiyfODbuM',
    appId: '1:430965875310:web:b819e1d4a6b97c5e367c7f',
    messagingSenderId: '430965875310',
    projectId: 'walldeco-c1d3e',
    authDomain: 'walldeco-c1d3e.firebaseapp.com',
    storageBucket: 'walldeco-c1d3e.appspot.com',
    measurementId: 'G-BNGB7G62HL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAos8coDU9Lpqq6djXX0OJ3leQtRUzT8g8',
    appId: '1:430965875310:android:f5f920688a6db6a9367c7f',
    messagingSenderId: '430965875310',
    projectId: 'walldeco-c1d3e',
    storageBucket: 'walldeco-c1d3e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDghbfP3YUd57xNXg8--EqMhlenkj-S_1g',
    appId: '1:430965875310:ios:32070ba74a9409c2367c7f',
    messagingSenderId: '430965875310',
    projectId: 'walldeco-c1d3e',
    storageBucket: 'walldeco-c1d3e.appspot.com',
    androidClientId: '430965875310-4d05jbcg989k0nv6mst65n50psp0r30s.apps.googleusercontent.com',
    iosClientId: '430965875310-a9s3c7o73pjfu1bpvpqo5621i187issg.apps.googleusercontent.com',
    iosBundleId: 'com.example.wallpaper',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDghbfP3YUd57xNXg8--EqMhlenkj-S_1g',
    appId: '1:430965875310:ios:32070ba74a9409c2367c7f',
    messagingSenderId: '430965875310',
    projectId: 'walldeco-c1d3e',
    storageBucket: 'walldeco-c1d3e.appspot.com',
    androidClientId: '430965875310-4d05jbcg989k0nv6mst65n50psp0r30s.apps.googleusercontent.com',
    iosClientId: '430965875310-a9s3c7o73pjfu1bpvpqo5621i187issg.apps.googleusercontent.com',
    iosBundleId: 'com.example.wallpaper',
  );
}