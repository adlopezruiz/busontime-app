import 'package:bot_main_app/features/favorites/cubit/favorites_cubit.dart';
import 'package:bot_main_app/ui/atoms/appbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars.arrowBackJustPopsOne(),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          return Container();
        },
      ),
    );
  }
}
