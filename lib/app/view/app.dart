import 'package:bot_main_app/dependency_injection/injector.dart';
import 'package:bot_main_app/features/auth/bloc/auth_bloc.dart';
import 'package:bot_main_app/features/auth/login/bloc/login_cubit.dart';
import 'package:bot_main_app/features/auth/register/bloc/register_cubit.dart';
import 'package:bot_main_app/features/profile/bloc/profile_cubit.dart';
import 'package:bot_main_app/l10n/l10n.dart';
import 'package:bot_main_app/repository/auth/auth_repository.dart';
import 'package:bot_main_app/repository/auth/profile_repository.dart';
import 'package:bot_main_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final goRouter = GetIt.I<GoRouter>();
    //Mateapp with goRouter settings
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => getIt<AuthRepository>(),
        ),
        RepositoryProvider<ProfileRepository>(
          create: (context) => getIt<ProfileRepository>(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => getIt<AuthBloc>(),
          ),
          BlocProvider<LoginCubit>(
            create: (context) => getIt<LoginCubit>(),
          ),
          BlocProvider<RegisterCubit>(
            create: (context) => getIt<RegisterCubit>(),
          ),
          BlocProvider<ProfileCubit>(
            create: (context) => getIt<ProfileCubit>(),
          ),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Poppins',
            appBarTheme: const AppBarTheme(color: AppColors.primaryGreen),
            colorScheme: ColorScheme.fromSwatch(
              accentColor: AppColors.primaryGreen,
            ),
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: goRouter,
        ),
      ),
    );
  }
}
