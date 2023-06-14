import 'package:ap_assistant/apis/people_api.dart';
import 'package:ap_assistant/components/person_list_tile.dart';
import 'package:ap_assistant/dialogs/loading_dialog.dart';
import 'package:ap_assistant/dialogs/person_dialog.dart';
import 'package:ap_assistant/models/patient.dart';
import 'package:ap_assistant/models/person.dart';
import 'package:ap_assistant/utils/modal_bottom_sheet.dart';
import 'package:ap_assistant/utils/snackbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class FamilyScreen extends GetView<FamilyController> {
  const FamilyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Family"), backgroundColor: Colors.orange),
      floatingActionButton: _fab(),
      body: _listView(),
    );
  }

  Widget _listView() {
    return GetBuilder<FamilyController>(
      builder: (controller) {
        return ListView.builder(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          itemCount: controller.patient.family.length,
          itemBuilder: (context, index) {
            return PersonListTile(
              person: controller.patient.family[index],
              onTap: () => controller.editPerson(index),
              onDelete: () => controller.deletePerson(index),
            );
          },
        );
      },
    );
  }

  Widget _fab() {
    return FloatingActionButton(
      backgroundColor: Colors.orange,
      onPressed: controller.addPerson,
      child: const Icon(Icons.add),
    );
  }
}

class FamilyController extends GetxController {
  final Patient patient;
  FamilyController({required this.patient});

  void addPerson() async {
    Get.lazyPut(() => PersonDialogController()); // ToDo: Remove
    Person? person = await ModalBottomSheet.show<Person>(
      sheet: const PersonDialog(),
      controller: PersonDialogController(),
    );
    if (person == null) return;

    try {
      Get.dialog(const LoadingDialog(), barrierDismissible: false);
      person = await PeopleApi.postPerson(person.copyWith(patientId: patient.id));
      Get.back();
    } catch (e) {
      Get.back();
      Snackbar.show(e.toString(), type: SnackType.error);
      return;
    }

    patient.family.add(person);
    update();
  }

  void editPerson(int index) async {
    Get.lazyPut(() => PersonDialogController(person: patient.family[index])); // ToDo: Remove
    Person? editedPerson = await ModalBottomSheet.show<Person>(
      sheet: const PersonDialog(),
      controller: PersonDialogController(person: patient.family[index]),
    );
    if (editedPerson == null) return;

    try {
      Get.dialog(const LoadingDialog(), barrierDismissible: false);
      editedPerson = await PeopleApi.putPerson(editedPerson);
      Get.back();
    } catch (e) {
      Get.back();
      Snackbar.show(e.toString(), type: SnackType.error);
      return;
    }

    CachedNetworkImage.evictFromCache(editedPerson.face.fullLeftUrl ?? "");
    CachedNetworkImage.evictFromCache(editedPerson.face.fullRightUrl ?? "");
    CachedNetworkImage.evictFromCache(editedPerson.face.fullFrontUrl ?? "");
    patient.family[index] = editedPerson;
    update();
  }

  void deletePerson(int index) {
    try {
      Get.dialog(const LoadingDialog(), barrierDismissible: false);
      PeopleApi.deletePerson(patient.family[index].id);
      Get.back();
    } catch (e) {
      Get.back();
      Snackbar.show(e.toString(), type: SnackType.error);
      return;
    }

    patient.family.removeAt(index);
    GetStorage().write("patient", patient);
    update();
  }
}
