import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/Utils/Heros.dart';

import '../../../SharedComponents/View/SFLoading.dart';
import '../../../Utils/Constants.dart';
import '../ViewModel/MatchViewModel.dart';

class StoreSection extends StatefulWidget {
  MatchViewModel viewModel;
  StoreSection({
    required this.viewModel,
  });

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
          widget.viewModel.onTapStore(context);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: layoutHeight * 0.15,
              margin: EdgeInsets.only(top: layoutHeight * 0.05),
              child: const FittedBox(
                fit: BoxFit.fitHeight,
                child: Text(
                  "Local",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
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
                        imageUrl: widget.viewModel.match.court.store!.imageUrl,
                        height: layoutHeight * 0.65,
                        width: layoutHeight * 0.65,
                        placeholder: (context, url) => Container(
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
                          child: Center(
                            child: Icon(Icons.dangerous),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(right: width * 0.1)),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.viewModel.match.court.store!.name,
                        textScaleFactor: 1.5,
                        style: TextStyle(
                            fontWeight: FontWeight.w700, color: primaryBlue),
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            r'assets\icon\location_ping.svg',
                            color: primaryBlue,
                            width: 15,
                          ),
                          Padding(
                              padding: EdgeInsets.only(right: width * 0.02)),
                          Expanded(
                            child: Text(
                              widget
                                  .viewModel.match.court.store!.completeAddress,
                              style: TextStyle(
                                color: primaryBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.viewModel.match.court.storeCourtName,
                          ),
                          Text(
                            widget.viewModel.match.court.isIndoor
                                ? "Quadra Coberta"
                                : "Quadra Descoberta",
                            textScaleFactor: 0.8,
                            style: TextStyle(color: textDarkGrey),
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
