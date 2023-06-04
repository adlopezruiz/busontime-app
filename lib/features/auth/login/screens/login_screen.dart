import 'package:bot_main_app/dependency_injection/injector.dart';
import 'package:bot_main_app/features/auth/login/bloc/login_cubit.dart';
import 'package:bot_main_app/ui/atoms/spacers.dart';
import 'package:bot_main_app/utils/constants.dart';
import 'package:bot_main_app/utils/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
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

  String? _email;
  String? _password;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

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
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: _autovalidateMode,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Image.asset(
                          'assets/images/logo_final.png',
                          width: 250,
                          height: 250,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          cursorColor: AppColors.primaryGreen,
                          focusNode: _focusNode,
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          decoration: InputDecoration(
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.primaryGreen,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            filled: true,
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              color: _focusNode.hasFocus
                                  ? AppColors.primaryGreen
                                  : null,
                            ),
                            prefixIcon: Icon(
                              Icons.email,
                              color: _focusNode.hasFocus
                                  ? AppColors.primaryGreen
                                  : null,
                            ),
                          ),
                          validator: (String? value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Email required';
                            }
                            if (!isEmail(value.trim())) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                          onSaved: (String? value) {
                            _email = value;
                          },
                        ),
                        VerticalSpacer.regular(),
                        TextFormField(
                          cursorColor: AppColors.primaryGreen,
                          focusNode: _focusNode,
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock),
                          ),
                          validator: (String? value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Password required';
                            }
                            if (value.trim().length < 6) {
                              return 'Password must be at least 6 characters long';
                            }
                            return null;
                          },
                          onSaved: (String? value) {
                            _password = value;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: state.loginStatus == LoginStatus.submitting
                              ? null
                              : _submit,
                          style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          child: state.loginStatus == LoginStatus.submitting
                              ? const CircularProgressIndicator()
                              : const Text('Login'),
                        ),
                        ElevatedButton(
                          onPressed: state.loginStatus == LoginStatus.submitting
                              ? null
                              : getIt<LoginCubit>().loginWithGoogle,
                          style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          child: state.loginStatus == LoginStatus.submitting
                              ? const CircularProgressIndicator()
                              : SvgPicture.asset(
                                  'assets/icons/google.svg',
                                  semanticsLabel: 'Acme Logo',
                                ),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: state.loginStatus == LoginStatus.submitting
                              ? null
                              : () => getIt<GoRouter>().push('/register'),
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(
                              fontSize: 20,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          child: const Text('Not a member? Register!'),
                        ),
                      ],
                    ),
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
