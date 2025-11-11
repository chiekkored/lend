import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lend/firebase_options.dart';

class MainService {
  static Future<void> initializeFirebase() async {
    // TODO use different firebase options for each env
    //   await Firebase.initializeApp(
    //   options: switch (env) {
    //     'localhost' => DefaultFirebaseOptionsLocal.currentPlatform,
    //     'dev' => DefaultFirebaseOptionsDev.currentPlatform,
    //     _ => DefaultFirebaseOptionsProd.currentPlatform,
    //   },
    // );
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  static Future<void> intializeGetStorage() async {
    await GetStorage.init();
  }

  static Future<void> loadEnv(String env) async {
    _printColoredEnv(env);
    await dotenv.load(fileName: 'envs/.$env.env');
  }

  static Future<void> initializeDeviceOrientation() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  static Future<void> useFirebaseEmulator() async {
    String host = '127.0.0.1';

    FirebaseAuth.instance.useAuthEmulator(host, 9099);
    FirebaseFunctions.instance.useFunctionsEmulator(host, 5001);
    FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
    FirebaseStorage.instance.useStorageEmulator(host, 5001);
  }

  static void _printColoredEnv(String env) {
    const reset = '\x1B[0m';
    const yellow = '\x1B[33m';
    const green = '\x1B[32m';
    const red = '\x1B[31m';

    late String color;
    switch (env) {
      case 'local':
        color = yellow;
        break;
      case 'dev':
        color = green;
        break;
      case 'prod':
        color = red;
        break;
      default:
        color = reset;
    }

    if (kDebugMode) print('$color🚀 Running in $env environment$reset');
  }
}
