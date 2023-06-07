import 'dart:async';

import 'package:bot_main_app/features/map/blocs/map_bloc/map_bloc.dart';
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
        if (state.mapStatus == MapStatus.userPositionLoaded &&
            state.userPosition != null) {
          //Markers setup
          final markers = <Marker>{};
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

        return const CircularProgressIndicator();
      },
    );
  }
}
