import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Components/SFAvatarStore.dart';
import 'package:sandfriends/Common/Providers/Drawer/DrawerProvider.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';
import 'package:sandfriends/SandfriendsAulas/Providers/MenuProviderAulas.dart';
import '../../../../../Common/Components/SFAvatarUser.dart';
import '../../../../../Common/Utils/Constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../SandfriendsQuadras/Features/Menu/View/Web/DrawerWeb/SFDrawerListTile.dart';

class SFDrawerAulas extends StatefulWidget {
  MenuProviderAulas viewModel;
  SFDrawerAulas({
    required this.viewModel,
    super.key,
  });

  @override
  State<SFDrawerAulas> createState() => _SFDrawerAulasState();
}

class _SFDrawerAulasState extends State<SFDrawerAulas> {
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
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SFAvatarStore(
                              height: 100,
                              storePhoto: Provider.of<UserProvider>(context,
                                      listen: false)
                                  .user
                                  ?.photo,
                              storeName: Provider.of<UserProvider>(context,
                                      listen: false)
                                  .user!
                                  .fullName,
                            ),
                            SizedBox(
                              height: defaultPadding / 4,
                            ),
                            Text(
                              Provider.of<UserProvider>(context, listen: false)
                                      .user
                                      ?.fullName ??
                                  "",
                              style: TextStyle(
                                color: textBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        )),
                        InkWell(
                          onTap: () =>
                              Navigator.pushNamed(context, "/settings"),
                          child: SvgPicture.asset(
                            r"assets/icon/settings.svg",
                            height: 25,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: primaryBlue,
                padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding / 2,
                  vertical: defaultPadding,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.viewModel.mobileDrawerItems.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              widget.viewModel.onTabClick(
                                  widget.viewModel.mobileDrawerItems[index]
                                      .drawerPage,
                                  context);
                            },
                            child: SFDrawerListTile(
                              title: widget
                                  .viewModel.mobileDrawerItems[index].title,
                              svgSrc: widget
                                  .viewModel.mobileDrawerItems[index].icon,
                              isSelected:
                                  widget.viewModel.mobileDrawerItems[index] ==
                                      widget.viewModel.selectedDrawerItem,
                              fullSize: true,
                              isHovered: false,
                              isNew: widget
                                  .viewModel.mobileDrawerItems[index].isNew,
                            ),
                          );
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Image.asset(
                        r"assets/full_logo_negative_284_aulas.png",
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
