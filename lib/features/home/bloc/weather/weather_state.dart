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
    this.imageAsset,
  });

  factory WeatherState.initial() {
    return WeatherState(
      status: WeatherStatus.initial,
      weather: Weather.initial(),
      imageAsset: 'sunny.jpeg',
    );
  }
  final WeatherStatus status;
  final Weather weather;
  final String? imageAsset;

  WeatherState copyWith({
    WeatherStatus? status,
    Weather? weather,
    String? imageAsset,
  }) {
    return WeatherState(
      status: status ?? this.status,
      weather: weather ?? this.weather,
      imageAsset: imageAsset,
    );
  }

  @override
  String toString() =>
      'WeatherState(status: $status, weather: $weather, imageAsset: $imageAsset)';

  @override
  List<Object> get props => [status, weather, imageAsset ?? 'sunny.jpeg'];
}
