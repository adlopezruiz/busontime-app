import 'package:bot_main_app/features/home/bloc/navbar_cubit/navbar_cubit.dart';
import 'package:bot_main_app/features/home/screens/home_screen.dart';
import 'package:bot_main_app/features/home/screens/map_screen.dart';
import 'package:bot_main_app/features/home/screens/profile_screen.dart';
import 'package:bot_main_app/features/home/widgets/navbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<NavbarCubit, NavbarState>(
            builder: (context, state) {
              if (state.pageStatus == PageStatus.homePage) {
                return const HomeScreen();
              } else if (state.pageStatus == PageStatus.mapPage) {
                return const MapScreen();
              } else {
                return const ProfileScreen();
              }
            },
          ),
        ),
        bottomNavigationBar: const HomeScreenNavbar(),
      ),
    );
  }
}
