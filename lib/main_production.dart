import 'package:bot_main_app/app/app.dart';
import 'package:bot_main_app/bootstrap.dart';
import 'package:bot_main_app/dependency_injection/injector.dart';
import 'package:bot_main_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  setupDI();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await bootstrap(() => const App());
}
