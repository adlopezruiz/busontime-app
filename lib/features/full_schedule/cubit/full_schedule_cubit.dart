import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'full_schedule_state.dart';

class FullScheduleCubit extends Cubit<FullScheduleState> {
  FullScheduleCubit() : super(FullScheduleState.initial()) {
    //Fake loading screen XD
    state.copyWith(fullScheduleStatus: FullScheduleStatus.loading);
    Future.delayed(
      const Duration(seconds: 3),
      () => emit(
        state.copyWith(fullScheduleStatus: FullScheduleStatus.loaded),
      ),
    );
  }

  //Change state of day of week type
  void changeScheduleDirection(int newDirection) {
    emit(state.copyWith(direction: newDirection == 0 ? 'toMartos' : 'toJaen'));
  }
}
