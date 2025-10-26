import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

class ChooseImageReturn {
  String? filePath;
  String? fileData;
  ChooseImageReturn({required this.filePath, required this.fileData});
}

class FileUtil {
  static Future<ChooseImageReturn?> chooseImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? imageFile;
    try {
      imageFile = await picker.pickImage(source: ImageSource.gallery);
    } catch (e) {
      print(e);
    }
    final String? filePath = imageFile?.path;
    Uint8List? bytes;
    try {
      bytes = await imageFile?.readAsBytes();
    } catch (e) {
      print(e);
    }
    if (imageFile == null) {
      return null;
    }
    if (bytes == null) {
      return null;
    }

    return ChooseImageReturn(filePath: filePath, fileData: base64Encode(bytes));
  }

  static Future getBase64DataByFilePath(String filePath) async {
    List<int> bytes = [];
    try {
      bytes = await File(filePath).readAsBytes();
    } catch (e) {
      print(e);
    }
    String base64String = base64Encode(bytes);
    return 'data:image/png;base64,$base64String';
  }
}
