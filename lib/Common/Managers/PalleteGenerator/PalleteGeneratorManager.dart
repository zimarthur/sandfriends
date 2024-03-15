import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';

import '../../Providers/Environment/EnvironmentProvider.dart';

class PalleteGeneratorManager {
  Future<PalleteColor?> getPallete(
      BuildContext context, String? imageUrl) async {
    if (imageUrl == null) {
      return null;
    }
    PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      Image.network(
        Provider.of<EnvironmentProvider>(context, listen: false).urlBuilder(
          imageUrl,
          isImage: true,
        ),
      ).image,
    );

    return PalleteColor(
        dominantColor: paletteGenerator.dominantColor?.color,
        secondaryColor: paletteGenerator.vibrantColor?.color);
  }
}

class PalleteColor {
  Color? dominantColor;
  Color? secondaryColor;

  PalleteColor({
    required this.dominantColor,
    required this.secondaryColor,
  });
}
