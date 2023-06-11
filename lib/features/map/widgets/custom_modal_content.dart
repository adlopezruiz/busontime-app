import 'package:bot_main_app/features/map/blocs/map_bloc/map_bloc.dart';
import 'package:bot_main_app/l10n/l10n.dart';
import 'package:bot_main_app/utils/constants.dart';
import 'package:bot_main_app/widgets/countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomModalContent extends StatelessWidget {
  const CustomModalContent({
    super.key,
    required this.toMartosSchedule,
    required this.toJaenSchedule,
    required this.databaseName,
  });
  final List<dynamic> toMartosSchedule;
  final List<dynamic> toJaenSchedule;
  final String databaseName;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        if (state.mapStatus != MapStatus.loadingSchedule) {
          return Row(
            children: [
              if (databaseName != 'martos')
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            toMartosSchedule.isNotEmpty
                                ? l10n.nextStopToMartos
                                : l10n.noMoreDeparturesToday,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: AppColors.primaryGreen,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: toMartosSchedule.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: AppColors.primaryGreen,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: Center(
                                child: ListTile(
                                  trailing: index == 0
                                      ? CountdownTimer(
                                          targetTime:
                                              toMartosSchedule[index] as String,
                                          textStyle: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : const SizedBox(),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  title: Text(
                                    toMartosSchedule[index].toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              if (databaseName != 'jaen')
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            toJaenSchedule.isNotEmpty
                                ? l10n.nextStopToJaen
                                : l10n.noMoreDeparturesToday,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: AppColors.primaryGreen,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: toJaenSchedule.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: AppColors.primaryGreen,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: ListTile(
                                trailing: index == 0
                                    ? CountdownTimer(
                                        targetTime:
                                            toJaenSchedule[index] as String,
                                        textStyle: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : const SizedBox(),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                title: Text(
                                  toJaenSchedule[index].toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryGreen,
            ),
          );
        }
      },
    );
  }
}
