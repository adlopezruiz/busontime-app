import 'package:bot_main_app/dependency_injection/injector.dart';
import 'package:bot_main_app/features/home/bloc/weather/weather_bloc.dart';
import 'package:bot_main_app/features/home/screens/home_screen.dart';
import 'package:bot_main_app/features/map/blocs/map_bloc/map_bloc.dart';
import 'package:bot_main_app/features/map/screens/map_screen.dart';
import 'package:bot_main_app/features/navbar/bloc/navbar_cubit/navbar_cubit.dart';
import 'package:bot_main_app/features/navbar/widgets/navbar_widget.dart';
import 'package:bot_main_app/features/profile/bloc/profile_cubit.dart';
import 'package:bot_main_app/features/profile/screens/profile_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: BlocBuilder<NavbarCubit, NavbarState>(
          builder: (context, state) {
            if (state.pageStatus == PageStatus.homePage) {
              //Load user profile data
              getIt<ProfileCubit>().getProfile();
              return BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, state) {
                  final weatherBloc = getIt<WeatherBloc>();
                  //Avoid a lot of api calls condition
                  if (weatherBloc.state.status == WeatherStatus.initial) {
                    Future.delayed(
                      const Duration(seconds: 3),
                      () => weatherBloc
                          .add(const FetchWeatherEvent(city: 'Jaen')),
                    );
                    return Center(
                      child: Image.asset(
                        'assets/images/loading-bus.gif',
                        width: 150,
                      ),
                    );
                  }
                  if (weatherBloc.state.status == WeatherStatus.loaded) {
                    return HomeScreen();
                  } else {
                    return Center(
                      child: Image.asset(
                        'assets/images/loading-bus.gif',
                        width: 150,
                      ),
                    );
                  }
                },
              );
            } else if (state.pageStatus == PageStatus.mapPage) {
              //Triggering bloc magic, this takes a while... needs check
              final mapBloc = getIt<MapBloc>();
              //Avoid a lot of api calls condition
              if (mapBloc.state.mapStatus == MapStatus.initial) {
                mapBloc.add(LocationPermissionRequest());
              }
              return MapScreen();
            } else {
              //TODO Design profile UI
              return const ProfileScreen();
            }
          },
        ),
        bottomNavigationBar: const HomeScreenNavbar(),
      ),
    );
  }
}
