import 'package:flutter/material.dart';
import 'package:sandfriends_web/Features/Menu/View/Web/DrawerWeb/SFDrawerPopup.dart';
import 'package:sandfriends_web/Features/Menu/ViewModel/DataProvider.dart';
import 'package:sandfriends_web/Features/Menu/ViewModel/MenuProvider.dart';
import 'package:sandfriends_web/SharedComponents/View/SFAvatar.dart';
import 'package:sandfriends_web/Utils/Constants.dart';
import 'package:provider/provider.dart';

class SFDrawerUserWidget extends StatefulWidget {
  bool fullSize;
  MenuProvider menuProvider;

  SFDrawerUserWidget({
    required this.fullSize,
    required this.menuProvider,
  });

  @override
  State<SFDrawerUserWidget> createState() => _SFDrawerUserWidgetState();
}

class _SFDrawerUserWidgetState extends State<SFDrawerUserWidget> {
  bool isOnHover = false;
  @override
  Widget build(BuildContext context) {
    return widget.fullSize
        ? Row(
            children: [
              SFAvatar(
                height: 75,
                image:
                    Provider.of<DataProvider>(context, listen: false).store ==
                            null
                        ? null
                        : Provider.of<DataProvider>(context, listen: false)
                            .store!
                            .logo,
                storeName: Provider.of<DataProvider>(context, listen: false)
                    .store!
                    .name,
              ),
              const SizedBox(
                width: defaultPadding,
              ),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Olá, ${Provider.of<DataProvider>(context, listen: false).loggedEmployee.firstName}!",
                            style: TextStyle(
                              color: textWhite,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          onHover: (value) {
                            setState(() {
                              if (value == true) {
                                isOnHover = true;
                              } else {
                                isOnHover = false;
                              }
                            });
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: isOnHover
                                  ? primaryDarkBlue.withOpacity(0.3)
                                  : primaryBlue,
                              borderRadius: BorderRadius.circular(
                                defaultBorderRadius,
                              ),
                            ),
                            child: SFDrawerPopup(
                              showIcon: true,
                              menuProvider: widget.menuProvider,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        Provider.of<DataProvider>(context, listen: false)
                            .store!
                            .name,
                        style: TextStyle(
                          color: textLightGrey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        : Stack(
            children: [
              SFAvatar(
                  height: 50,
                  image:
                      Provider.of<DataProvider>(context, listen: false).store ==
                              null
                          ? null
                          : Provider.of<DataProvider>(context, listen: false)
                              .store!
                              .logo,
                  storeName: Provider.of<DataProvider>(context, listen: false)
                      .store!
                      .name),
              InkWell(
                onTap: () {},
                onHover: (value) {
                  setState(() {
                    if (value == true) {
                      isOnHover = true;
                    } else {
                      isOnHover = false;
                    }
                  });
                },
                child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(defaultBorderRadius),
                      color: isOnHover
                          ? textDarkGrey.withOpacity(0.8)
                          : Colors.transparent,
                    ),
                    child: SFDrawerPopup(
                      showIcon: isOnHover,
                      menuProvider: widget.menuProvider,
                    )),
              ),
            ],
          );
  }
}
