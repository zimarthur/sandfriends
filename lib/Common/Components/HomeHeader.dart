import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Managers/PalleteGenerator/PalleteGeneratorManager.dart';

import '../../../Common/Components/SFAvatarStore.dart';
import '../../../Common/Components/SFAvatarUser.dart';
import '../../../Common/Providers/Environment/EnvironmentProvider.dart';
import '../../../Common/Utils/Constants.dart';
import '../../SandfriendsQuadras/Features/Menu/View/Mobile/SFStandardHeader.dart';

class HomeHeader extends StatefulWidget {
  Color primaryColor;
  Color secondaryColor;
  String name;
  String? nameDescription;
  bool notificationsOn;
  String? photo;
  String? photoName;
  HomeHeader(
      {required this.primaryColor,
      required this.secondaryColor,
      required this.name,
      required this.nameDescription,
      required this.notificationsOn,
      required this.photo,
      required this.photoName,
      super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  double imageSize = 100.0;

  double buttonSize = 20;

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
                        "Olá, ${widget.name}!",
                        style: TextStyle(color: textWhite, fontSize: 16),
                      ),
                      if (widget.nameDescription != null)
                        Padding(
                          padding:
                              const EdgeInsets.only(top: defaultPadding / 6),
                          child: Text(
                            widget.nameDescription!,
                            style:
                                TextStyle(color: textLightGrey, fontSize: 12),
                          ),
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
                      widget.notificationsOn
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
                      color: widget.secondaryColor,
                      boxShadow: [
                        BoxShadow(
                          color: widget.secondaryColor,
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
                  storePhoto: widget.photo,
                  storeName: widget.photoName,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
