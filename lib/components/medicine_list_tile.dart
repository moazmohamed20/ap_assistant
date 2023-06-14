import 'package:ap_assistant/components/circle_image.dart';
import 'package:ap_assistant/components/custom_list_tile.dart';
import 'package:ap_assistant/models/medicine.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MedicineListTile extends StatelessWidget {
  final Medicine medicine;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  const MedicineListTile({super.key, required this.medicine, this.onTap, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      onTap: onTap,
      elevation: 1,
      title: Text(medicine.name),
      padding: const EdgeInsets.fromLTRB(8, 8, 24, 8),
      leading: CircleImage(radius: 30, image: CachedNetworkImageProvider(medicine.fullImageUrl)),
      subtitle: Text(medicine.description, style: const TextStyle(color: Colors.black54)),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.5))),
      trailing: onDelete != null ? InkResponse(onTap: onDelete, child: const Icon(Icons.delete, color: Colors.red)) : null,
    );
  }
}
