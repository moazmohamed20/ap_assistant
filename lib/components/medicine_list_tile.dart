import 'package:ap_assistant/components/circle_image.dart';
import 'package:ap_assistant/components/custom_list_tile.dart';
import 'package:ap_assistant/models/medicine.dart';
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
      shape: const StadiumBorder(),
      padding: const EdgeInsets.fromLTRB(8, 8, 24, 8),
      subtitle: Text(medicine.description, style: const TextStyle(color: Colors.black54)),
      leading: CircleImage(radius: 30, image: NetworkImage(medicine.fullImageUrl)),
      trailing: onDelete != null ? InkResponse(onTap: onDelete, child: const Icon(Icons.delete, color: Colors.red)) : null,
    );
  }
}
