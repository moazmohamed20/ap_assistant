import 'package:ap_assistant/components/circle_image.dart';
import 'package:ap_assistant/models/person.dart';
import 'package:ap_assistant/theme.dart';
import 'package:ap_assistant/utils/face_detector_utils.dart';
import 'package:ap_assistant/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PersonDialog extends StatelessWidget {
  final Person? person;
  late final PersonDialogController controller;
  PersonDialog({super.key, this.person}) : controller = Get.put(PersonDialogController(person: person));

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
      child: Text("Person", style: appThemeData.textTheme.titleLarge!),
    );
  }

  Widget _contentWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, top: 16, right: 24, bottom: 24),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_circleImage(FaceDirection.left), _circleImage(FaceDirection.front), _circleImage(FaceDirection.right)],
        ),
        const SizedBox(height: 24),
        Form(key: controller.formKey, child: _formFields()),
      ]),
    );
  }

  Widget _circleImage(FaceDirection faceDirection) {
    return GetBuilder<PersonDialogController>(builder: (controller) {
      return CircleImage(
        radius: 50,
        onTap: () => controller.pickFacePhoto(faceDirection),
        image: (() {
          if (controller.facesImagesBytes[faceDirection.index] != null) {
            return MemoryImage(controller.facesImagesBytes[faceDirection.index]!);
          } else if (person?.imagesBytes[faceDirection.index] != null) {
            return MemoryImage(person!.imagesBytes[faceDirection.index]!);
          } else if (person?.imagesUrls[faceDirection.index] != null) {
            return NetworkImage(person!.imagesUrls[faceDirection.index]);
          } else {
            return AssetImage("assets/images/face_${faceDirection.name}_placeholder.png");
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
          decoration: const InputDecoration(labelText: "Name", prefixIcon: Icon(Icons.person), hintText: "i.e. John Nommensen"),
        ),
        const SizedBox(height: 8),
        TextFormField(
          validator: controller.requiredValidator,
          controller: controller.relationController,
          decoration: const InputDecoration(labelText: "Relation", prefixIcon: Icon(Icons.family_restroom), hintText: "i.e. Son"),
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

class PersonDialogController extends GetxController {
  final Person? person;
  PersonDialogController({this.person});

  late final GlobalKey<FormState> formKey;
  late final List<Uint8List?> facesImagesBytes;
  late final TextEditingController nameController;
  late final TextEditingController relationController;

  @override
  void onInit() {
    formKey = GlobalKey<FormState>();
    nameController = TextEditingController(text: person?.name);
    relationController = TextEditingController(text: person?.relation);
    facesImagesBytes = person != null ? person!.imagesBytes : List<Uint8List?>.filled(FaceDirection.values.length, null);
    super.onInit();
  }

  String? requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "This Field Is Required";
    }
    return null;
  }

  void pickFacePhoto(FaceDirection faceDirection) async {
    // 1) Pick A Photo
    final imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      // 2) Detect Face On The Photo
      final face = await FaceDetectorUtils.detectFace(imageFile);

      if (face == null) {
        Snackbar.show("No Faces Detected", type: SnackType.error);
      } else if (faceDirection == FaceDirection.left && face.headEulerAngleY! > -15) {
        Snackbar.show("The Face Must Be Pointed To The Left", type: SnackType.error);
      } else if (faceDirection == FaceDirection.right && face.headEulerAngleY! < 15) {
        Snackbar.show("The Face Must Be Pointed To The Right", type: SnackType.error);
      } else if (faceDirection == FaceDirection.front && (face.headEulerAngleY! > 15 || face.headEulerAngleY! < -15)) {
        Snackbar.show("The Face Must Be Pointed To The Camera", type: SnackType.error);
      } else if (face.rightEyeOpenProbability! < 0.8 || face.leftEyeOpenProbability! < 0.8) {
        Snackbar.show("The Eyes Must Be Open", type: SnackType.error);
      } else {
        // 3) Read The Photo As Bytes (To Be Manipulated)
        final imageBytes = await imageFile.readAsBytes();
        facesImagesBytes[faceDirection.index] = await FaceDetectorUtils.cropFaceAsync(imageBytes, face, 512);
        update();
      }
    }
  }

  void cancel() {
    Get.back();
  }

  void save() {
    Get.focusScope?.unfocus();

    if (facesImagesBytes.contains(null) && person == null) {
      Snackbar.show("The Person Photos are Required", type: SnackType.error);
      return;
    }

    if (!formKey.currentState!.validate()) return;

    final result = Person(
      imagesBytes: facesImagesBytes,
      name: nameController.text.trim(),
      relation: relationController.text.trim(),
    );
    Get.back(result: result);
  }
}
