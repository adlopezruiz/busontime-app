import 'package:bot_main_app/dependency_injection/injector.dart';
import 'package:bot_main_app/features/auth/register/bloc/image_picker/image_picker_bloc.dart';
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
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Column(
              children: [
                //Title
                const Text(
                  'Añadir imágen de perfil',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                VerticalSpacer.regular(),
                //Subtitle
                const Text(
                  '¡Asegúrate de lucir bien!',
                  style: TextStyle(fontSize: 18),
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
                      onPressed: () => getIt<GoRouter>().go('/home'),
                      child: const Text(
                        'Skip',
                        style: TextStyle(
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
                                  print('Pressed');
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
                        content: const Text(
                          'Enviar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: state.imagePickerStatus ==
                                ImagePickerStatus.uploading
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
