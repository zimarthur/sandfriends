import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Components/SFAvatarStore.dart';
import '../../../../../../Common/Components/SFAvatarUser.dart';
import '../../../../../../Common/Utils/Constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../ViewModel/DataProvider.dart';
import '../../../ViewModel/MenuProvider.dart';
import '../../Web/DrawerWeb/SFDrawerListTile.dart';
import 'package:provider/provider.dart';

class SFDrawerMobile extends StatefulWidget {
  MenuProvider viewModel;
  SFDrawerMobile({
    required this.viewModel,
  });

  @override
  State<SFDrawerMobile> createState() => _SFDrawerMobileState();
}

class _SFDrawerMobileState extends State<SFDrawerMobile> {
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
                                storePhoto: Provider.of<DataProvider>(context,
                                        listen: false)
                                    .store
                                    ?.logo,
                                storeName: Provider.of<DataProvider>(context,
                                        listen: false)
                                    .store!
                                    .name),
                            SizedBox(
                              height: defaultPadding / 4,
                            ),
                            Text(
                              Provider.of<DataProvider>(context, listen: false)
                                      .store
                                      ?.name ??
                                  "",
                              style: TextStyle(
                                color: textBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              Provider.of<DataProvider>(context, listen: false)
                                  .loggedEmployee
                                  .fullName,
                              style: TextStyle(
                                color: textDarkGrey,
                              ),
                            )
                          ],
                        )),
                        InkWell(
                          onTap: () =>
                              widget.viewModel.quickLinkSettingMobile(context),
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
                          print("drawer mobile");
                          print(
                              widget.viewModel.mobileDrawerItems[index].title);
                          print(
                              widget.viewModel.mobileDrawerItems[index].isNew);
                          return InkWell(
                            onTap: () {
                              widget.viewModel.onTabClick(
                                  widget.viewModel.mobileDrawerItems[index],
                                  context);
                            },
                            onHover: (value) {
                              widget.viewModel.setHoveredDrawerTitle(value
                                  ? widget
                                      .viewModel.mobileDrawerItems[index].title
                                  : "");
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
                              isHovered: widget.viewModel.hoveredDrawerTitle ==
                                  widget
                                      .viewModel.mobileDrawerItems[index].title,
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
                        r"assets/full_logo_negative_284_courts.png",
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
