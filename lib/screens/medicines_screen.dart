import 'package:ap_assistant/apis/medicines_api.dart';
import 'package:ap_assistant/components/medicine_list_tile.dart';
import 'package:ap_assistant/dialogs/medicine_dialog.dart';
import 'package:ap_assistant/models/medicine.dart';
import 'package:ap_assistant/models/patient.dart';
import 'package:ap_assistant/utils/snackbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MedicinesScreen extends GetView<MedicineController> {
  const MedicinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Medicines"), backgroundColor: Colors.blue),
      floatingActionButton: _fab(),
      body: _listView(),
    );
  }

  Widget _listView() {
    return GetBuilder<MedicineController>(
      builder: (controller) {
        return ListView.builder(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          itemCount: controller.patient.medicines.length,
          itemBuilder: (context, index) {
            return MedicineListTile(
              medicine: controller.patient.medicines[index],
              onTap: () => controller.editMedicine(index),
              onDelete: () => controller.deleteMedicine(index),
            );
          },
        );
      },
    );
  }

  Widget _fab() {
    return FloatingActionButton(
      backgroundColor: Colors.blue,
      onPressed: controller.addMedicine,
      child: const Icon(Icons.add),
    );
  }
}

class MedicineController extends GetxController {
  final Patient patient;
  MedicineController({required this.patient});

  void addMedicine() async {
    Medicine? medicine = await Get.bottomSheet<Medicine>(
      MedicineDialog(),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
    ).then((value) {
      Get.delete<MedicineDialogController>();
      return value;
    });
    if (medicine == null) return;

    try {
      medicine = await MedicinesApi.postMedicine(medicine.copyWith(patientId: patient.id));
    } catch (e) {
      Snackbar.show(e.toString(), type: SnackType.error);
      return;
    }

    patient.medicines.add(medicine);
    GetStorage().write("patient", patient);
    update();
  }

  void editMedicine(int index) async {
    Medicine? editedMedicine = await Get.bottomSheet<Medicine>(
      MedicineDialog(medicine: patient.medicines[index]),
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
    ).then((value) {
      Get.delete<MedicineDialogController>();
      return value;
    });
    if (editedMedicine == null) return;

    try {
      editedMedicine = await MedicinesApi.putMedicine(editedMedicine);
    } catch (e) {
      Snackbar.show(e.toString(), type: SnackType.error);
      return;
    }

    if (editedMedicine.imageBytes != null) CachedNetworkImage.evictFromCache(editedMedicine.fullImageUrl);
    patient.medicines[index] = editedMedicine;
    GetStorage().write("patient", patient);
    update();
  }

  deleteMedicine(int index) {
    try {
      MedicinesApi.deleteMedicine(patient.medicines[index].id);
    } catch (e) {
      Snackbar.show(e.toString(), type: SnackType.error);
      return;
    }

    patient.medicines.removeAt(index);
    GetStorage().write("patient", patient);
    update();
  }
}
