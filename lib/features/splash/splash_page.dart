import 'package:bot_main_app/dependency_injection/injector.dart';
import 'package:bot_main_app/features/auth/bloc/auth_bloc.dart';
import 'package:bot_main_app/features/auth/register/bloc/register/register_cubit.dart';
import 'package:bot_main_app/repository/auth_repository.dart';
import 'package:bot_main_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/animated_logo.mp4')
      ..initialize().then(
        (_) => {
          setState(() {
            _controller.play();
          })
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    final router = GetIt.I<GoRouter>();
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.authStatus == AuthStatus.unauthenticated) {
          router.go('/onboarding');
        } else if (state.authStatus == AuthStatus.authenticated) {
          //Only redirecting home if current user has verified email and status is ok
          if (getIt<AuthRepository>().currentUser?.emailVerified ?? false) {
            router.go('/home');
          } else {
            //Changing state because its not verified yet.
            getIt<RegisterCubit>().setVerificationSentState();
            router.go('/emailVerification');
          }
        }
      },
      builder: (context, state) {
        Future.delayed(const Duration(seconds: 5), () {
          getIt<AuthBloc>().add(
            InitialCheckEvent(currentUser: getIt<AuthRepository>().currentUser),
          );
        });
        return Scaffold(
          backgroundColor: AppColors.primaryBlack,
          body: Stack(
            children: [
              Center(
                child: _controller.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      )
                    : Container(),
              ),
            ],
          ),
        );
      },
    );
  }
}
