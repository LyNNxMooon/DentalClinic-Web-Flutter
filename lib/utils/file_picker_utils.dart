import 'dart:io';

import 'package:file_picker/file_picker.dart';

class FilePickerUtils {
  Future<File?> getImage() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: false);
    if (result == null) {
      return null;
    }
    return File(result.files.single.path ?? '');
  }
}
