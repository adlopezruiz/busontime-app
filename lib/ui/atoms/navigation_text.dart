import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class NavigationText extends StatelessWidget {
  const NavigationText({super.key, required this.text, required this.route});

  final String text;
  final String route;

  @override
  Widget build(BuildContext context) {
    //Injecting dependency
    final router = GetIt.I<GoRouter>();

    return GestureDetector(
      onTap: () => router.go(route),
      child: Text(
        text,
        style: const TextStyle(
          color: Color.fromRGBO(66, 155, 103, 1),
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
