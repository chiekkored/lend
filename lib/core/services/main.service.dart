import 'package:firebase_core/firebase_core.dart';
import 'package:lend/firebase_options.dart';

class MainService {
  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
