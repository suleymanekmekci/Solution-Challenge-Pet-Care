import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageUploader {
  static FirebaseStorage _storage = FirebaseStorage(
      storageBucket: "STORAGE BUCKET");

  static StorageUploadTask _uploadTask;

  static Future<StorageUploadTask> startUpload(
    String filePath,
    File file,
  ) async {
    _uploadTask = _storage.ref().child(filePath).putFile(file);
    return _uploadTask;
  }
}
