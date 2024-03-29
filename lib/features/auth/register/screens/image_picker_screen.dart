import 'package:bot_main_app/dependency_injection/injector.dart';
import 'package:bot_main_app/features/auth/register/bloc/image_picker/image_picker_bloc.dart';
import 'package:bot_main_app/features/navbar/bloc/navbar_cubit/navbar_cubit.dart';
import 'package:bot_main_app/features/profile/bloc/profile_cubit.dart';
import 'package:bot_main_app/l10n/l10n.dart';
import 'package:bot_main_app/ui/atoms/buttons.dart';
import 'package:bot_main_app/ui/atoms/spacers.dart';
import 'package:bot_main_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UserImagePicker extends StatelessWidget {
  const UserImagePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Column(
              children: [
                //Title
                Text(
                  l10n.addProfileImage,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                VerticalSpacer.regular(),
                //Subtitle
                Text(
                  l10n.lookGood,
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                VerticalSpacer.double(),
                BlocBuilder<ImagePickerBloc, ImagePickerState>(
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: const BoxDecoration(
                          color: AppColors.secondaryGrey,
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: state.image != null
                              ? Image.file(
                                  state.image!,
                                  fit: BoxFit.cover,
                                  width: 300,
                                  height: 300,
                                )
                              : Image.asset(
                                  'assets/images/no-img-placeholder.png',
                                  fit: BoxFit.cover,
                                  width: 300,
                                  height: 300,
                                ),
                        ),
                      ),
                    );
                  },
                ),
                VerticalSpacer.triple(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Skip button
                    TextButton(
                      onPressed: () {
                        if (getIt<ProfileCubit>().state.previusState ==
                            ProfileStatus.loggedOut) {
                          getIt<NavbarCubit>().changePage(0);
                        }
                        getIt<GoRouter>().go('/home');
                      },
                      child: Text(
                        l10n.skip,
                        style: const TextStyle(
                          color: AppColors.primaryBlack,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    HorizontalSpacer.double(),
                    //Pop gallery button
                    Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: AppColors.secondaryGrey,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          context
                              .read<ImagePickerBloc>()
                              .add(PickImageRequestedEvent());
                        },
                        icon: const Icon(
                          Icons.photo_outlined,
                          size: 32,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ),
                    HorizontalSpacer.regular(),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryGreen,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          context
                              .read<ImagePickerBloc>()
                              .add(MakePhotoRequestedEvent());
                        },
                        icon: const Icon(
                          Icons.photo_camera_outlined,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    HorizontalSpacer.double(),
                    BlocBuilder<ImagePickerBloc, ImagePickerState>(
                      builder: (context, state) {
                        return Column(
                          children: [
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: IconButton(
                                onPressed: () {
                                  //Delete photo.
                                  context
                                      .read<ImagePickerBloc>()
                                      .add(RemoveImageFromPickerEvent());
                                },
                                icon: const Icon(
                                  Icons.close,
                                  size: 42,
                                  color: AppColors.primaryBlack,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
                VerticalSpacer.triple(),
                BlocBuilder<ImagePickerBloc, ImagePickerState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: 200,
                      height: 50,
                      child: Buttons.primary(
                        content: state.imagePickerStatus ==
                                    ImagePickerStatus.picked ||
                                state.imagePickerStatus ==
                                    ImagePickerStatus.unknown
                            ? Text(
                                l10n.buttonSendText,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                        onPressed: state.imagePickerStatus ==
                                    ImagePickerStatus.uploading ||
                                state.imagePickerStatus ==
                                    ImagePickerStatus.unknown
                            ? null
                            : () {
                                context
                                    .read<ImagePickerBloc>()
                                    .add(UploadImageRequestedEvent());
                              },
                      ),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
