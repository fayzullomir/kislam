// import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCtkKEaUb9jHK0_AQNdSpDptfIJVBbXkXI',
    appId: '1:793244831536:android:89dd352020320b865bc2f5',
    messagingSenderId: '793244831536',
    projectId: 'korean-muslim-app',
    storageBucket: 'korean-muslim-app.firebasestorage.app',
  );
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBieHp96FuNuzXomI_bD2xopXf1sI9IB-s',
    appId: '1:793244831536:ios:a05d68d1a08a11a95bc2f5',
    messagingSenderId: '793244831536',
    projectId: 'korean-muslim-app',
    storageBucket: 'korean-muslim-app.firebasestorage.app',
    iosBundleId: 'org.koreaislam.mobile',
  );
}
