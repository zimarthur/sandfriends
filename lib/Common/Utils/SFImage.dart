import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_cropper_platform_interface/src/models/settings.dart';
import 'package:image/image.dart' as IMG;
import 'package:flutter/services.dart';

Future<Uint8List?> selectImage(
  BuildContext context,
  double desiredAspectRatio,
) async {
  double windowHeigth = MediaQuery.of(context).size.height * 0.8;
  double availableHeight = windowHeigth - 150;
  double windowWidth = MediaQuery.of(context).size.width * 0.5;
  double availableWidth = windowWidth - 30;

  XFile? image = await ImagePicker().pickImage(
    source: ImageSource.gallery,
    imageQuality: 100,
    maxHeight: availableHeight,
    maxWidth: availableWidth,
  );
  if (image == null) return null;

  IMG.Image? decodedImage = IMG.decodeImage(await image.readAsBytes());
  if (decodedImage == null) return null;
  int cropHeight = 0;
  int cropWidth = 0;
  final imageAspectRatio = decodedImage.width / decodedImage.height;

  if (desiredAspectRatio >= imageAspectRatio) {
    cropWidth = decodedImage.width;
    cropHeight = (cropWidth / desiredAspectRatio).toInt();
  } else {
    cropHeight = decodedImage.height;
    cropWidth = (cropHeight * desiredAspectRatio).toInt();
  }

  CroppedFile? croppedFile = await ImageCropper().cropImage(
    sourcePath: image.path,
    uiSettings: [
      WebUiSettings(
        context: context,
        enableZoom: true,
        enableOrientation: false,
        enableExif: false,
        viewPort: CroppieViewPort(
          type: desiredAspectRatio == 1 ? 'square' : null,
          height: cropHeight,
          width: cropWidth,
        ),
        boundary: CroppieBoundary(
          height: availableHeight.toInt(),
          width: availableWidth.toInt(),
        ),
        translations: const WebTranslations(
          title: "Redimensione sua foto",
          cancelButton: "Cancelar",
          cropButton: "Ok",
          rotateLeftTooltip: "",
          rotateRightTooltip: "",
        ),
      ),
    ],
    compressQuality: 100,
  );
  if (croppedFile == null) return null;
  return await croppedFile.readAsBytes();
}
