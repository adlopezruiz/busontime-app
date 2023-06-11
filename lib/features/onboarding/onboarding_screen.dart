import 'package:bot_main_app/dependency_injection/injector.dart';
import 'package:bot_main_app/l10n/l10n.dart';
import 'package:bot_main_app/ui/atoms/buttons.dart';
import 'package:bot_main_app/ui/atoms/navigation_text.dart';
import 'package:bot_main_app/ui/atoms/spacers.dart';
import 'package:bot_main_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
                Text(
                  l10n.dontGetLost,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryGrey,
                  ),
                ),
                VerticalSpacer.double(),
                //Login button
                Buttons.primary(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  onPressed: () => getIt<GoRouter>().push('/login'),
                  content: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                VerticalSpacer.regular(),
                //Register text with link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.needAndAccount,
                      style: const TextStyle(
                        color: AppColors.secondaryGrey,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    NavigationText(
                      text: l10n.register,
                      route: '/register',
                    )
                  ],
                ),
                VerticalSpacer.double(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
