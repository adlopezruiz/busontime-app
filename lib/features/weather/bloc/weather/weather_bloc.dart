import 'dart:async';

import 'package:bot_main_app/models/custom_error.dart';
import 'package:bot_main_app/models/weather.dart';
import 'package:bot_main_app/repository/weather_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc({required this.weatherRepository})
      : super(WeatherState.initial()) {
    on<FetchWeatherEvent>(_fetchWeather);
  }
  final WeatherRepository weatherRepository;

  FutureOr<void> _fetchWeather(
    FetchWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    emit(state.copyWith(status: WeatherStatus.loading));

    try {
      final weather = await weatherRepository.fetchWeather(event.city);
      emit(state.copyWith(status: WeatherStatus.loaded, weather: weather));
    } on CustomError catch (e) {
      emit(state.copyWith(status: WeatherStatus.error, error: e));
    }
  }
}
