import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker imgpick = ImagePicker();
  XFile? file = await imgpick.pickImage(source: source);
  if (file != null) {
    return await file.readAsBytes();
  }
  print('NO Image is selected');
}

showSnakBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}
