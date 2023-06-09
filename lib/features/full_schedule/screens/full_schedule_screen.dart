import 'package:bot_main_app/dependency_injection/injector.dart';
import 'package:bot_main_app/features/full_schedule/cubit/full_schedule_cubit.dart';
import 'package:bot_main_app/ui/atoms/appbars.dart';
import 'package:bot_main_app/ui/atoms/spacers.dart';
import 'package:bot_main_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toggle_switch/toggle_switch.dart';

class FullScheduleScreen extends StatelessWidget {
  const FullScheduleScreen({super.key});

  //Force screen to be landscape
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars.arrowBackJustPopsOne(),
      body: BlocBuilder<FullScheduleCubit, FullScheduleState>(
        builder: (context, state) {
          if (state.fullScheduleStatus == FullScheduleStatus.loading) {
            return Center(
              child: Image.asset(
                'assets/images/calendar.gif',
                height: 150,
              ),
            );
          }
          if (state.direction == 'toMartos') {
            //ToJaen schedule
            return LoadSchedule(
              direction: 'toMartos',
              initialSwitch: state.direction == 'toMartos' ? 0 : 1,
            );
          } else {
            //To Jaen schedule
            return LoadSchedule(
              direction: 'toJaen',
              initialSwitch: state.direction == 'toMartos' ? 0 : 1,
            );
          }
        },
      ),
    );
  }
}

class LoadSchedule extends StatelessWidget {
  const LoadSchedule({
    super.key,
    required this.direction,
    required this.initialSwitch,
  });

  final String direction;
  final int initialSwitch;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ToggleSwitch(
            minHeight: 50,
            minWidth: MediaQuery.of(context).size.width / 2,
            cornerRadius: 20,
            activeFgColor: Colors.white,
            inactiveBgColor: AppColors.primaryGrey,
            inactiveFgColor: Colors.white,
            totalSwitches: 2,
            initialLabelIndex: initialSwitch,
            icons: const [Icons.output, Icons.input],
            iconSize: 30,
            labels: const ['Jaen-Martos', 'Martos-Jaén'],
            activeBgColors: const [
              [Colors.black45, Colors.black26],
              [Colors.green, AppColors.primaryGreen]
            ],
            onToggle: (index) {
              //Dependency injection OP
              getIt<FullScheduleCubit>().changeScheduleDirection(index ?? 0);
            },
          ),
          VerticalSpacer.double(),
          InteractiveViewer(
            child: Center(
              child: Image.asset(
                'assets/images/horario_$direction.PNG',
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
