import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
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
    double width = MediaQuery.of(context).size.width;
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
                ),
                textScaleFactor: 1.3,
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Hero(
                    tag: heroStorePhoto,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: CachedNetworkImage(
                        imageUrl: Provider.of<EnvironmentProvider>(context,
                                listen: false)
                            .urlBuilder(widget.court.store!.logo!),
                        height: layoutHeight * 0.65,
                        width: layoutHeight * 0.65,
                        placeholder: (context, url) => SizedBox(
                          height: layoutHeight * 0.65,
                          width: layoutHeight * 0.65,
                          child: Center(
                            child: SFLoading(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: textLightGrey.withOpacity(0.5),
                          height: layoutHeight * 0.65,
                          width: layoutHeight * 0.65,
                          child: const Center(
                            child: Icon(Icons.dangerous),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(right: width * 0.05)),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.court.store!.name,
                        textScaleFactor: 1.2,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, color: primaryBlue),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            r'assets/icon/location_ping.svg',
                            color: primaryBlue,
                            width: 15,
                          ),
                          Padding(
                              padding: EdgeInsets.only(right: width * 0.02)),
                          Expanded(
                            child: Text(
                              widget.fullAddress
                                  ? widget.court.store!.completeAddress
                                  : widget.court.store!.shortAddress,
                              style: const TextStyle(
                                color: primaryBlue,
                                fontSize: 12,
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
                            textScaleFactor: 0.8,
                            style: const TextStyle(color: textDarkGrey),
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