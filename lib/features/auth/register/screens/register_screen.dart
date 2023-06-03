import 'package:bot_main_app/features/auth/register/bloc/register_cubit.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  final _passwordController = TextEditingController();
  String? _name;
  String? _email;
  String? _password;

  void _submit() {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;

    if (form == null || !form.validate()) return;

    form.save();

    print('name: $_name, email: $_email, password: $_password');

    context.read<RegisterCubit>().register(
          name: _name!,
          email: _email!,
          password: _password!,
        );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: BlocConsumer<RegisterCubit, RegisterState>(
            listener: (context, state) {
              if (state.registerStatus == RegisterStatus.error) {
                errorDialog(context, state.error);
              }
            },
            builder: (context, state) {
              return Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: _autovalidateMode,
                      child: ListView(
                        reverse: true,
                        shrinkWrap: true,
                        children: [
                          Image.asset(
                            'assets/images/flutter_logo.png',
                            width: 250,
                            height: 250,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              filled: true,
                              labelText: 'Name',
                              prefix: Icon(Icons.account_box),
                            ),
                            validator: (String? value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Name required';
                              }
                              if (value.trim().length < 2) {
                                return 'Name must be at least 2 characters';
                              }
                              return null;
                            },
                            onSaved: (String? newValue) {
                              _name = newValue;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              filled: true,
                              labelText: 'Email',
                              prefix: Icon(Icons.email),
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
                            onSaved: (String? newValue) {
                              _email = newValue;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              filled: true,
                              labelText: 'Password',
                              prefix: Icon(Icons.lock),
                            ),
                            validator: (String? value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Password required';
                              }
                              if (value.trim().length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                            onSaved: (String? newValue) {
                              _password = newValue;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            obscureText: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              filled: true,
                              labelText: 'Confirm password',
                              prefix: Icon(Icons.lock),
                            ),
                            validator: (String? value) {
                              if (_passwordController.text != value) {
                                return 'Passwords not match';
                              }
                              return null;
                            },
                          ),
                          ElevatedButton(
                            onPressed: state.registerStatus ==
                                    RegisterStatus.submitting
                                ? null
                                : _submit,
                            style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            child: state.registerStatus ==
                                    RegisterStatus.submitting
                                ? const CircularProgressIndicator()
                                : const Text('Sign Up'),
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: (state.registerStatus ==
                                    RegisterStatus.submitting
                                ? null
                                : () {
                                    Navigator.pop(context);
                                  }),
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            child: const Text('Already a member? Sign in!'),
                          ),
                        ].reversed.toList(),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
