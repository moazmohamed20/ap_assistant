import 'package:ap_assistant/components/circle_image.dart';
import 'package:ap_assistant/models/medicine.dart';
import 'package:ap_assistant/theme.dart';
import 'package:ap_assistant/utils/guid_generator.dart';
import 'package:ap_assistant/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MedicineDialog extends StatelessWidget {
  final Medicine? medicine;
  late final MedicineDialogController controller;
  MedicineDialog({super.key, this.medicine}) : controller = Get.put(MedicineDialogController(medicine: medicine));

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _titleWidget(),
        _contentWidget(),
        _actionWidgets(),
      ],
    );
  }

  Widget _titleWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, top: 24, right: 24, bottom: 0),
      child: Text("Medicine", style: appThemeData.textTheme.titleLarge!),
    );
  }

  Widget _contentWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, top: 16, right: 24, bottom: 24),
      child: Column(children: [
        _circleImage(),
        const SizedBox(height: 24),
        Form(key: controller.formKey, child: _formFields()),
      ]),
    );
  }

  Widget _circleImage() {
    return GetBuilder<MedicineDialogController>(builder: (controller) {
      return CircleImage(
        radius: 100,
        onTap: controller.pickMedicineImage,
        image: (() {
          if (controller.medicineImageBytes != null) {
            return MemoryImage(controller.medicineImageBytes!);
          } else if (medicine != null) {
            return NetworkImage(medicine!.fullImageUrl);
          } else {
            return const AssetImage("assets/images/medicine_placeholder.png");
          }
        }()) as ImageProvider,
      );
    });
  }

  Widget _formFields() {
    return Column(
      children: [
        TextFormField(
          controller: controller.nameController,
          textInputAction: TextInputAction.next,
          validator: controller.requiredValidator,
          decoration: const InputDecoration(labelText: "Name", prefixIcon: Icon(Icons.medication), hintText: "i.e. Panadol Extra "),
        ),
        const SizedBox(height: 8),
        TextFormField(
          validator: controller.requiredValidator,
          controller: controller.descriptionController,
          decoration: const InputDecoration(labelText: "Description", prefixIcon: Icon(Icons.info), hintText: "i.e. Pain Killer"),
        ),
      ],
    );
  }

  Widget _actionWidgets() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: OverflowBar(
        spacing: 8,
        alignment: MainAxisAlignment.end,
        overflowDirection: VerticalDirection.down,
        overflowAlignment: OverflowBarAlignment.end,
        children: [
          TextButton(onPressed: controller.cancel, child: const Text("Cancel")),
          TextButton(onPressed: controller.save, child: const Text("Save")),
        ],
      ),
    );
  }
}

class MedicineDialogController extends GetxController {
  final Medicine? medicine;
  MedicineDialogController({this.medicine});

  late final TextEditingController descriptionController;
  late final TextEditingController nameController;
  late final GlobalKey<FormState> formKey;
  Uint8List? medicineImageBytes;

  @override
  void onInit() {
    formKey = GlobalKey<FormState>();
    nameController = TextEditingController(text: medicine?.name);
    descriptionController = TextEditingController(text: medicine?.description);
    super.onInit();
  }

  String? requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "This Field Is Required";
    }
    return null;
  }

  void pickMedicineImage() async {
    final imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      medicineImageBytes = await imageFile.readAsBytes();
      update();
    }
  }

  void cancel() {
    Get.back();
  }

  void save() {
    Get.focusScope?.unfocus();

    if (medicineImageBytes == null && medicine == null) {
      Snackbar.show("The Medicine Image is Required", type: SnackType.error);
      return;
    }

    if (!formKey.currentState!.validate()) return;

    final result = Medicine(
      imageBytes: medicineImageBytes,
      name: nameController.text.trim(),
      imageUrl: medicine?.imageUrl ?? "",
      patientId: medicine?.patientId ?? "",
      id: medicine?.id ?? GUIDGenerator.generate(),
      description: descriptionController.text.trim(),
    );

    Get.back(result: result);
  }
}
