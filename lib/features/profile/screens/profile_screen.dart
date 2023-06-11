import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bot_main_app/dependency_injection/injector.dart';
import 'package:bot_main_app/features/auth/bloc/auth_bloc.dart';
import 'package:bot_main_app/features/profile/bloc/profile_cubit.dart';
import 'package:bot_main_app/features/profile/widgets/custom_tile_widget.dart';
import 'package:bot_main_app/l10n/l10n.dart';
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
    final l10n = context.l10n;
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
                    SizedBox(
                      height: 150,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: FadeInImage.assetNetwork(
                          fit: BoxFit.cover,
                          placeholder: 'assets/images/loading.gif',
                          image: state.user.profileImage,
                        ),
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
                                labelText: l10n.changeName,
                                assetIcon: 'assets/icons/user-green.png',
                                callback: () {
                                  customFormDialog(
                                    context: context,
                                    inputLabel: l10n.newName,
                                    onErrorMessage: l10n.nameRequired,
                                    validator: (String? value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return l10n.nameRequired;
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
                                labelText: l10n.changePassword,
                                assetIcon: 'assets/icons/password-icon.png',
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
                                    desc: l10n.resetEmailSent,
                                  ).show();
                                },
                              ),
                              VerticalSpacer.regular(),
                              CustomTile(
                                labelText: l10n.infoLabel,
                                assetIcon: 'assets/icons/info-icon.png',
                                callback: () => {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.infoReverse,
                                    animType: AnimType.bottomSlide,
                                    title: 'Info',
                                    btnOkText: 'Ok',
                                    btnOkOnPress: () {},
                                    desc: l10n.thisAppCry,
                                  ).show()
                                },
                              ),
                              VerticalSpacer.regular(),
                              CustomTile(
                                labelText: l10n.logout,
                                assetIcon: 'assets/icons/logout-icon.png',
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
                height: 150,
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
              decoration: InputDecoration(
                labelText: context.l10n.nameLabel,
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
                content: Text(
                  context.l10n.buttonSendText,
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
