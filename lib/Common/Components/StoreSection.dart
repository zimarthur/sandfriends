import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Components/SFAvatarStore.dart';
import 'package:sandfriends/Common/Utils/Heros.dart';

import '../../Common/Providers/Environment/EnvironmentProvider.dart';
import '../../Common/Model/Court.dart';
import 'SFLoading.dart';
import '../../Common/Utils/Constants.dart';

class StoreSection extends StatefulWidget {
  final Court court;
  final VoidCallback onTapStore;
  final bool fullAddress;
  const StoreSection({
    Key? key,
    required this.court,
    required this.onTapStore,
    this.fullAddress = true,
  }) : super(key: key);

  @override
  State<StoreSection> createState() => _StoreSectionState();
}

class _StoreSectionState extends State<StoreSection> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (layoutContext, layoutConstraints) {
      double layoutHeight = layoutConstraints.maxHeight;
      return InkWell(
        onTap: () {
          widget.onTapStore();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: layoutHeight * 0.05),
              child: const Text(
                "Local",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Hero(
                      tag: heroStorePhoto,
                      child: SFAvatarStore(
                        height: layoutHeight * 0.65,
                        storeName: widget.court.store!.name,
                        storePhoto: widget.court.store!.logo,
                        enableShadow: true,
                      )),
                  Padding(
                    padding: EdgeInsets.only(
                      right: defaultPadding,
                    ),
                  ),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.court.store!.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: primaryBlue,
                          fontSize: 18,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            r'assets/icon/location_ping.svg',
                            color: primaryBlue,
                            height: 15,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              right: defaultPadding / 2,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              widget.fullAddress
                                  ? widget.court.store!.completeAddress
                                  : widget.court.store!.shortAddress,
                              style: const TextStyle(
                                color: primaryBlue,
                                fontSize: 12,
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.court.description,
                          ),
                          Text(
                            widget.court.isIndoor
                                ? "Quadra Coberta"
                                : "Quadra Descoberta",
                            style: const TextStyle(
                              color: textDarkGrey,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
