import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'navbar_state.dart';

class NavbarCubit extends Cubit<NavbarState> {
  NavbarCubit() : super(NavbarState.initial());

  //Change navbar page and emit state
  void changePage(int newPage) {
    switch (newPage) {
      case 0:
        {
          emit(state.copyWith(pageStatus: PageStatus.homePage));
        }
        break;
      case 1:
        {
          emit(state.copyWith(pageStatus: PageStatus.mapPage));
        }
        break;
      case 2:
        {
          emit(state.copyWith(pageStatus: PageStatus.profilePage));
        }
        break;
    }
  }

  //Reset state on logout
  void resetNavbarState() {
    emit(state.copyWith(pageStatus: PageStatus.homePage));
  }
}
