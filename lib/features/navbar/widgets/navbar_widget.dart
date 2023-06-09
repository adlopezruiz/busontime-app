import 'package:bot_main_app/dependency_injection/injector.dart';
import 'package:bot_main_app/features/navbar/bloc/navbar_cubit/navbar_cubit.dart';
import 'package:bot_main_app/utils/constants.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

class HomeScreenNavbar extends StatelessWidget {
  const HomeScreenNavbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
          title: 'Inicio',
        ),
        TabItem(
            icon: Image.asset(
              'assets/icons/map-icon.png',
            ),
            title: 'Mapa'),
        TabItem(
            icon: Image.asset(
              'assets/icons/user-icon.png',
            ),
            title: 'Perfil'),
      ],
      onTap: (int index) => getIt<NavbarCubit>().changePage(index),
    );
  }
}
