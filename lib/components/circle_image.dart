import 'package:ap_assistant/components/full_screen_image.dart';
import 'package:flutter/material.dart';

class CircleImage extends StatelessWidget {
  final VoidCallback? onTap;
  final ImageProvider image;
  final double radius;
  final double border;
  final bool preview;

  const CircleImage({
    super.key,
    required this.image,
    this.preview = true,
    this.radius = 70,
    this.border = 1,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.black12,
      child: CircleAvatar(
        backgroundColor: Colors.white,
        backgroundImage: image,
        radius: radius - border,
        child: Material(
          shape: const CircleBorder(),
          color: Colors.transparent,
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: onTap ?? (preview && image is! AssetImage ? () => Navigator.push(context, FullScreenImage(image: image)) : null),
          ),
        ),
      ),
    );
  }
}
