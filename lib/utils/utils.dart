import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

pickImage({required ImageSource source, required bool isProfile}) async {
  final ImagePicker imagePicker = ImagePicker();
  const imageUrl =
      'https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg';

  XFile? file = await imagePicker.pickImage(source: source);

  if (file != null) {
    return await file.readAsBytes();
  } else {
    if (isProfile) {
      http.Response response = await http.get(Uri.parse(imageUrl));
      return response.bodyBytes;
    }

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
