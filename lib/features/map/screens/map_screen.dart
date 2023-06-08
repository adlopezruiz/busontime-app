import 'dart:async';

import 'package:bot_main_app/dependency_injection/injector.dart';
import 'package:bot_main_app/features/map/blocs/map_bloc/map_bloc.dart';
import 'package:bot_main_app/models/stop_model.dart';
import 'package:bot_main_app/repository/auth_repository.dart';
import 'package:bot_main_app/ui/atoms/spacers.dart';
import 'package:bot_main_app/ui/atoms/text_styles.dart';
import 'package:bot_main_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  MapScreen({super.key});

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        if ((state.mapStatus == MapStatus.routesLoaded ||
                state.mapStatus == MapStatus.stopsSchedulesLoaded) &&
            state.userPosition != null) {
          //Markers setup
          final markers = <Marker>{}..
                //User marker, this is cascade coding, yes, relax
                add(
              Marker(
                markerId: MarkerId(
                  getIt<AuthRepository>().currentUser?.displayName ?? 'user',
                ),
                position: state.userPosition ?? const LatLng(0, 0),
              ),
            );

          //Adding markers to the map
          for (final stop in state.stops) {
            final marker = Marker(
              markerId: MarkerId(stop.databaseName),
              position: stop.location,
              onTap: () {
                getIt<MapBloc>().add(
                  StopSchedulesRequest(
                    stopName: stop.databaseName,
                  ),
                );
                _showBottomSheet(context: context, stopData: stop);
              },
              icon: state.customIcon ?? BitmapDescriptor.defaultMarker,
            );
            markers.add(marker);
          }

          return GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: const CameraPosition(
              // state.userPosition ??
              target: LatLng(37.77176635325846, -3.7866687868666133),
              zoom: 12.4746,
            ),
            onMapCreated: _controller.complete,
            markers: markers,
            polylines: state.busRoute ?? {},
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

//Bottom modal window
void _showBottomSheet({required BuildContext context, StopModel? stopData}) {
  showModalBottomSheet<void>(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
    ),
    context: context,
    builder: (context) {
      return BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          return Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: Container(
                    height: 100, // Adjust the height as desired
                    color: AppColors.primaryGreen, // Color for the top section
                    // Customize the content for the top section
                    child: Column(
                      children: [
                        AppTextStyles.textWithTransparency(
                          textAlign: TextAlign.center,
                          text: stopData?.name ?? 'No hay datos de esta parada',
                          fontSize: 32,
                        ),
                        AppTextStyles.textWithTransparency(
                          text: stopData?.street ?? 'Sin dirección',
                          fontSize: 18,
                        ),
                        VerticalSpacer.regular(),
                        AppTextStyles.textWithTransparency(
                          text: 'Próximas salidas',
                          fontSize: 24,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                top: MediaQuery.of(context).size.height * 0.15,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: ColoredBox(
                    color: Colors.white,
                    // Color for the bottom section
                    // Customize the content for the bottom section
                    child: CustomModalContent(
                      databaseName: stopData?.databaseName ?? '',
                      toJaenSchedule: state.toJaenSchedule ?? [],
                      toMartosSchedule: state.toMartosSchedule ?? [],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

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
    return Row(
      children: [
        if (databaseName != 'martos')
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Sentido Martos',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
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
                        child: ListTile(
                          trailing: IconButton(
                            icon: const Icon(
                              size: 24,
                              Icons.favorite_border,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
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
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        // if (databaseName != 'jaen' && databaseName != 'martos')
        //   const VerticalDivider(
        //     color: AppColors.primaryGrey,
        //     thickness: 2,
        //   ),
        if (databaseName != 'jaen')
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Sentido Jaén',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
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
                          trailing: IconButton(
                            icon: const Icon(
                              size: 24,
                              Icons.favorite_border,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
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
  }
}
