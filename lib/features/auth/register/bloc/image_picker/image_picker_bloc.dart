import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:bot_main_app/dependency_injection/injector.dart';
import 'package:bot_main_app/features/auth/register/bloc/register/register_cubit.dart';
import 'package:bot_main_app/models/custom_error.dart';
import 'package:bot_main_app/repository/auth/auth_repository.dart';
import 'package:bot_main_app/repository/auth/storage_repository.dart';
import 'package:bot_main_app/repository/auth/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

part 'image_picker_event.dart';
part 'image_picker_state.dart';

class ImagePickerBloc extends Bloc<ImagePickerEvent, ImagePickerState> {
  ImagePickerBloc() : super(ImagePickerState.unknown()) {
    on<PickImageRequestedEvent>((event, emit) async {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        try {
          final imageFile = File(pickedFile.path);
          emit(
            state.copyWith(
              imagePickerStatus: ImagePickerStatus.picked,
              image: imageFile,
            ),
          );
          //Register user now with staged data.
          await getIt<RegisterCubit>().register();
          //Upload image to storage, this also trigger update user data
          add(UploadImageRequestedEvent());
        } catch (e) {
          emit(state.copyWith(imagePickerStatus: ImagePickerStatus.error));
          throw CustomError(
            code: 'Exception',
            message: e.toString(),
            plugin: 'ImagePicker',
          );
        }
      }
    });

    on<MakePhotoRequestedEvent>(
      (event, emit) async {
        final pickedFile = await picker.pickImage(source: ImageSource.camera);

        if (pickedFile != null) {
          final imageFile = File(pickedFile.path);
          emit(
            state.copyWith(
              imagePickerStatus: ImagePickerStatus.picked,
              image: imageFile,
            ),
          );
        }
      },
    );

    on<UploadImageRequestedEvent>(
      (event, emit) async {
        try {
          if (state.image != null) {
            final imageUrl =
                await getIt<StorageRepository>().uploadImage(state.image!);
            //Update user data with image URL from storage
            final actualUser = await getIt<UserRepository>().getProfile(
              uid: getIt<AuthRepository>().currentUser!.uid,
            );
            //Updating the actual user via API
            await getIt<UserRepository>().updateUserData(
              actualUser.copyWith(
                profileImage: imageUrl,
              ),
            );
            //Now we can emit uploaded to keep the flow
            emit(state.copyWith(imagePickerStatus: ImagePickerStatus.uploaded));
            getIt<GoRouter>().go('/home');
          }
        } catch (e) {
          emit(state.copyWith(imagePickerStatus: ImagePickerStatus.error));
          throw CustomError(
            code: 'Exception',
            message: e.toString(),
            plugin: 'ImagePicker',
          );
        }
      },
    );
  }
  final picker = getIt<ImagePicker>();
}
