import 'dart:io';

import 'package:estacionaqui/app/utils/logger.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<File?> pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  Future<File?> pickImageFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  Future<String?> uploadUserProfileImage(File file, String uid) async {
    try {
      final fileName = const Uuid().v4();
      final ref = _storage.ref().child('users/$uid/$fileName.jpg');
      final uploadTask = await ref.putFile(file);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      Logger.info(e.toString());
      return null;
    }
  }
}
