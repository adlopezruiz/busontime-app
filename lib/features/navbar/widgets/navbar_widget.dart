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
      height: 70,
      elevation: 5,
      backgroundColor: AppColors.primaryGreen,
      activeColor: Colors.white,
      style: TabStyle.reactCircle,
      items: const [
        TabItem(icon: Icons.home, title: 'Inicio'),
        TabItem(icon: Icons.map_outlined, title: 'Mapa'),
        TabItem(icon: Icons.person, title: 'Perfil'),
      ],
      onTap: (int index) => getIt<NavbarCubit>().changePage(index),
    );
  }
}
