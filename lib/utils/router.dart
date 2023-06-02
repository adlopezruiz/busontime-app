import 'package:bot_main_app/features/auth/login/screens/login_screen.dart';
import 'package:bot_main_app/features/auth/register/screens/register_screen.dart';
import 'package:bot_main_app/features/home/screens/home_screen.dart';
import 'package:bot_main_app/features/profile/screens/profile_page.dart';
import 'package:bot_main_app/features/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRouter setupRouter() {
  final routes = [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) =>
          const SplashPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) =>
          const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (BuildContext context, GoRouterState state) =>
          const RegisterScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) =>
          const HomeScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (BuildContext context, GoRouterState state) =>
          const ProfileScreen(),
    ),
  ];

  return GoRouter(
    initialLocation: '/',
    routes: routes,
  );
}
