import 'package:bot_main_app/dependency_injection/injector.dart';
import 'package:bot_main_app/features/auth/register/bloc/register/register_cubit.dart';
import 'package:bot_main_app/ui/atoms/appbars.dart';
import 'package:bot_main_app/ui/atoms/buttons.dart';
import 'package:bot_main_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        if (state.registerStatus == RegisterStatus.verificationSent) {
          //Checking for verifying your email
          return Scaffold(
            appBar: AppBars.onlyWithArrowBack(arrowRoute: 'register'),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Verifying icon
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.primaryGrey,
                    ),
                    width: 100,
                    height: 100,
                    child: const Icon(
                      Icons.verified_user_outlined,
                      color: AppColors.primaryGreen,
                      size: 58,
                    ),
                  ),
                  //Verifing title
                  const Text(
                    'Verificación de email',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    '''
                  Hemos enviado un email de verificación al correo indicado.\n
                  Por favor revise su bandeja de entrada o spam.''',
                    style: TextStyle(fontSize: 14),
                  ),
                  //Verifying circularprogress
                  const CircularProgressIndicator(
                    color: AppColors.primaryGreen,
                  ),
                  //Resend mail button
                  Buttons.primary(
                    content: const Text(
                      'Reenviar email',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          //Congratulations! And redirect
          return Scaffold(
            appBar: AppBars.onlyWithArrowBack(arrowRoute: '/register'),
            body: const Center(
              child: Text(
                'Enhorabuena hemos verificado tu email!',
              ),
            ),
            floatingActionButton: IconButton(
              icon: const Icon(
                Icons.arrow_right_alt_outlined,
                size: 32,
                color: AppColors.primaryGreen,
              ),
              onPressed: () => getIt<GoRouter>().go('/userImage'),
            ),
          );
        }
      },
    );
  }
}
