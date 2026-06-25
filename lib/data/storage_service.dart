import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> subirFoto(File foto, String id) async {
    final ref = _storage.ref().child('vacunaciones/$id.jpg');
    await ref.putFile(foto);
    return await ref.getDownloadURL();
  }
}