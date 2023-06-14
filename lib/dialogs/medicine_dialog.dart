import 'package:ap_assistant/components/circle_image.dart';
import 'package:ap_assistant/dialogs/bottom_sheet_dialog.dart';
import 'package:ap_assistant/models/medicine.dart';
import 'package:ap_assistant/utils/guid_generator.dart';
import 'package:ap_assistant/utils/snackbar.dart';
import 'package:ap_assistant/utils/validators.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MedicineDialog extends GetView<MedicineDialogController> {
  const MedicineDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomSheetDialog(
      title: "Medicine",
      body: Column(
        children: [
          _circleImage(),
          const SizedBox(height: 24),
          Form(key: controller.formKey, child: _formFields()),
        ],
      ),
      actions: [
        TextButton(onPressed: controller.cancel, child: const Text("Cancel")),
        TextButton(onPressed: controller.save, child: const Text("Save")),
      ],
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
          } else if (controller.medicine != null) {
            return CachedNetworkImageProvider(controller.medicine!.fullImageUrl);
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
          validator: Validators.requiredValidator,
          decoration: const InputDecoration(labelText: "Name", prefixIcon: Icon(Icons.medication), hintText: "i.e. Panadol Extra "),
        ),
        const SizedBox(height: 8),
        TextFormField(
          validator: Validators.requiredValidator,
          controller: controller.descriptionController,
          decoration: const InputDecoration(labelText: "Description", prefixIcon: Icon(Icons.info), hintText: "i.e. Pain Killer"),
        ),
      ],
    );
  }
}

class MedicineDialogController extends GetxController {
  final Medicine? medicine;
  MedicineDialogController({this.medicine});

  late final TextEditingController descriptionController;
  late final TextEditingController nameController;
  late final GlobalKey<FormState> formKey;
  late Uint8List? medicineImageBytes;

  @override
  void onInit() {
    formKey = GlobalKey<FormState>();
    medicineImageBytes = medicine?.imageBytes;
    nameController = TextEditingController(text: medicine?.name);
    descriptionController = TextEditingController(text: medicine?.description);
    super.onInit();
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
