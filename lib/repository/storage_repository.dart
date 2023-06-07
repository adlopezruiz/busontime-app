import 'dart:io';

import 'package:bot_main_app/dependency_injection/injector.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageRepository {
  Future<String?> uploadImage({
    required File image,
    required String fileName,
  }) async {
    final storage = getIt<FirebaseStorage>();
    try {
      await storage.ref('profileImages/$fileName').putFile(image);
      final imgUrl =
          await storage.ref('profileImages/$fileName').getDownloadURL();

      return imgUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  Future<void> deleteImage({required String imgName}) async {
    final storage = getIt<FirebaseStorage>();
    print(imgName);
    try {
      await storage.ref('profileImages/$imgName').delete();
    } catch (e) {
      throw Exception('Failed to delete image: $e');
    }
  }
}
