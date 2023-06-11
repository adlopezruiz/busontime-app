import 'package:bot_main_app/dependency_injection/injector.dart';
import 'package:bot_main_app/features/auth/register/bloc/register/register_cubit.dart';
import 'package:bot_main_app/l10n/l10n.dart';
import 'package:bot_main_app/repository/auth_repository.dart';
import 'package:bot_main_app/ui/atoms/appbars.dart';
import 'package:bot_main_app/ui/atoms/buttons.dart';
import 'package:bot_main_app/ui/atoms/spacers.dart';
import 'package:bot_main_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        if (state.registerStatus == RegisterStatus.verificationSent) {
          //Checking for verifying your email
          return Scaffold(
            appBar: AppBars.onlyWithArrowBack(arrowRoute: '/register'),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Verifying icon
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      color: AppColors.secondaryGrey,
                    ),
                    width: 100,
                    height: 100,
                    child: const Icon(
                      Icons.verified_user_outlined,
                      color: AppColors.primaryGreen,
                      size: 58,
                    ),
                  ),
                  VerticalSpacer.regular(),
                  //Verifing title
                  Text(
                    l10n.emailVerification,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  VerticalSpacer.regular(),
                  Text(
                    l10n.checkSpam,
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  VerticalSpacer.double(),
                  //Verifying circularprogress
                  const CircularProgressIndicator(
                    color: AppColors.primaryGreen,
                  ),
                  VerticalSpacer.double(),
                  //Resend mail button
                  SizedBox(
                    child: Buttons.primary(
                      height: 50,
                      width: 200,
                      content: Text(
                        l10n.resendEmail,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () => getIt<AuthRepository>()
                          .currentUser!
                          .sendEmailVerification(),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          //Congratulations! And redirect
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Animated Icon
                  const Icon(
                    Icons.check_circle,
                    size: 100,
                    color: AppColors.primaryGreen,
                  ),
                  //Congrats
                  Text(
                    l10n.congratulations,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(
                Icons.navigate_next,
                size: 52,
                color: Colors.white,
              ),
              onPressed: () => getIt<GoRouter>().go('/userImage'),
            ),
          );
        }
      },
    );
  }
}
