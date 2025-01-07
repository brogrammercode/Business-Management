import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

Future<String> uploadImage(
    {required String id,
    required File image,
    required String folder,
    required String fileName}) async {
  try {
    final ref =
        FirebaseStorage.instance.ref().child(folder).child(id).child(fileName);

    final uploadTask = await ref.putFile(image);
    final imageUrl = await uploadTask.ref.getDownloadURL();
    return imageUrl;
  } catch (e) {
    throw Exception("Failed to upload image: $e");
  }
}
