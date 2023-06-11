import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bot_main_app/dependency_injection/injector.dart';
import 'package:bot_main_app/features/auth/widgets/custom_form_input._field.dart';
import 'package:bot_main_app/repository/auth_repository.dart';
import 'package:bot_main_app/ui/atoms/appbars.dart';
import 'package:bot_main_app/ui/atoms/buttons.dart';

import 'package:bot_main_app/ui/atoms/spacers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:validators/validators.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  //Needed instances
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  final _focusNode = FocusNode();

  //Email
  String email = '';

  //This function to the last screen
  void _submit() {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;

    if (form == null || !form.validate()) return;

    form.save();
    //Send email
    getIt<AuthRepository>().resetUserPassword(email);
    showSuccessAlert(context);
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars.onlyWithArrowBack(arrowRoute: '/login'),
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
                'Contraseña olvidada',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),

              VerticalSpacer.regular(),
              const Text(
                'Introduzca su correo a continuación\npara poder reiniciar su contraseña',
              ),
              VerticalSpacer.double(),
              //Name input
              CustomTextField(
                focusNode: _focusNode,
                onSaved: (String? value) => email = value ?? '',
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email requerido';
                  }
                  if (!isEmail(value.trim())) {
                    return 'El email no es válido';
                  }
                  return null;
                },
                labelText: 'Email',
                prefixIcon: Icons.email,
              ),
              VerticalSpacer.regular(),
              Buttons.primary(
                height: 70,
                width: MediaQuery.of(context).size.width,
                onPressed: _submit,
                content: const Text(
                  'Enviar',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showSuccessAlert(BuildContext context) {
  AwesomeDialog(
    context: context,
    animType: AnimType.leftSlide,
    headerAnimationLoop: false,
    dialogType: DialogType.success,
    showCloseIcon: true,
    title: 'Éxito',
    desc:
        '¡Hemos enviado un email con las isntrucciones para reiniciar tu contraseña! ',
    btnOkOnPress: () {
      getIt<GoRouter>().go('/login');
    },
    btnOkText: 'Aceptar',
    onDismissCallback: (type) {
      getIt<GoRouter>().go('/login');
    },
  ).show();
}
