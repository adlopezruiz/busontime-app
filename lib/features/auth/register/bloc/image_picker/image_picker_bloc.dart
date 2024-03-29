import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:bot_main_app/dependency_injection/injector.dart';
import 'package:bot_main_app/features/auth/register/bloc/register/register_cubit.dart';
import 'package:bot_main_app/features/navbar/bloc/navbar_cubit/navbar_cubit.dart';
import 'package:bot_main_app/features/profile/bloc/profile_cubit.dart';
import 'package:bot_main_app/repository/auth_repository.dart';
import 'package:bot_main_app/repository/storage_repository.dart';
import 'package:bot_main_app/repository/user_repository.dart';
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
        } catch (e) {
          //Deleting user from auth
          await deleteUserFromFBAuth();
          emit(state.copyWith(imagePickerStatus: ImagePickerStatus.error));
          throw Exception(e);
        }
      }
    });

    //Pop ups camera
    on<MakePhotoRequestedEvent>(
      (event, emit) async {
        try {
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
        } catch (e) {
          //Deleting user from auth
          await deleteUserFromFBAuth();
          emit(state.copyWith(imagePickerStatus: ImagePickerStatus.error));
          throw Exception(e);
        }
      },
    );

    //Upload image
    on<UploadImageRequestedEvent>(
      (event, emit) async {
        try {
          if (state.image != null) {
            //Forming a filename and updating state
            final fileName =
                getIt<RegisterCubit>().userStagedData['name'].toString() +
                    DateTime.now().millisecondsSinceEpoch.toString();
            emit(
              state.copyWith(
                imagePickerStatus: ImagePickerStatus.uploading,
                imgName: fileName,
                image: state.image,
              ),
            );

            //Uploading file
            final imageUrl = await getIt<StorageRepository>().uploadImage(
              image: state.image!,
              fileName: fileName,
            );
            //Update user data with image URL from storage
            final actualUser = await getIt<UserRepository>().getProfile(
              uid: getIt<AuthRepository>().currentUser!.uid,
            );
            //Updating the actual user via API
            await getIt<UserRepository>().updateUserData(
              newUser: actualUser.copyWith(
                profileImage: imageUrl,
              ),
            );
            //Now we can emit uploaded to keep the flow
            emit(state.copyWith(imagePickerStatus: ImagePickerStatus.uploaded));
            if (getIt<ProfileCubit>().state.previusState ==
                ProfileStatus.loggedOut) {
              getIt<NavbarCubit>().changePage(0);
            }
            getIt<GoRouter>().go('/home');
          }
        } catch (e) {
          //Deleting photo from storage if uploaded
          if (state.image != null) {
            await getIt<StorageRepository>()
                .deleteImage(imgName: state.imgName!);
          }
          //Deleting user from auth
          await deleteUserFromFBAuth();
          emit(state.copyWith(imagePickerStatus: ImagePickerStatus.error));
          throw Exception(e);
        }
      },
    );

    //Remove image from picker
    on<RemoveImageFromPickerEvent>(
      (event, emit) {
        emit(
          state.copyWith(
            imagePickerStatus: ImagePickerStatus.unknown,
          ),
        );
      },
    );
  }

  //Function to full delete an user from Firebase
  Future<void> deleteUserFromFBAuth() async {
    //Delete user from DB and auth
    final currentUser = getIt<AuthRepository>().currentUser;
    if (currentUser != null) {
      //Deletes from databse via API
      await getIt<UserRepository>().deleteUser(uid: currentUser.uid);
      //Deletes from auth and sign out
      await currentUser.delete();
    }
  }

  final picker = getIt<ImagePicker>();
}
