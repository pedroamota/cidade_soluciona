// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: String.fromEnvironment('FIREBASE_WEB_API_KEY'),
    appId: String.fromEnvironment('FIREBASE_WEB_APP_ID'),
    messagingSenderId: '441660458336',
    projectId: 'cidade-soluciona',
    authDomain: 'cidade-soluciona.firebaseapp.com',
    storageBucket: 'cidade-soluciona.appspot.com',
    measurementId: 'G-G71LE48XQJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: String.fromEnvironment('FIREBASE_ANDROID_API_KEY'),
    appId: String.fromEnvironment('FIREBASE_ANDROID_APP_ID'),
    messagingSenderId: '441660458336',
    projectId: 'cidade-soluciona',
    storageBucket: 'cidade-soluciona.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: String.fromEnvironment('FIREBASE_IOS_API_KEY'),
    appId: String.fromEnvironment('FIREBASE_IOS_APP_ID'),
    messagingSenderId: '441660458336',
    projectId: 'cidade-soluciona',
    storageBucket: 'cidade-soluciona.appspot.com',
    iosBundleId: 'com.example.cidadeSoluciona',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: String.fromEnvironment('FIREBASE_MACOS_API_KEY'),
    appId: String.fromEnvironment('FIREBASE_MACOS_APP_ID'),
    messagingSenderId: '441660458336',
    projectId: 'cidade-soluciona',
    storageBucket: 'cidade-soluciona.appspot.com',
    iosBundleId: 'com.example.cidadeSoluciona',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: String.fromEnvironment('FIREBASE_WINDOWS_API_KEY'),
    appId: String.fromEnvironment('FIREBASE_WINDOWS_APP_ID'),
    messagingSenderId: '441660458336',
    projectId: 'cidade-soluciona',
    authDomain: 'cidade-soluciona.firebaseapp.com',
    storageBucket: 'cidade-soluciona.appspot.com',
    measurementId: 'G-NWF3D8FHDP',
  );
}
