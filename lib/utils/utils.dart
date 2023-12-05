import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/models/user.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:provider/provider.dart';

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

User getUserData(StateSetter setState, BuildContext context, bool isLoading) {
  setState(() {
    isLoading = true;
  });
  User user = Provider.of<UserProvider>(context).getUser!;
  setState(() {
    isLoading = false;
  });
  return user;
}
