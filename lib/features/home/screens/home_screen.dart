import 'dart:async';

import 'package:bot_main_app/features/auth/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.71692377414158, -3.971506257651135),
    zoom: 14.4746,
  );

  static const CameraPosition _kJaen = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.77176635325846, -3.7866687868666133),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Home'),
          actions: [
            IconButton(
              onPressed: () {
                context.read<AuthBloc>().add(SignOutRequestedEvent());
              },
              icon: const Icon(Icons.exit_to_app),
            ),
            IconButton(
              onPressed: () {
                GetIt.I<GoRouter>().push('/profile');
              },
              icon: const Icon(Icons.account_circle),
            )
          ],
        ),
        body: GoogleMap(
          mapType: MapType.hybrid,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: _controller.complete,
          markers: {
            Marker(
              markerId: const MarkerId('Martos'),
              position: const LatLng(37.71692377414158, -3.971506257651135),
              draggable: true,
              onDragEnd: (value) {
                // value is the new position
              },
              // To do: custom marker icon
            ),
            const Marker(
              markerId: MarkerId('Jaen'),
              position: LatLng(37.77176635325846, -3.7866687868666133),
            ),
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _goToJaen,
          label: const Text('A Jaén ni pollas!'),
          icon: const Icon(Icons.location_city),
        ),
      ),
    );
  }

  Future<void> _goToJaen() async {
    final controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kJaen));
  }
}
