import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Components/SFAvatarStore.dart';
import '../../../../../../Common/Components/SFAvatarUser.dart';
import '../../../../../../Common/Utils/Constants.dart';
import 'package:provider/provider.dart';

import '../../../ViewModel/StoreProvider.dart';
import '../../../ViewModel/MenuProviderQuadras.dart';
import 'SFDrawerPopup.dart';

class SFDrawerUserWidget extends StatefulWidget {
  bool fullSize;
  MenuProviderQuadras menuProvider;

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
              SFAvatarStore(
                height: 75,
                storePhoto: Provider.of<StoreProvider>(context, listen: false)
                    .store
                    ?.logo,
                storeName: Provider.of<StoreProvider>(context, listen: false)
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
                            "Olá, ${Provider.of<StoreProvider>(context, listen: false).loggedEmployee.firstName}!",
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
                        Provider.of<StoreProvider>(context, listen: false)
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
              SFAvatarStore(
                  height: 50,
                  storePhoto: Provider.of<StoreProvider>(context, listen: false)
                      .store
                      ?.logo,
                  storeName: Provider.of<StoreProvider>(context, listen: false)
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
