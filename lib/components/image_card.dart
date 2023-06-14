import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  final Color? color;
  final String? title;
  final double? width;
  final Widget? child;
  final double? height;
  final Color? cardColor;
  final double elevation;
  final Color? titleColor;
  final String? background;
  final VoidCallback onTap;
  final ShapeBorder? shape;
  final double borderRadius;
  final BoxFit? backgroundFit;
  final Alignment titleAlignment;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final Color titleBackgroundColor;

  const ImageCard({
    super.key,
    required this.onTap,
    this.color,
    this.title,
    this.child,
    this.shape,
    this.cardColor,
    this.background,
    this.height = 128,
    this.backgroundFit,
    this.elevation = 0,
    this.borderRadius = 12.5,
    this.width = double.infinity,
    this.titleColor = Colors.white,
    this.padding = const EdgeInsets.all(8),
    this.titleAlignment = Alignment.topLeft,
    this.titleBackgroundColor = Colors.black54,
    this.margin = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: shape ?? RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
      clipBehavior: Clip.hardEdge,
      elevation: elevation,
      color: cardColor,
      margin: margin,
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            if (background != null) ...[_backgroundImageWidget()],
            if (title != null) ...[_titleWidget()],
            if (child != null) ...[child!],
            Positioned.fill(child: Material(color: Colors.transparent, child: InkWell(splashColor: color, onTap: onTap))),
          ],
        ),
      ),
    );
  }

  Widget _backgroundImageWidget() {
    return Positioned.fill(
      child: Image.asset(background!, fit: backgroundFit),
    );
  }

  Widget _titleWidget() {
    return Positioned.fill(
      child: Align(
        alignment: titleAlignment,
        child: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: titleBackgroundColor, borderRadius: const BorderRadius.all(Radius.circular(8))),
          child: FittedBox(child: Text(title!, style: TextStyle(color: titleColor, fontSize: 18, fontWeight: FontWeight.bold))),
        ),
      ),
    );
  }
}
