import 'package:ap_assistant/apis/medicines_api.dart';
import 'package:ap_assistant/components/medicine_list_tile.dart';
import 'package:ap_assistant/dialogs/loading_dialog.dart';
import 'package:ap_assistant/dialogs/medicine_dialog.dart';
import 'package:ap_assistant/models/medicine.dart';
import 'package:ap_assistant/models/patient.dart';
import 'package:ap_assistant/utils/modal_bottom_sheet.dart';
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
    Get.lazyPut(() => MedicineDialogController()); // ToDo: Remove
    Medicine? medicine = await ModalBottomSheet.show<Medicine>(
      sheet: const MedicineDialog(),
      controller: MedicineDialogController(),
    );
    if (medicine == null) return;

    try {
      Get.dialog(const LoadingDialog(), barrierDismissible: false);
      medicine = await MedicinesApi.postMedicine(medicine.copyWith(patientId: patient.id));
      Get.back();
    } catch (e) {
      Get.back();
      Snackbar.show(e.toString(), type: SnackType.error);
      return;
    }

    patient.medicines.add(medicine);
    GetStorage().write("patient", patient);
    update();
  }

  void editMedicine(int index) async {
    Get.lazyPut(() => MedicineDialogController(medicine: patient.medicines[index])); // ToDo: Remove
    Medicine? editedMedicine = await ModalBottomSheet.show<Medicine>(
      sheet: const MedicineDialog(),
      controller: MedicineDialogController(medicine: patient.medicines[index]),
    );
    if (editedMedicine == null) return;

    try {
      Get.dialog(const LoadingDialog(), barrierDismissible: false);
      editedMedicine = await MedicinesApi.putMedicine(editedMedicine);
      Get.back();
    } catch (e) {
      Get.back();
      Snackbar.show(e.toString(), type: SnackType.error);
      return;
    }

    CachedNetworkImage.evictFromCache(editedMedicine.fullImageUrl);
    patient.medicines[index] = editedMedicine;
    GetStorage().write("patient", patient);
    update();
  }

  void deleteMedicine(int index) async {
    try {
      Get.dialog(const LoadingDialog(), barrierDismissible: false);
      MedicinesApi.deleteMedicine(patient.medicines[index].id);
      Get.back();
    } catch (e) {
      Get.back();
      Snackbar.show(e.toString(), type: SnackType.error);
      return;
    }

    patient.medicines.removeAt(index);
    GetStorage().write("patient", patient);
    update();
  }
}
