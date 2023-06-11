import 'package:bot_main_app/dependency_injection/injector.dart';
import 'package:bot_main_app/features/favorites/cubit/favorites_cubit.dart';
import 'package:bot_main_app/features/home/bloc/weather/weather_bloc.dart';
import 'package:bot_main_app/features/profile/bloc/profile_cubit.dart';
import 'package:bot_main_app/repository/line_repository.dart';
import 'package:bot_main_app/ui/atoms/spacers.dart';
import 'package:bot_main_app/ui/atoms/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final currentUser = getIt<ProfileCubit>().state.user;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/${state.imageAsset}'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppTextStyles.textWithTransparency(
                            text: '${state.weather.temp.round()}°',
                            fontSize: 150,
                          ),
                          AppTextStyles.textWithTransparency(
                            text: 'Jaén, Andalucía',
                            fontSize: 32,
                          ),
                        ],
                      ),
                      AppTextStyles.textWithTransparency(
                        text:
                            'Hola ${currentUser.name.split(' ').first},\n¿Próxima parada?',
                        fontSize: 36,
                      ),
                      //Buttons
                      SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 5,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 3,
                                  height: 120,
                                  child: IconButton(
                                    onPressed: () {
                                      getIt<LineRepository>().getLineData();
                                      getIt<GoRouter>().push('/fullSchedule');
                                    },
                                    icon: Image.asset(
                                      'assets/icons/calendar-icon.png',
                                    ),
                                  ),
                                ),
                                AppTextStyles.textWithTransparency(
                                  text: 'Horario',
                                  fontSize: 22,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            HorizontalSpacer.triple(),
                            Column(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 3,
                                  height: 120,
                                  child: IconButton(
                                    onPressed: () {
                                      if (getIt<FavoritesCubit>()
                                              .state
                                              .favoritesStatus !=
                                          FavoritesStatus.initial) {
                                        getIt<FavoritesCubit>().reloadState();
                                      }

                                      getIt<GoRouter>().push('/favorites');
                                    },
                                    icon: Image.asset(
                                      'assets/icons/fav-icon.png',
                                    ),
                                  ),
                                ),
                                AppTextStyles.textWithTransparency(
                                  text: 'Favoritas',
                                  fontSize: 22,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
