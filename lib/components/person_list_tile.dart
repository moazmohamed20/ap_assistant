import 'dart:typed_data';

import 'package:ap_assistant/components/circle_image.dart';
import 'package:ap_assistant/components/custom_list_tile.dart';
import 'package:ap_assistant/models/person.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PersonListTile extends StatelessWidget {
  final Person person;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  const PersonListTile({super.key, required this.person, this.onTap, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      onTap: onTap,
      elevation: 1,
      title: Text(person.name),
      padding: const EdgeInsets.fromLTRB(8, 8, 24, 8),
      leading: SizedBox(width: 120, child: _facePhotos(person.face)),
      subtitle: Text(person.relation, style: const TextStyle(color: Colors.black54)),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.5))),
      trailing: onDelete != null ? InkResponse(onTap: onDelete, child: const Icon(Icons.delete, color: Colors.red)) : null,
    );
  }

  Widget _facePhotos(Face face) {
    return Stack(
      children: [
        Positioned(child: _circlePhoto(FaceDirection.left, face.fullLeftUrl, face.leftBytes)),
        Positioned(left: 30, child: _circlePhoto(FaceDirection.right, face.fullRightUrl, face.rightBytes)),
        Positioned(left: 60, child: _circlePhoto(FaceDirection.front, face.fullFrontUrl, face.frontBytes)),
      ],
    );
  }

  Widget _circlePhoto(FaceDirection faceDirection, String? url, Uint8List? bytes) {
    return CircleImage(
        radius: 30,
        image: (() {
          if (bytes != null) {
            return MemoryImage(bytes);
          } else if (url != null) {
            return CachedNetworkImageProvider(url);
          } else {
            return AssetImage("assets/images/face_${faceDirection.name}_placeholder.png");
          }
        }()) as ImageProvider);
  }
}
