import 'package:bot_main_app/utils/router.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

GetIt getIt = GetIt.instance;

void setupDI() {
  getIt.registerSingleton<GoRouter>(
    setupRouter(),
  );
}
