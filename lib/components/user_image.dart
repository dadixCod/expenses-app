import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

class UserImage extends StatefulWidget {
  final Function(File pickedImage) imagePickFn;
  const UserImage(this.imagePickFn, {super.key});

  @override
  State<UserImage> createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {
  File? _pickedImage;
  @override
  Widget build(BuildContext context) {
    void pickImage() async {
      final ImagePicker picker = ImagePicker();
      final pickedImageFile = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
        maxWidth: 400,
      );
      if (pickedImageFile == null) {
        return;
      }
      setState(() {
        _pickedImage = File(pickedImageFile.path);
      });
      widget.imagePickFn(_pickedImage!);
    }

    return Column(
      children: [
        GestureDetector(
          onTap: pickImage,
          child: CircleAvatar(
            backgroundColor: Colors.grey,
            radius: 50,
            backgroundImage: _pickedImage != null ? FileImage(_pickedImage!) : null,
            child: SizedBox(
              width: 40,
              child: _pickedImage == null ? Image.asset("assets/images/camera.png") : null,
            ),
          ),
        ),
        const Gap(10)
      ],
    );
  }
}
