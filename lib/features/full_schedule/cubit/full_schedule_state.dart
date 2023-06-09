part of 'full_schedule_cubit.dart';

enum FullScheduleStatus { initial, loading, loaded }

class FullScheduleState extends Equatable {
  const FullScheduleState({
    required this.fullScheduleStatus,
    required this.direction,
  });

  factory FullScheduleState.initial() {
    return const FullScheduleState(
      fullScheduleStatus: FullScheduleStatus.initial,
      direction: 'toMartos',
    );
  }

  final FullScheduleStatus fullScheduleStatus;
  final String direction;

  FullScheduleState copyWith({
    FullScheduleStatus? fullScheduleStatus,
    Map<String, dynamic>? schedule,
    String? direction,
  }) {
    return FullScheduleState(
      fullScheduleStatus: fullScheduleStatus ?? this.fullScheduleStatus,
      direction: direction ?? this.direction,
    );
  }

  @override
  String toString() =>
      'FullScheduleState(fullScheduleStatus: $fullScheduleStatus, direction: $direction)';

  @override
  List<Object> get props => [fullScheduleStatus, direction];
}
