import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class FilePickerUtils {
  Future<dynamic> getImage() async {
    // Pick the file using file_picker
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result == null) {
      return null; // No file selected
    }

    if (kIsWeb) {
      // For Web, return the file bytes (Uint8List)
      return result.files.single.bytes;
    } else {
      // For Mobile/Desktop, return a File object using the file path
      return File(result.files.single.path ?? '');
    }
  }
}
