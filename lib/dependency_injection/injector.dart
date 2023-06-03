import 'package:bot_main_app/features/auth/bloc/auth_bloc.dart';
import 'package:bot_main_app/features/auth/login/bloc/login_cubit.dart';
import 'package:bot_main_app/features/auth/register/bloc/register_cubit.dart';
import 'package:bot_main_app/features/profile/bloc/profile_cubit.dart';
import 'package:bot_main_app/repository/auth/auth_repository.dart';
import 'package:bot_main_app/repository/auth/profile_repository.dart';
import 'package:bot_main_app/utils/router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

GetIt getIt = GetIt.instance;

void setupDI() {
  getIt
    ..registerSingleton<GoRouter>(
      setupRouter(),
    )
    ..registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance)
    ..registerSingleton<FirebaseAuth>(FirebaseAuth.instance)
    ..registerSingleton<GoogleSignIn>(GoogleSignIn())
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepository(
        firebaseFirestore: getIt<FirebaseFirestore>(),
        firebaseAuth: getIt<FirebaseAuth>(),
        googleSignIn: getIt<GoogleSignIn>(),
      ),
    )
    ..registerLazySingleton<ProfileRepository>(
      () => ProfileRepository(
        firebaseFirestore: getIt<FirebaseFirestore>(),
      ),
    )
    ..registerSingleton<AuthBloc>(
      AuthBloc(
        authRepository: getIt<AuthRepository>(),
      ),
    )
    ..registerSingleton<LoginCubit>(
      LoginCubit(
        authRepository: getIt<AuthRepository>(),
      ),
    )
    ..registerSingleton<RegisterCubit>(
      RegisterCubit(
        authRepository: getIt<AuthRepository>(),
      ),
    )
    ..registerLazySingleton<ProfileCubit>(
      () => ProfileCubit(
        profileRepository: getIt<ProfileRepository>(),
      ),
    );
}
