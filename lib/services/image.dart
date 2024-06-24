import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

class ImageService {
  final _picker = ImagePicker();

  static final _instance = ImageService._();

  factory ImageService() {
    return _instance;
  }

  ImageService._();

  Future<Uint8List?> getLostData() async {
    final response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return null;
    }
    final file = response.file;
    if (file == null) {
      return null;
    }
    return file.readAsBytes();
  }

  Future<Uint8List?> pickImage([
    source = ImageSource.camera,
  ]) async {
    final image = await _picker.pickImage(source: source);
    if (image == null) {
      return null;
    }
    return image.readAsBytes();
  }
}
