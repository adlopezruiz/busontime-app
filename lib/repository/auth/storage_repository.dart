import 'dart:io';

import 'package:bot_main_app/dependency_injection/injector.dart';
import 'package:bot_main_app/features/auth/register/bloc/register/register_cubit.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageRepository {
  Future<String?> uploadImage(File image) async {
    final fileName = getIt<RegisterCubit>().userStagedData['name'].toString() +
        DateTime.now().millisecondsSinceEpoch.toString();

    final storage = getIt<FirebaseStorage>();
    try {
      await storage.ref('profileImages/$fileName').putFile(image);
      final imgUrl =
          await storage.ref('profileImages/$fileName').getDownloadURL();
      print(imgUrl);
      return imgUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
}
