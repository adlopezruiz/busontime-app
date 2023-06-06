import 'package:bot_main_app/dependency_injection/injector.dart';
import 'package:bot_main_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBars {
  static PreferredSizeWidget onlyWithArrowBack({
    required String arrowRoute,
  }) {
    return AppBar(
      iconTheme: const IconThemeData(
        color: AppColors.primaryBlack,
        size: 36,
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: Padding(
        padding: const EdgeInsets.only(
          top: 16,
        ),
        child: BackButton(
          onPressed: () => getIt<GoRouter>().go(arrowRoute),
        ),
      ),
    );
  }

  static PreferredSizeWidget arrowBackJustPopsOne() {
    return AppBar(
      iconTheme: const IconThemeData(
        color: AppColors.primaryBlack,
        size: 36,
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: Padding(
        padding: const EdgeInsets.only(
          top: 16,
        ),
        child: BackButton(
          onPressed: () => getIt<GoRouter>().pop(),
        ),
      ),
    );
  }
}
