import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FullScreenImage extends ModalRoute {
  final String? imageUrl;
  final ImageProvider? image;
  FullScreenImage({this.imageUrl, this.image});

  @override
  Duration get transitionDuration => const Duration();

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => Colors.black54;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return Material(
      type: MaterialType.transparency,
      child: InteractiveViewer(
        child: image != null ? Image(image: image!) : CachedNetworkImage(imageUrl: imageUrl ?? ""),
      ),
    );
  }
}
