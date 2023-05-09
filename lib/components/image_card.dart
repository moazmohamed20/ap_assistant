import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  final String assetPath;
  final VoidCallback onTap;
  const ImageCard({super.key, required this.assetPath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.5))),
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: const EdgeInsets.all(8.0), child: Image.asset(assetPath)),
      ),
    );
  }
}
