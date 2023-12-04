import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage({required ImageSource source, required bool isProfile}) async {
  final ImagePicker imagePicker = ImagePicker();

  XFile? file = await imagePicker.pickImage(source: source);

  if (file != null) {
    return await file.readAsBytes();
  } else {
    if (isProfile) {}

    // print('No image selected');
  }
}

showSnackBar(String content, BuildContext context) {
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
      ),
    );
  }
}
