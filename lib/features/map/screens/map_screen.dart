import 'dart:async';

import 'package:bot_main_app/dependency_injection/injector.dart';
import 'package:bot_main_app/features/map/blocs/map_bloc/map_bloc.dart';
import 'package:bot_main_app/repository/auth_repository.dart';
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
        if (state.mapStatus == MapStatus.userPositionLoaded &&
            state.userPosition != null) {
          //Markers setup
          final markers = <Marker>{}..
                //User marker, this is cascade coding, yes, relax
                add(
              Marker(
                onTap: () => _showBottomSheet(context),
                markerId: MarkerId(
                  getIt<AuthRepository>().currentUser?.uid ?? 'user',
                ),
                position: state.userPosition ?? const LatLng(0, 0),
              ),
            );
          //Adding markers to the map
          for (final stop in state.stops) {
            final marker =
                Marker(markerId: MarkerId(stop.name), position: stop.location);
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
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

void _showBottomSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    builder: (context) {
      return Container(
        // Customize the content of the bottom sheet as needed
        child: Column(
          children: [
            // Add the content you want to display in the bottom sheet
            Text('Hola!')
          ],
        ),
      );
    },
  );
}
