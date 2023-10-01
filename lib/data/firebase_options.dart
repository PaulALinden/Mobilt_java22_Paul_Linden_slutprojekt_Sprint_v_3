import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

//Firestore Config.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyC5zJOJ8W8N-h8jRRgHwqT5aS2jP9TTLi0',
    appId: '1:77934051442:web:3bcc6bc6c7d992ace582eb',
    messagingSenderId: '77934051442',
    projectId: 'sprintv3-39b07',
    authDomain: 'sprintv3-39b07.firebaseapp.com',
    storageBucket: 'sprintv3-39b07.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDViq2tKfRAA8NvuUk9lfEOogDQGoT-OQ8',
    appId: '1:77934051442:android:11c9ee2e34d82735e582eb',
    messagingSenderId: '77934051442',
    projectId: 'sprintv3-39b07',
    storageBucket: 'sprintv3-39b07.appspot.com',
  );
}
