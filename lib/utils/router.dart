import 'package:bot_main_app/features/auth/login/screens/login_screen.dart';
import 'package:bot_main_app/features/auth/register/screens/image_picker_screen.dart';
import 'package:bot_main_app/features/auth/register/screens/name_screen.dart';
import 'package:bot_main_app/features/auth/register/screens/verify_email_screen.dart';
import 'package:bot_main_app/features/navbar/screens/navigation_screen.dart';
import 'package:bot_main_app/features/onboarding/onboarding_screen.dart';
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
      path: '/onboarding',
      builder: (BuildContext context, GoRouterState state) =>
          const OnboardingScreen(),
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
          const NavigationScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (BuildContext context, GoRouterState state) =>
          const ProfileScreen(),
    ),
    GoRoute(
      path: '/userImage',
      builder: (BuildContext context, GoRouterState state) =>
          const UserImagePicker(),
    ),
    GoRoute(
      path: '/emailVerification',
      builder: (BuildContext context, GoRouterState state) =>
          const VerifyEmailScreen(),
    ),
  ];

  return GoRouter(
    initialLocation: '/',
    routes: routes,
  );
}
