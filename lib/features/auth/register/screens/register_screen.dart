import 'dart:math';

import 'package:bot_main_app/dependency_injection/injector.dart';
import 'package:bot_main_app/features/auth/register/bloc/register/register_cubit.dart';
import 'package:bot_main_app/features/auth/widgets/custom_form_input._field.dart';
import 'package:bot_main_app/l10n/l10n.dart';
import 'package:bot_main_app/ui/atoms/appbars.dart';
import 'package:bot_main_app/ui/atoms/buttons.dart';
import 'package:bot_main_app/ui/atoms/navigation_text.dart';
import 'package:bot_main_app/ui/atoms/spacers.dart';
import 'package:bot_main_app/utils/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validators/validators.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //Needed instances
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  final _passwordController = TextEditingController();
  final _focusNode = FocusNode();
  final _focusNode2 = FocusNode();
  final _focusNode3 = FocusNode();
  final _focusNode4 = FocusNode();
  //User data
  late String? _name;
  late String? _email;
  late String? _password;

  //This function to the last screen
  void _submit() {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;

    if (form == null || !form.validate()) return;

    form.save();
    //Register user now with staged data.
    getIt<RegisterCubit>()
      ..stageUserData(
        name: _name!,
        email: _email!,
        password: _password!,
      )
      ..register();
  }

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      setState(() {});
    });
    _focusNode2.addListener(() {
      setState(() {});
    });
    _focusNode3.addListener(() {
      setState(() {});
    });
    _focusNode4.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state.registerStatus == RegisterStatus.error) {
          errorDialog(context, state.error);
        }
      },
      builder: (context, state) {
        return Scaffold(
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
                  Text(
                    l10n.register,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),

                  VerticalSpacer.regular(),
                  Text(
                    l10n.needSomeData,
                  ),
                  VerticalSpacer.double(),
                  //Name input
                  CustomTextField(
                    textCapitalization: TextCapitalization.sentences,
                    focusNode: _focusNode4,
                    onSaved: (String? value) => _name = value,
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.nameRequired;
                      }
                      return null;
                    },
                    labelText: l10n.nameLabel,
                    prefixIcon: Icons.person,
                  ),
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
                    controller: _passwordController,
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
                        return l10n.passwordMustBe6Long;
                      }
                      return null;
                    },
                    labelText: l10n.passwordLabel,
                    prefixIcon: Icons.lock,
                  ),

                  VerticalSpacer.regular(),
                  CustomTextField(
                    obscuredText: true,
                    focusNode: _focusNode3,
                    onSaved: (String? value) {
                      _password = value;
                    },
                    validator: (String? value) {
                      if (_passwordController.text != value) {
                        return l10n.passwordNotMatch;
                      }
                      return null;
                    },
                    labelText: l10n.repeatPassword,
                    prefixIcon: Icons.lock,
                  ),
                  VerticalSpacer.regular(),
                  Buttons.primary(
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    onPressed: state.registerStatus == RegisterStatus.submitting
                        ? null
                        : _submit,
                    content: state.registerStatus == RegisterStatus.submitting
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Icon(
                            Icons.keyboard_arrow_right,
                            size: 50,
                          ),
                  ),
                  VerticalSpacer.double(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(l10n.youHaveAccountQuestion),
                      NavigationText(
                        text: l10n.loginHere,
                        route: '/login',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
