import 'package:bot_main_app/features/auth/bloc/auth_bloc.dart';
import 'package:bot_main_app/features/auth/login/bloc/login_cubit.dart';
import 'package:bot_main_app/features/auth/register/bloc/image_picker/image_picker_bloc.dart';
import 'package:bot_main_app/features/auth/register/bloc/register/register_cubit.dart';
import 'package:bot_main_app/features/favorites/cubit/favorites_cubit.dart';
import 'package:bot_main_app/features/full_schedule/cubit/full_schedule_cubit.dart';
import 'package:bot_main_app/features/home/bloc/weather/weather_bloc.dart';
import 'package:bot_main_app/features/map/blocs/map_bloc/map_bloc.dart';
import 'package:bot_main_app/features/navbar/bloc/navbar_cubit/navbar_cubit.dart';
import 'package:bot_main_app/features/profile/bloc/profile_cubit.dart';
import 'package:bot_main_app/repository/auth_repository.dart';
import 'package:bot_main_app/repository/line_repository.dart';
import 'package:bot_main_app/repository/polyline_repository.dart';
import 'package:bot_main_app/repository/stop_repository.dart';
import 'package:bot_main_app/repository/storage_repository.dart';
import 'package:bot_main_app/repository/user_repository.dart';
import 'package:bot_main_app/repository/weather_repository.dart';

import 'package:bot_main_app/utils/router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

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
    ..registerLazySingleton<LineRepository>(
      LineRepository.new,
    )
    ..registerLazySingleton<StopRepository>(
      StopRepository.new,
    )
    ..registerLazySingleton<UserRepository>(
      () => UserRepository(
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
        profileRepository: getIt<UserRepository>(),
      ),
    )
    ..registerLazySingleton<Geolocator>(Geolocator.new)
    ..registerLazySingleton<MapBloc>(MapBloc.new)
    ..registerLazySingleton<NavbarCubit>(NavbarCubit.new)
    ..registerLazySingleton(ImagePickerBloc.new)
    ..registerLazySingleton(() => FirebaseStorage.instance)
    ..registerLazySingleton(StorageRepository.new)
    ..registerLazySingleton<ImagePicker>(ImagePicker.new)
    ..registerLazySingleton<PolilyneRepository>(PolilyneRepository.new)
    ..registerLazySingleton<WeatherRepository>(WeatherRepository.new)
    ..registerLazySingleton<WeatherBloc>(
      () => WeatherBloc(
        weatherRepository: getIt<WeatherRepository>(),
      ),
    )
    ..registerLazySingleton<FullScheduleCubit>(FullScheduleCubit.new)
    ..registerLazySingleton<FavoritesCubit>(FavoritesCubit.new);
}
