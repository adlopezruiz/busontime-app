import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bot_main_app/dependency_injection/injector.dart';
import 'package:bot_main_app/features/auth/login/bloc/login_cubit.dart';
import 'package:bot_main_app/features/auth/widgets/custom_form_input._field.dart';
import 'package:bot_main_app/l10n/l10n.dart';
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

    context.read<LoginCubit>().loginWithEmailAndPassword(
          email: _email!,
          password: _password!,
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
                      Text(l10n.alreadyMemberLoginText),
                      VerticalSpacer.regular(),
                      //Email textfield
                      CustomTextField(
                        focusNode: _focusNode,
                        onSaved: (String? value) {
                          _email = value;
                        },
                        validator: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.requiredEmailFormError;
                          }
                          if (!isEmail(value.trim())) {
                            return l10n.emailNotValidFormError;
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
                            return l10n.passwordRequired;
                          }
                          if (value.trim().length < 6) {
                            return l10n.passwordRequired;
                          }
                          return null;
                        },
                        labelText: l10n.passwordLabel,
                        prefixIcon: Icons.lock,
                      ),
                      VerticalSpacer.regular(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          NavigationText(
                            text: l10n.forgotPasswordWithQuestionMarks,
                            route: '/forgotPW',
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Expanded(
                            child: Divider(
                              color: AppColors.primaryGrey,
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(l10n.orLabel),
                          ),
                          const Expanded(
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
                                      Text(
                                        l10n.loginWithGoogleLabel,
                                        style: const TextStyle(
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
                                : () => showAppleInfoAlert(context),
                        content:
                            state.loginStatus == LoginStatus.submittingApple
                                ? const CircularProgressIndicator(
                                    color: AppColors.primaryGreen,
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        l10n.loginWithAppleLabel,
                                        style: const TextStyle(
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(l10n.needAndAccount),
                          NavigationText(
                            text: l10n.registerHere,
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

void showAppleInfoAlert(BuildContext context) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.infoReverse,
    animType: AnimType.bottomSlide,
    title: 'INFO',
    reverseBtnOrder: true,
    btnOkOnPress: () {},
    desc: context.l10n.serviceUnavailable,
  ).show();
}
