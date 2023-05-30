import 'package:bot_main_app/features/home_page/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRouter setupRouter() {
  final routes = [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) =>
          const HomeScreen(),
    ),
    // GoRoute(
    //   path: '/details',
    //   builder: (BuildContext context, GoRouterState state) =>
    //       DetailsScreen(),
    // ),
    // Add more routes as needed...
  ];

  return GoRouter(
    routes: routes,
  );
}
