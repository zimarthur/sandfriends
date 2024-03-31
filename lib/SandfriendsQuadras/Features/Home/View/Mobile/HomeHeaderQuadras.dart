import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Managers/PalleteGenerator/PalleteGeneratorManager.dart';

import '../../../../../Common/Components/SFAvatarStore.dart';
import '../../../../../Common/Components/SFAvatarUser.dart';
import '../../../../../Common/Providers/Environment/EnvironmentProvider.dart';
import '../../../../../Common/Utils/Constants.dart';
import '../../../Menu/View/Mobile/SFStandardHeader.dart';
import '../../../Menu/ViewModel/StoreProvider.dart';
import '../../../../../Common/Components/HomeHeader.dart';

class HomeHeaderQuadras extends StatefulWidget {
  HomeHeaderQuadras({super.key});

  @override
  State<HomeHeaderQuadras> createState() => _HomeHeaderQuadrasState();
}

class _HomeHeaderQuadrasState extends State<HomeHeaderQuadras> {
  double imageSize = 100.0;
  Color dominantColor = secondaryBack;
  Color secondColor = secondaryBack;

  double buttonSize = 20;
  @override
  void initState() {
    getPallete();
    super.initState();
  }

  void getPallete() {
    PalleteGeneratorManager()
        .getPallete(
      context,
      Provider.of<StoreProvider>(context, listen: false).store?.logo,
    )
        .then((colors) {
      if (mounted && colors != null) {
        setState(() {
          if (colors.dominantColor != null) {
            dominantColor = colors.dominantColor!;
          }
          if (colors.secondaryColor != null) {
            secondColor = colors.secondaryColor!;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return HomeHeader(
      name: Provider.of<StoreProvider>(context, listen: false)
          .loggedEmployee
          .firstName,
      nameDescription:
          Provider.of<StoreProvider>(context, listen: false).store!.name,
      notificationsOn: Provider.of<StoreProvider>(
        context,
      ).hasUnseenNotifications,
      primaryColor: dominantColor,
      secondaryColor: secondColor,
      photo: Provider.of<StoreProvider>(context, listen: false).store?.logo,
      photoName: Provider.of<StoreProvider>(context, listen: false).store?.name,
    );
  }
}
