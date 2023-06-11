import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bot_main_app/dependency_injection/injector.dart';
import 'package:bot_main_app/features/auth/bloc/auth_bloc.dart';
import 'package:bot_main_app/features/profile/bloc/profile_cubit.dart';
import 'package:bot_main_app/features/profile/widgets/custom_tile_widget.dart';
import 'package:bot_main_app/repository/auth_repository.dart';
import 'package:bot_main_app/ui/atoms/buttons.dart';
import 'package:bot_main_app/ui/atoms/spacers.dart';
import 'package:bot_main_app/ui/atoms/text_styles.dart';
import 'package:bot_main_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController =
      TextEditingController(text: getIt<ProfileCubit>().state.user.name);

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.profileStatus == ProfileStatus.loaded) {
            return Padding(
              padding: const EdgeInsets.only(top: 32),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //Userimage
                    GestureDetector(
                      onTap: () {
                        //TODO image picker
                      },
                      child: Stack(
                        children: [
                          SizedBox(
                            height: 150,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: FadeInImage.assetNetwork(
                                fit: BoxFit.cover,
                                placeholder:
                                    'assets/images/profile-animated.gif',
                                image: state.user.profileImage,
                              ),
                            ),
                          ),
                          const Positioned(
                            bottom: 0,
                            right: 0,
                            child: Icon(
                              Icons.camera_alt,
                              color: AppColors.primaryBlack,
                            ),
                          ),
                        ],
                      ),
                    ),
                    VerticalSpacer.regular(),
                    //Username
                    Text(
                      state.user.name,
                      style: AppTextStyles.title,
                    ),
                    //Email
                    Text(
                      state.user.email,
                      style: AppTextStyles.body,
                    ),
                    const Divider(
                      thickness: 1,
                    ),

                    //Settings container
                    SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryGrey,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              //Update profile
                              CustomTile(
                                labelText: 'Cambiar nombre',
                                assetIcon: 'assets/icons/user-icon.png',
                                callback: () {
                                  customFormDialog(
                                    context: context,
                                    inputLabel: 'Nuevo nombre',
                                    onErrorMessage:
                                        'Por favor introduce un nombre',
                                    validator: (String? value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'Por favor, introduce un nombre';
                                      }
                                      return null;
                                    },
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        //Update username
                                        getIt<ProfileCubit>().changeUserName(
                                          nameController.text,
                                        );
                                        Navigator.pop(context);
                                      }
                                    },
                                  ).show();
                                },
                              ),
                              VerticalSpacer.regular(),
                              //Change password
                              CustomTile(
                                labelText: 'Cambiar contraseña',
                                assetIcon: 'assets/icons/map-icon.png',
                                callback: () {
                                  getIt<AuthRepository>()
                                      .resetUserPassword(state.user.email);
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.infoReverse,
                                    animType: AnimType.bottomSlide,
                                    title: 'Info',
                                    btnOkOnPress: () {},
                                    btnCancelOnPress: () {},
                                    desc:
                                        'Hemos enviado un correo con las instrucciones para reiniciar su contraseña.',
                                  ).show();
                                },
                              ),
                              VerticalSpacer.regular(),
                              const CustomTile(
                                labelText: 'Información',
                                assetIcon: 'assets/icons/fav-icon.png',
                              ),
                              VerticalSpacer.regular(),
                              CustomTile(
                                labelText: 'Cerrar sesión',
                                assetIcon: 'assets/icons/calendar-icon.png',
                                callback: () {
                                  getIt<ProfileCubit>().logOut();
                                  context
                                      .read<AuthBloc>()
                                      .add(SignOutRequestedEvent());
                                },
                              ),
                            ],
                          ),
                        ),
                        // Center(
                        //   child: IconButton(
                        //     onPressed: () {

                        //     },
                        //     icon: const Icon(Icons.exit_to_app),
                        //   ),
                        // ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: Image.asset(
                'assets/images/profile-animated.gif',
                width: 150,
              ),
            );
          }
        },
      ),
    );
  }

  AwesomeDialog customFormDialog({
    required BuildContext context,
    required String inputLabel,
    required String onErrorMessage,
    required VoidCallback onPressed,
    required String? Function(String?) validator,
  }) {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.bottomSlide,
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
              ),
              validator: validator,
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 16,
              ),
              width: 150,
              height: 50,
              child: Buttons.primary(
                content: const Text(
                  'Enviar',
                  style: AppTextStyles.subtitle,
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
