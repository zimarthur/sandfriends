import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Components/SFAvatarStore.dart';
import 'package:sandfriends/Common/Managers/LinkOpener/LinkOpenerManager.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';
import 'package:sandfriends/SandfriendsQuadras/Features/Menu/View/Web/DrawerWeb/SFDrawerListTile.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/Authentication/ProfileOverlay/View/ProfileOverlay.dart';
import '../../../../../../Common/Components/SFAvatarUser.dart';
import '../../../../../../Common/Utils/Constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../Authentication/ProfileOverlay/View/User.dart';

class SandfriendsWebDrawer extends StatefulWidget {
  VoidCallback onTapLogin;
  VoidCallback onTapProfile;
  VoidCallback onTapMatches;
  SandfriendsWebDrawer({
    required this.onTapLogin,
    required this.onTapProfile,
    required this.onTapMatches,
    super.key,
  });

  @override
  State<SandfriendsWebDrawer> createState() => _SandfriendsWebDrawerState();
}

class _SandfriendsWebDrawerState extends State<SandfriendsWebDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: textWhite,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              color: primaryBlue,
              padding: EdgeInsets.only(bottom: defaultBorderRadius),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(defaultBorderRadius),
                      bottomRight: Radius.circular(
                        defaultBorderRadius,
                      ),
                    ),
                    color: textWhite,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: defaultPadding,
                      vertical: defaultPadding,
                    ),
                    child: Provider.of<UserProvider>(context).user == null
                        ? Row(
                            children: [
                              SvgPicture.asset(
                                r"assets/icon/user.svg",
                                color: primaryBlue,
                                height: 80,
                              ),
                              SizedBox(
                                width: defaultPadding / 2,
                              ),
                              InkWell(
                                onTap: () => widget.onTapLogin(),
                                child: Expanded(
                                  child: Text(
                                    "Entre ou cadastre-se",
                                    style: TextStyle(
                                      color: primaryBlue,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              SFAvatarUser(
                                  height: 100,
                                  user:
                                      Provider.of<UserProvider>(context).user!,
                                  showRank: false),
                              SizedBox(
                                width: defaultPadding / 2,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Olá, ${Provider.of<UserProvider>(context).user!.firstName}",
                                      style: TextStyle(
                                        color: primaryBlue,
                                      ),
                                    ),
                                    SizedBox(
                                      height: defaultPadding / 2,
                                    ),
                                    Text(
                                      "Como podemos ajudar hoje?",
                                      style: TextStyle(
                                        color: textDarkGrey,
                                        fontSize: 12,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: primaryBlue,
                padding: EdgeInsets.all(
                  defaultPadding,
                ),
                child: Column(
                  children: [
                    Expanded(
                        child: Column(
                      children: [
                        if (Provider.of<UserProvider>(context).user !=
                            null) ...[
                          InkWell(
                            onTap: () => widget.onTapProfile(),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  r"assets/icon/user.svg",
                                  color: textWhite,
                                ),
                                SizedBox(
                                  width: defaultPadding / 2,
                                ),
                                Text(
                                  "Meu perfil",
                                  style: TextStyle(
                                    color: textWhite,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: defaultPadding,
                          ),
                          InkWell(
                            onTap: () => widget.onTapMatches(),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  r"assets/icon/court.svg",
                                  color: textWhite,
                                ),
                                SizedBox(
                                  width: defaultPadding / 2,
                                ),
                                Text(
                                  "Minhas partidas",
                                  style: TextStyle(
                                    color: textWhite,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]
                      ],
                    )),
                    InkWell(
                      onTap: () =>
                          LinkOpenerManager().openSandfriendsWhatsApp(context),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            r"assets/icon/whatsapp.svg",
                            height: 30,
                            color: textWhite,
                          ),
                          SizedBox(
                            width: defaultPadding / 2,
                          ),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Alguma dúvida ou problema?",
                                style: TextStyle(
                                  color: textWhite,
                                ),
                              ),
                              Text(
                                "Nos chame no whats",
                                style: TextStyle(
                                  color: textLightGrey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: defaultPadding,
                    ),
                    InkWell(
                      onTap: () =>
                          LinkOpenerManager().openSandfriendsInstagram(context),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            r"assets/icon/instagram.svg",
                            height: 30,
                            color: textWhite,
                          ),
                          SizedBox(
                            width: defaultPadding / 2,
                          ),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Siga o Sandfriends no Instagra",
                                style: TextStyle(
                                  color: textWhite,
                                ),
                              ),
                              Text(
                                "@sandfriends.app",
                                style: TextStyle(
                                  color: textLightGrey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: defaultPadding,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Image.asset(
                        r"assets/full_logo_negative_284.png",
                        height: 100,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
