import 'package:bot_main_app/dependency_injection/injector.dart';
import 'package:bot_main_app/features/favorites/cubit/favorites_cubit.dart';
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

  static PreferredSizeWidget arrowBackJustPopsOne({bool? updateFavorites}) {
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
          onPressed: () {
            if (updateFavorites != null && updateFavorites == true) {
              getIt<FavoritesCubit>().updateUserData();
            }
            getIt<GoRouter>().pop();
          },
        ),
      ),
    );
  }
}
