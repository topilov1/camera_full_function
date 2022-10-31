import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class Info extends StatelessWidget {
  final String link;
  const Info({super.key, required this.link});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.cyan,
      child: PhotoView(
        backgroundDecoration: const BoxDecoration(
          color: Colors.white,
          backgroundBlendMode: BlendMode.srcATop,
        ),
        imageProvider: AssetImage(link),
      ),
    );
  }
}
