import 'package:bot_main_app/dependency_injection/injector.dart';
import 'package:bot_main_app/features/auth/login/bloc/login_cubit.dart';
import 'package:bot_main_app/features/auth/widgets/custom_form_input._field.dart';
import 'package:bot_main_app/ui/atoms/appbars.dart';
import 'package:bot_main_app/ui/atoms/buttons.dart';
import 'package:bot_main_app/ui/atoms/navigation_text.dart';
import 'package:bot_main_app/ui/atoms/spacers.dart';
import 'package:bot_main_app/utils/constants.dart';
import 'package:bot_main_app/utils/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:validators/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  final FocusNode _focusNode = FocusNode();
  final FocusNode _focusNode2 = FocusNode();

  String? _email;
  String? _password;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
    _focusNode2.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _focusNode2.dispose();
    super.dispose();
  }

  //Submit function
  void _submit() {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;

    if (form == null || !form.validate()) return;

    form.save();
    context
        .read<LoginCubit>()
        .loginWithEmailAndPassword(email: _email!, password: _password!);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.loginStatus == LoginStatus.error) {
            errorDialog(context, state.error);
          }
        },
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              appBar: AppBars.onlyWithArrowBack(arrowRoute: '/onboarding'),
              body: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Form(
                  key: _formKey,
                  autovalidateMode: _autovalidateMode,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      const Text(
                        'Login',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),

                      VerticalSpacer.regular(),
                      const Text(
                          'Si ya eres miembro. Accede a tu panel de usuario\npara no perderte en tu destino.'),
                      VerticalSpacer.regular(),
                      //Email textfield
                      CustomTextField(
                        focusNode: _focusNode,
                        onSaved: (String? value) {
                          _email = value;
                        },
                        validator: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email required';
                          }
                          if (!isEmail(value.trim())) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                        labelText: 'Email',
                        prefixIcon: Icons.email,
                      ),
                      VerticalSpacer.regular(),
                      CustomTextField(
                        obscuredText: true,
                        focusNode: _focusNode2,
                        onSaved: (String? value) {
                          _password = value;
                        },
                        validator: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Password required';
                          }
                          if (value.trim().length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                        labelText: 'Password',
                        prefixIcon: Icons.lock,
                      ),
                      VerticalSpacer.regular(),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          NavigationText(
                            text: '¿Contraseña olvidada?',
                            route: '/forgot_pw',
                          ),
                        ],
                      ),
                      VerticalSpacer.regular(),
                      Buttons.primary(
                        height: 70,
                        width: MediaQuery.of(context).size.width,
                        onPressed:
                            state.loginStatus == LoginStatus.submittingEmail
                                ? null
                                : _submit,
                        content:
                            state.loginStatus == LoginStatus.submittingEmail
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    'Login',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                      ),
                      VerticalSpacer.double(),
                      //OR divider
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Divider(
                              color: AppColors.primaryGrey,
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text('OR'),
                          ),
                          Expanded(
                            child: Divider(
                              color: AppColors.primaryGrey,
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      VerticalSpacer.double(),
                      //Google button
                      Buttons.terciary(
                        height: 70,
                        width: MediaQuery.of(context).size.width,
                        onPressed:
                            state.loginStatus == LoginStatus.submittingGoogle
                                ? null
                                : getIt<LoginCubit>().loginWithGoogle,
                        content:
                            state.loginStatus == LoginStatus.submittingGoogle
                                ? const CircularProgressIndicator(
                                    color: AppColors.primaryGreen,
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Login with Google',
                                        style: TextStyle(
                                          color: AppColors.primaryBlack,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      HorizontalSpacer.regular(),
                                      SizedBox(
                                        height: 50,
                                        child: SvgPicture.asset(
                                          'assets/icons/google.svg',
                                          semanticsLabel: 'Acme Logo',
                                        ),
                                      ),
                                    ],
                                  ),
                      ),
                      VerticalSpacer.regular(),
                      //Apple button
                      Buttons.terciary(
                        height: 70,
                        width: MediaQuery.of(context).size.width,
                        onPressed:
                            state.loginStatus == LoginStatus.submittingApple
                                ? null
                                : () {},
                        content:
                            state.loginStatus == LoginStatus.submittingApple
                                ? const CircularProgressIndicator(
                                    color: AppColors.primaryGreen,
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Login with Apple',
                                        style: TextStyle(
                                          color: AppColors.primaryBlack,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      HorizontalSpacer.regular(),
                                      SizedBox(
                                        child: SvgPicture.asset(
                                          'assets/icons/apple.svg',
                                          semanticsLabel: 'Acme Logo',
                                        ),
                                      ),
                                    ],
                                  ),
                      ),
                      VerticalSpacer.regular(),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('¿Necesitas una cuenta? '),
                          NavigationText(
                            text: 'Regístrate aquí',
                            route: '/register',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
