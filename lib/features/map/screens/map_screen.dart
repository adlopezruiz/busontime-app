import 'dart:async';
import 'package:bot_main_app/dependency_injection/injector.dart';
import 'package:bot_main_app/features/favorites/cubit/favorites_cubit.dart';
import 'package:bot_main_app/features/map/blocs/map_bloc/map_bloc.dart';
import 'package:bot_main_app/features/map/widgets/custom_modal_content.dart';
import 'package:bot_main_app/l10n/l10n.dart';
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
    final l10n = context.l10n;
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        if (state.mapStatus == MapStatus.userPermissionDenied ||
            state.mapStatus == MapStatus.error) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l10n.upsError,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                  fontSize: 28,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        if ((state.mapStatus == MapStatus.routesLoaded ||
                state.mapStatus == MapStatus.stopsSchedulesLoaded ||
                state.mapStatus == MapStatus.loadingSchedule) &&
            state.userPosition != null) {
          //Markers setup
          final markers = <Marker>{}..
                //User marker, this is cascade coding, yes, relax
                add(
              Marker(
                markerId: MarkerId(
                  getIt<AuthRepository>().currentUser?.displayName ?? 'user',
                ),
                position: state.userPosition ??
                    const LatLng(37.77176635325846, -3.7866687868666133),
                icon: state.customUserMarker ?? BitmapDescriptor.defaultMarker,
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
            initialCameraPosition: CameraPosition(
              target: state.userPosition ??
                  const LatLng(37.77176635325846, -3.7866687868666133),
              zoom: 14.4746,
            ),
            onMapCreated: _controller.complete,
            markers: markers,
            polylines: state.busRoute ?? {},
          );
        }

        return Center(
          child: Image.asset(
            'assets/images/loading-marker.gif',
            width: 150,
          ),
        );
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
                        VerticalSpacer.regular(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            BlocBuilder<FavoritesCubit, FavoritesState>(
                              builder: (context, state) {
                                return IconButton(
                                  icon: Icon(
                                    size: 32,
                                    state.favoritesList
                                            .contains(stopData?.id ?? '')
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: state.favoritesList
                                            .contains(stopData?.id ?? '')
                                        ? Colors.red
                                        : Colors.white,
                                  ),
                                  onPressed: state.favoritesStatus !=
                                          FavoritesStatus.loading
                                      ? () {
                                          //Avoid multi click on favorites with status check
                                          final favoritesCubit =
                                              getIt<FavoritesCubit>();
                                          if (state.favoritesList
                                              .contains(stopData?.id ?? '')) {
                                            //Delete it from the list.
                                            favoritesCubit.deleteFromFavorites(
                                              stopData?.id ?? '',
                                            );
                                          } else {
                                            //Add stop id to favorites list using favorites cubit
                                            favoritesCubit.addToFavorites(
                                              stopData?.id ?? '',
                                            );
                                          }
                                        }
                                      : null,
                                );
                              },
                            ),
                            HorizontalSpacer.regular(),
                            AppTextStyles.textWithTransparency(
                              textAlign: TextAlign.center,
                              text: stopData?.name ??
                                  context.l10n.noDataOfThisStop,
                              fontSize: 32,
                            ),
                          ],
                        ),
                        AppTextStyles.textWithTransparency(
                          text: stopData?.street ?? context.l10n.noDirection,
                          fontSize: 24,
                        ),
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
