part of 'weather_bloc.dart';

enum WeatherStatus {
  initial,
  loading,
  loaded,
  error,
}

class WeatherState extends Equatable {
  const WeatherState({
    required this.status,
    required this.weather,
    required this.error,
    this.imageAsset,
  });

  factory WeatherState.initial() {
    return WeatherState(
      status: WeatherStatus.initial,
      weather: Weather.initial(),
      error: const CustomError(),
      imageAsset: 'sunny.jpeg',
    );
  }
  final WeatherStatus status;
  final Weather weather;
  final CustomError error;
  final String? imageAsset;

  WeatherState copyWith({
    WeatherStatus? status,
    Weather? weather,
    CustomError? error,
    String? imageAsset,
  }) {
    return WeatherState(
      status: status ?? this.status,
      weather: weather ?? this.weather,
      error: error ?? this.error,
      imageAsset: imageAsset,
    );
  }

  @override
  String toString() =>
      'WeatherState(status: $status, weather: $weather, error: $error, imageAsset: $imageAsset)';

  @override
  List<Object> get props =>
      [status, weather, error, imageAsset ?? 'sunny.jpeg'];
}
