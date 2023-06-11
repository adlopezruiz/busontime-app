import 'package:bot_main_app/dependency_injection/injector.dart';
import 'package:bot_main_app/features/navbar/bloc/navbar_cubit/navbar_cubit.dart';
import 'package:bot_main_app/l10n/l10n.dart';
import 'package:bot_main_app/utils/constants.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

class HomeScreenNavbar extends StatelessWidget {
  const HomeScreenNavbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ConvexAppBar(
      initialActiveIndex: 0,
      top: -10,
      curveSize: 120,
      height: 60,
      elevation: 5,
      backgroundColor: AppColors.primaryGreen,
      style: TabStyle.react,
      items: [
        TabItem(
          icon: Image.asset(
            'assets/icons/home-icon.png',
          ),
          title: l10n.homeLabel,
        ),
        TabItem(
          icon: Image.asset(
            'assets/icons/map-icon.png',
          ),
          title: l10n.mapLabel,
        ),
        TabItem(
          icon: Image.asset(
            'assets/icons/user-icon.png',
          ),
          title: l10n.profileLabel,
        ),
      ],
      onTap: (int index) => getIt<NavbarCubit>().changePage(index),
    );
  }
}
