import 'package:bot_main_app/dependency_injection/injector.dart';
import 'package:bot_main_app/features/favorites/cubit/favorites_cubit.dart';
import 'package:bot_main_app/features/map/blocs/map_bloc/map_bloc.dart';
import 'package:bot_main_app/repository/line_repository.dart';
import 'package:bot_main_app/ui/atoms/appbars.dart';
import 'package:bot_main_app/ui/atoms/spacers.dart';
import 'package:bot_main_app/utils/constants.dart';
import 'package:bot_main_app/widgets/countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: AppColors.secondaryGrey,
        appBar: AppBars.arrowBackJustPopsOne(
          updateFavorites: true,
        ),
        body: Column(
          children: [
            VerticalSpacer.regular(),
            const Text(
              'Paradas favoritas',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
            ),
            const Text(
              'Puedes eliminar cualquiera arrastrandola a la derecha',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: AppColors.primaryBlack,
              ),
            ),
            Expanded(
              child: BlocBuilder<FavoritesCubit, FavoritesState>(
                builder: (context, state) {
                  if (state.favoritesStatus == FavoritesStatus.loaded) {
                    if (state.favoritesList.isEmpty) {
                      return const Center(
                        child: Text(
                          'Aún no tienes paradas favoritas\n¡Añade algunas y aprovecha\nesta funcionalidad!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGreen,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    } else {
                      return CustomScrollView(
                        slivers: [
                          SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              childCount: state.stopsData.length,
                              (context, int index) {
                                return Dismissible(
                                  direction: DismissDirection.startToEnd,
                                  background:
                                      Container(color: Colors.red.shade300),
                                  onDismissed: (direction) {
                                    getIt<FavoritesCubit>().deleteFromFavorites(
                                      state.stopsData[index].id,
                                    );
                                  },
                                  key: Key(state.stopsData[index].id),
                                  child: FutureBuilder(
                                    future: _getFirstBusHours(
                                      state.stopsData[index].databaseName,
                                    ),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return const Center(
                                          child: CircularProgressIndicator(
                                            color: AppColors.primaryGreen,
                                          ),
                                        );
                                      }
                                      return Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                        ),
                                        margin: const EdgeInsets.all(8),
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            image: DecorationImage(
                                              image: AssetImage(
                                                'assets/images/${state.stopsData[index].databaseName}.jpeg',
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                state.stopsData[index].name,
                                                style: const TextStyle(
                                                  fontSize: 38,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                state.stopsData[index].street,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              VerticalSpacer.regular(),
                                              const Text(
                                                'Próximas salidas',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 32,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              if (snapshot.hasData)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      if (state.stopsData[index]
                                                              .databaseName !=
                                                          'martos') ...[
                                                        Column(
                                                          children: [
                                                            if (snapshot.data!
                                                                .isNotEmpty)
                                                              const Text(
                                                                'Martos',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 32,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            if (snapshot.data!
                                                                .isNotEmpty)
                                                              CountdownTimer(
                                                                targetTime:
                                                                    snapshot
                                                                        .data![0],
                                                                textStyle:
                                                                    const TextStyle(
                                                                  fontSize: 32,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              )
                                                            else
                                                              const SizedBox(),
                                                            HorizontalSpacer
                                                                .regular(),
                                                          ],
                                                        ),
                                                      ],
                                                      if (state.stopsData[index]
                                                                  .databaseName !=
                                                              'jaen' &&
                                                          state.stopsData[index]
                                                                  .databaseName !=
                                                              'martos')
                                                        HorizontalSpacer
                                                            .regular(),
                                                      if (state.stopsData[index]
                                                              .databaseName !=
                                                          'jaen') ...[
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            HorizontalSpacer
                                                                .regular(),
                                                            if (snapshot.data!
                                                                    .length ==
                                                                2)
                                                              const Text(
                                                                'Jaén',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 32,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            if (snapshot.data!
                                                                    .length ==
                                                                2)
                                                              CountdownTimer(
                                                                targetTime:
                                                                    snapshot
                                                                        .data![1],
                                                                textStyle:
                                                                    const TextStyle(
                                                                  fontSize: 32,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              )
                                                            else
                                                              const SizedBox(),
                                                          ],
                                                        ),
                                                      ]
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }
                  }
                  return Center(
                    child: Image.asset(
                      'assets/images/fav-icon-animated.gif',
                      width: 150,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<List<String>> _getFirstBusHours(String name) async {
  final hoursList = <String>[];

  final mapBloc = getIt<MapBloc>();
  final lineRepo = getIt<LineRepository>();

  final toMartosHour = mapBloc.filterScheduleByActualHour(
    await lineRepo.getTodayScheduleByStop(
      name,
      'martos',
    ),
  );
  final toJaenHour = mapBloc.filterScheduleByActualHour(
    await lineRepo.getTodayScheduleByStop(
      name,
      'jaen',
    ),
  );

  if (toMartosHour.isNotEmpty) {
    hoursList.add(toMartosHour.first as String);
  }
  if (toJaenHour.isNotEmpty) {
    hoursList.add(toJaenHour.first as String);
  }

  return hoursList;
}
