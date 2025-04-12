import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return const FirebaseOptions(
        apiKey: 'AIzaSyC97W4_3TvIvwYKccNHVhK_v0ZfyjGLuzI',
        appId: '1:206951407498:web:7c5c5c5c5c5c5c5c5c5c5c',
        messagingSenderId: '206951407498',
        projectId: 'mediai-92407',
        authDomain: 'mediai-92407.firebaseapp.com',
        storageBucket: 'mediai-92407.appspot.com',
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return const FirebaseOptions(
          apiKey: 'AIzaSyC97W4_3TvIvwYKccNHVhK_v0ZfyjGLuzI',
          appId: '1:206951407498:android:7c5c5c5c5c5c5c5c5c5c5c',
          messagingSenderId: '206951407498',
          projectId: 'mediai-92407',
          storageBucket: 'mediai-92407.appspot.com',
        );

      case TargetPlatform.windows:
        return const FirebaseOptions(
          apiKey: 'AIzaSyC97W4_3TvIvwYKccNHVhK_v0ZfyjGLuzI',
          appId: '1:206951407498:windows:7c5c5c5c5c5c5c5c5c5c5c',
          messagingSenderId: '206951407498',
          projectId: 'mediai-92407',
          storageBucket: 'mediai-92407.appspot.com',
        );

      case TargetPlatform.iOS:
        return const FirebaseOptions(
          apiKey: 'AIzaSyC97W4_3TvIvwYKccNHVhK_v0ZfyjGLuzI',
          appId: '1:206951407498:ios:7c5c5c5c5c5c5c5c5c5c5c',
          messagingSenderId: '206951407498',
          projectId: 'mediai-92407',
          storageBucket: 'mediai-92407.appspot.com',
          iosClientId: 'YOUR_IOS_CLIENT_ID.apps.googleusercontent.com',
          iosBundleId: 'com.mediamosaic.mediamosaic',
        );

      case TargetPlatform.macOS:
        throw UnsupportedError(
          'No Firebase options have been configured for macOS platform',
        );

      case TargetPlatform.linux:
        throw UnsupportedError(
          'No Firebase options have been configured for linux platform',
        );

      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }
} 