import 'package:flutter/material.dart';

class ImagePostElement extends StatelessWidget {
  const ImagePostElement({Key? key, required this.image, required this.iconButton})
      : super(key: key);
  final Image image;
  final IconButton iconButton;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: image,
        ),
        Positioned(
            top: 0,
            right: 0,
            child: Container(
              child: iconButton,
        ))
      ],
    );
  }
}
