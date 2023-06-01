import 'package:bot_main_app/features/profile/bloc/profile_cubit.dart';
import 'package:bot_main_app/utils/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state.profileStatus == ProfileStatus.error) {
            errorDialog(context, state.customError);
          }
        },
        builder: (context, state) {
          if (state.profileStatus == ProfileStatus.initial) {
            return Container();
          } else if (state.profileStatus == ProfileStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.profileStatus == ProfileStatus.error) {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/error.png',
                    height: 75,
                    width: 75,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 20),
                  const Text(
                    'Oooops!\nTry again',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            );
          }
          return Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FadeInImage.assetNetwork(
                  placeholder: 'assets/images/loading.gif',
                  image: state.user.profileImage,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '- id: ${state.user.id}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '- name: ${state.user.name}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '- email: ${state.user.email}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '- point: ${state.user.point}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '- rank: ${state.user.rank}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
