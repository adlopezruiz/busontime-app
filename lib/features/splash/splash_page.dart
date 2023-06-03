import 'package:bot_main_app/dependency_injection/injector.dart';
import 'package:bot_main_app/features/auth/bloc/auth_bloc.dart';
import 'package:bot_main_app/repository/auth/auth_repository.dart';
import 'package:bot_main_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GetIt.I<GoRouter>();
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.authStatus == AuthStatus.unauthenticated) {
          router.go('/onboarding');
        } else if (state.authStatus == AuthStatus.authenticated) {
          router.go('/home');
        }
      },
      builder: (context, state) {
        Future.delayed(const Duration(seconds: 5), () {
          getIt<AuthBloc>().add(
            InitialCheckEvent(currentUser: getIt<AuthRepository>().currentUser),
          );
        });
        return Scaffold(
          backgroundColor: AppColors.primaryGrey,
          body: Center(
            child: Lottie.asset(
              'assets/images/logo_animation.json',
              fit: BoxFit.fill,
            ),
          ),
        );
      },
    );
  }
}
