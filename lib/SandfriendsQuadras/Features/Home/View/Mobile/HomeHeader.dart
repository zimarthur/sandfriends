import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';

import '../../../../../Common/Components/SFAvatarStore.dart';
import '../../../../../Common/Components/SFAvatarUser.dart';
import '../../../../../Common/Providers/Environment/EnvironmentProvider.dart';
import '../../../../../Common/Utils/Constants.dart';
import '../../../Menu/View/Mobile/SFStandardHeader.dart';
import '../../../Menu/ViewModel/DataProvider.dart';

class HomeHeader extends StatefulWidget {
  HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  double imageSize = 100.0;
  late PaletteGenerator paletteGenerator;
  Color dominantColor = secondaryBack;
  Color secondColor = secondaryBack;

  double buttonSize = 20;
  @override
  void initState() {
    _updatePaletteGenerator();
    super.initState();
  }

  Future<void> _updatePaletteGenerator() async {
    if (Provider.of<DataProvider>(context, listen: false).store != null &&
        Provider.of<DataProvider>(context, listen: false).store!.logo != null) {
      paletteGenerator = await PaletteGenerator.fromImageProvider(
        Image.network(
          Provider.of<EnvironmentProvider>(context, listen: false).urlBuilder(
            Provider.of<DataProvider>(context, listen: false).store!.logo!,
            isImage: true,
          ),
        ).image,
      );
      if (paletteGenerator.dominantColor != null) {
        if (mounted) {
          setState(() {
            dominantColor = paletteGenerator.dominantColor!.color;
            if (paletteGenerator.vibrantColor != null) {
              secondColor = paletteGenerator.vibrantColor!.color;
            }
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: secondaryBack,
      child: Column(
        children: [
          SFStandardHeader(
            widget: Row(
              children: [
                SizedBox(
                  width: 2 * defaultPadding,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Olá, ${Provider.of<DataProvider>(context, listen: false).loggedEmployee.firstName}!",
                        style: TextStyle(color: textWhite, fontSize: 16),
                      ),
                      SizedBox(
                        height: defaultPadding / 6,
                      ),
                      Text(
                        Provider.of<DataProvider>(context, listen: false)
                            .store!
                            .name,
                        style: TextStyle(color: textLightGrey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.pushNamed(
                    context,
                    "/notifications",
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: SvgPicture.asset(
                      Provider.of<DataProvider>(
                        context,
                      ).hasUnseenNotifications
                          ? r"assets/icon/notification_on.svg"
                          : r"assets/icon/notification_off.svg",
                      height: buttonSize,
                    ),
                  ),
                ),
                SizedBox(
                  width: defaultPadding,
                ),
              ],
            ),
          ),
          Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: imageSize / 2.5,
                    color: primaryBlue,
                  ),
                  Container(
                    height: imageSize / 8,
                    decoration: BoxDecoration(
                      color: dominantColor,
                      boxShadow: [
                        BoxShadow(
                          color: secondColor,
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                height: imageSize,
                margin: EdgeInsets.only(
                  left: 2 * defaultPadding,
                ),
                child: SFAvatarStore(
                  height: imageSize,
                  storePhoto: Provider.of<DataProvider>(context, listen: false)
                      .store
                      ?.logo,
                  storeName: Provider.of<DataProvider>(context, listen: false)
                      .store!
                      .name,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
