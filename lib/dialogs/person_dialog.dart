import 'package:ap_assistant/components/circle_image.dart';
import 'package:ap_assistant/dialogs/bottom_sheet_dialog.dart';
import 'package:ap_assistant/models/person.dart';
import 'package:ap_assistant/utils/face_detector_utils.dart';
import 'package:ap_assistant/utils/guid_generator.dart';
import 'package:ap_assistant/utils/snackbar.dart';
import 'package:ap_assistant/utils/validators.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PersonDialog extends GetView<PersonDialogController> {
  const PersonDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomSheetDialog(
      title: "Person",
      body: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // ToDo
            children: [_faceLeftPhoto(), _faceFrontPhoto(), _faceRightPhoto()],
          ),
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

  Widget _faceLeftPhoto() {
    return GetBuilder<PersonDialogController>(builder: (controller) {
      return CircleImage(
        radius: 40,
        onTap: () => controller.pickFacePhoto(FaceDirection.left),
        image: (() {
          if (controller.facesLeftBytes != null) {
            return MemoryImage(controller.facesLeftBytes!);
          } else if (controller.person?.face.fullLeftUrl != null) {
            return CachedNetworkImageProvider(controller.person!.face.fullLeftUrl!);
          } else {
            return const AssetImage("assets/images/face_left_placeholder.png");
          }
        }()) as ImageProvider,
      );
    });
  }

  Widget _faceFrontPhoto() {
    return GetBuilder<PersonDialogController>(builder: (controller) {
      return CircleImage(
        radius: 60,
        onTap: () => controller.pickFacePhoto(FaceDirection.front),
        image: (() {
          if (controller.facesFrontBytes != null) {
            return MemoryImage(controller.facesFrontBytes!);
          } else if (controller.person?.face.fullFrontUrl != null) {
            return CachedNetworkImageProvider(controller.person!.face.fullFrontUrl!);
          } else {
            return const AssetImage("assets/images/face_front_placeholder.png");
          }
        }()) as ImageProvider,
      );
    });
  }

  Widget _faceRightPhoto() {
    return GetBuilder<PersonDialogController>(builder: (controller) {
      return CircleImage(
        radius: 40,
        onTap: () => controller.pickFacePhoto(FaceDirection.right),
        image: (() {
          if (controller.facesRightBytes != null) {
            return MemoryImage(controller.facesRightBytes!);
          } else if (controller.person?.face.fullRightUrl != null) {
            return CachedNetworkImageProvider(controller.person!.face.fullRightUrl!);
          } else {
            return const AssetImage("assets/images/face_right_placeholder.png");
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
          decoration: const InputDecoration(labelText: "Name", prefixIcon: Icon(Icons.person), hintText: "i.e. John Nommensen"),
        ),
        const SizedBox(height: 8),
        TextFormField(
          validator: Validators.requiredValidator,
          controller: controller.relationController,
          decoration: const InputDecoration(labelText: "Relation", prefixIcon: Icon(Icons.family_restroom), hintText: "i.e. Son"),
        ),
      ],
    );
  }
}

class PersonDialogController extends GetxController {
  final Person? person;
  PersonDialogController({this.person});

  late Uint8List? facesLeftBytes;
  late Uint8List? facesRightBytes;
  late Uint8List? facesFrontBytes;
  late final GlobalKey<FormState> formKey;
  late final TextEditingController nameController;
  late final TextEditingController relationController;

  @override
  void onInit() {
    formKey = GlobalKey<FormState>();
    facesLeftBytes = person?.face.leftBytes;
    facesRightBytes = person?.face.rightBytes;
    facesFrontBytes = person?.face.frontBytes;
    nameController = TextEditingController(text: person?.name);
    relationController = TextEditingController(text: person?.relation);
    super.onInit();
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
        final croppedImageBytes = await FaceDetectorUtils.cropFaceAsync(imageBytes, face, 512);

        if (faceDirection == FaceDirection.left) {
          facesLeftBytes = croppedImageBytes;
        } else if (faceDirection == FaceDirection.right) {
          facesRightBytes = croppedImageBytes;
        } else if (faceDirection == FaceDirection.front) {
          facesFrontBytes = croppedImageBytes;
        }

        update();
      }
    }
  }

  void cancel() {
    Get.back();
  }

  void save() {
    Get.focusScope?.unfocus();

    if (facesFrontBytes == null && person == null) {
      Snackbar.show("The Person Photos are Required", type: SnackType.error);
      return;
    }

    if (!formKey.currentState!.validate()) return;

    final result = Person(
      name: nameController.text.trim(),
      patientId: person?.patientId ?? "",
      relation: relationController.text.trim(),
      id: person?.id ?? GUIDGenerator.generate(),
      face: Face(
        leftBytes: facesLeftBytes,
        rightBytes: facesRightBytes,
        frontBytes: facesFrontBytes,
        leftUrl: person?.face.leftUrl,
        rightUrl: person?.face.rightUrl,
        frontUrl: person?.face.frontUrl,
      ),
    );
    Get.back(result: result);
  }
}
