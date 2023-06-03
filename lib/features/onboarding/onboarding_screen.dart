import 'package:bot_main_app/ui/atoms/buttons.dart';
import 'package:bot_main_app/ui/atoms/navigation_text.dart';
import 'package:bot_main_app/ui/atoms/spacers.dart';
import 'package:bot_main_app/utils/constants.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bus_images/busia4.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //Landing text
                const Text(
                  'No te pierdas.\nNunca llegues tarde.',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryGrey,
                  ),
                ),
                VerticalSpacer.double(),
                //Login button
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: Buttons.primary(
                    onPressed: () {},
                    text: const Text(
                      'Log In',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                VerticalSpacer.regular(),
                //Register text with link
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¿Necesitas una cuenta? ',
                      style: TextStyle(
                        color: AppColors.secondaryGrey,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    NavigationText(
                      text: 'Registrarse',
                      route: '/register',
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
