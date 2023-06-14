import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';

class FaceDetectorUtils {
  static Future<Face?> detectFace(XFile imageFile) async {
    final faceDetector = FaceDetector(
      options: FaceDetectorOptions(performanceMode: FaceDetectorMode.accurate, enableClassification: true),
    );

    final InputImage inputImage = InputImage.fromFilePath(imageFile.path);

    List<Face> faces = await faceDetector.processImage(inputImage);

    faceDetector.close();

    if (faces.isEmpty) return null;

    faces.sort(
      ((a, b) {
        return (a.boundingBox.width * a.boundingBox.height).compareTo(b.boundingBox.width * b.boundingBox.height);
      }),
    );

    return faces.last;
  }

  static Future<Uint8List> cropFaceAsync(Uint8List imageBytes, Face face, double size) async {
    // Calculate The Face Bounding Square
    final faceRect = face.boundingBox;
    final faceSquare = ui.Rect.fromLTWH(
      faceRect.left - (faceRect.height > faceRect.width ? (faceRect.height - faceRect.width) / 2 : 0),
      faceRect.top - (faceRect.width > faceRect.height ? (faceRect.width - faceRect.height) / 2 : 0),
      math.max(faceRect.width, faceRect.height),
      math.max(faceRect.width, faceRect.height),
    );

    final pictureRecorder = ui.PictureRecorder();
    final canvas = ui.Canvas(pictureRecorder);

    // Crop Face Square From The Original Photo
    final originalImage = await decodeImageFromList(imageBytes);
    canvas.drawImageRect(originalImage, faceSquare, ui.Rect.fromLTWH(0, 0, size, size), ui.Paint());
    originalImage.dispose();

    final croppedFaceImage = await pictureRecorder.endRecording().toImage(size.toInt(), size.toInt());
    final pngByteData = await croppedFaceImage.toByteData(format: ui.ImageByteFormat.png);
    croppedFaceImage.dispose();

    return pngByteData!.buffer.asUint8List();
  }
}
