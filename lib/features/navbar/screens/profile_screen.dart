import 'package:bot_main_app/features/auth/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(
        onPressed: () {
          context.read<AuthBloc>().add(SignOutRequestedEvent());
        },
        icon: const Icon(Icons.exit_to_app),
      ),
    );
  }
}
