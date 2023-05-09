import 'package:ap_assistant/components/circle_image.dart';
import 'package:ap_assistant/components/custom_list_tile.dart';
import 'package:ap_assistant/models/person.dart';
import 'package:ap_assistant/utils/face_detector_utils.dart';
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
      shape: const StadiumBorder(),
      subtitle: Text(person.relation, style: const TextStyle(color: Colors.black54)),
      trailing: onDelete != null ? InkResponse(onTap: onDelete, child: const Icon(Icons.delete, color: Colors.red)) : null,
      leading: SizedBox(
        width: 100,
        child: Stack(
          children: [
            Positioned(child: _circleImage(person, 0)),
            Positioned(left: 24, child: _circleImage(person, 2)),
            Positioned(left: 48, child: _circleImage(person, 1)),
          ],
        ),
      ),
    );
  }

  Widget _circleImage(Person person, int imageIndex) {
    return CircleImage(
        radius: 25,
        image: (() {
          if (imageIndex < person.imagesBytes.length && person.imagesBytes[imageIndex] != null) {
            return MemoryImage(person.imagesBytes[imageIndex]!);
          } else if (imageIndex < person.imagesUrls.length) {
            return NetworkImage(person.imagesUrls[imageIndex]);
          } else {
            return AssetImage("assets/images/face_${FaceDirection.values[imageIndex].name}_placeholder.png");
          }
        }()) as ImageProvider);
  }
}
