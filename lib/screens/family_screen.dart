import 'package:ap_assistant/components/person_list_tile.dart';
import 'package:ap_assistant/dialogs/person_dialog.dart';
import 'package:ap_assistant/models/person.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FamilyScreen extends StatelessWidget {
  late final FamilyController controller;
  FamilyScreen({super.key}) : controller = Get.put(FamilyController());

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
          itemCount: controller.people.length,
          itemBuilder: (context, index) {
            return PersonListTile(
              person: controller.people[index],
              onTap: () => controller.editPerson(index),
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
  late List<Person> people;

  @override
  void onInit() {
    people = [];
    super.onInit();
  }

  void addPerson() async {
    final person = await Get.bottomSheet<Person>(
      PersonDialog(),
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
    ).then((value) {
      Get.delete<PersonDialogController>();
      return value;
    });
    if (person == null) return;
    people.add(person);
    update();
  }

  void editPerson(int index) async {
    final editedPerson = await Get.bottomSheet<Person>(
      PersonDialog(person: people[index]),
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
    ).then((value) {
      Get.delete<PersonDialogController>();
      return value;
    });
    if (editedPerson != null) people[index] = editedPerson;
    update();
  }
}
