import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/Court/View/CourtAvailableCourts.dart';
import 'package:sandfriends/Features/Court/View/CourtContact.dart';
import 'package:sandfriends/Features/Court/View/CourtDescription.dart';
import 'package:sandfriends/Features/Court/View/CourtPhotos.dart';
import 'package:sandfriends/Utils/Heros.dart';

import '../../../SharedComponents/Providers/CategoriesProvider/CategoriesProvider.dart';
import '../../../SharedComponents/View/SFLoading.dart';
import '../../../Utils/Constants.dart';
import '../../../Utils/UrlLauncher.dart';
import '../../../oldApp/widgets/SF_Button.dart';
import '../../MatchSearch/View/AvailableDayCard/AvailableHourCard.dart';
import '../ViewModel/CourtViewModel.dart';
import 'CourtMap.dart';

class CourtWidget extends StatefulWidget {
  CourtViewModel viewModel;
  CourtWidget({
    required this.viewModel,
  });

  @override
  State<CourtWidget> createState() => _CourtWidgetState();
}

class _CourtWidgetState extends State<CourtWidget> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        ListView(
          padding: EdgeInsets.zero,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: height * 0.40,
                  width: width,
                  child: CourtPhotos(
                    selectedPhotoIndex: widget.viewModel.selectedPhotoIndex,
                    onSelectedPhotoChanged: (newIndex) =>
                        widget.viewModel.onSelectedPhotoChanged(newIndex),
                    imagesUrl: widget.viewModel.store.photos,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: height * 0.35,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.05,
                  ),
                  height: height * 0.15,
                  decoration: BoxDecoration(
                    color: secondaryBack,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: height * 0.02),
                    child: SizedBox(
                      height: height * 0.2,
                      child: Row(
                        children: [
                          Hero(
                            tag: heroStorePhoto,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: CachedNetworkImage(
                                imageUrl: widget.viewModel.store.imageUrl,
                                height: height * 0.13,
                                width: height * 0.13,
                                placeholder: (context, url) => Container(
                                  height: height * 0.13,
                                  width: height * 0.13,
                                  child: Center(
                                    child: SFLoading(),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  height: height * 0.13,
                                  width: height * 0.13,
                                  color: textLightGrey.withOpacity(0.5),
                                  child: Center(
                                    child: Icon(Icons.dangerous),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.05),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: height * 0.05,
                                    child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        widget.viewModel.store.name,
                                        style: TextStyle(
                                          color: primaryBlue,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          r'assets\icon\location_ping.svg',
                                          color: primaryBlue,
                                          width: 15,
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                right: width * 0.02)),
                                        Expanded(
                                          child: Text(
                                            "${widget.viewModel.store.completeAddress}",
                                            style: TextStyle(
                                              color: primaryBlue,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (widget.viewModel.courtAvailableHours.isNotEmpty)
              CourtAvailableCourts(
                viewModel: widget.viewModel,
              ),
            Container(
              color: textLightGrey,
              margin: EdgeInsets.symmetric(
                  vertical: height * 0.02, horizontal: width * 0.02),
              height: 1,
            ),
            CourtDescription(
              description: widget.viewModel.store.descriptionText,
            ),
            Padding(
              padding: EdgeInsets.only(top: height * 0.02),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: width * 0.02),
              height: height * 0.2,
              child: CourtMap(
                store: widget.viewModel.store,
              ),
            ),
            CourtContact(
              store: widget.viewModel.store,
            ),
            Container(
              height: height * 0.15,
            )
          ],
        ),
        Positioned(
          left: width * 0.03,
          top: MediaQuery.of(context).padding.top + height * 0.01,
          child: InkWell(
            onTap: () => widget.viewModel.onTapReturn(context),
            child: Container(
              height: width * 0.1,
              width: width * 0.1,
              padding: EdgeInsets.all(width * 0.02),
              decoration:
                  BoxDecoration(color: secondaryBack, shape: BoxShape.circle),
              child: SvgPicture.asset(
                r'assets\icon\arrow_left.svg',
                color: primaryBlue,
              ),
            ),
          ),
        ),
        if (widget.viewModel.courtAvailableHours.isNotEmpty)
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              decoration: BoxDecoration(
                color: secondaryPaper,
                border: Border(
                  top: BorderSide(
                    color: divider,
                    width: 1,
                  ),
                ),
              ),
              height: height * 0.1,
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${widget.viewModel.reservationStartTime!.hourString} - ${Provider.of<CategoriesProvider>(context, listen: false).getHourEnd(
                                widget.viewModel.reservationEndTime!,
                              ).hourString}",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: height * 0.02,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "R\$ ${widget.viewModel.reservationCost!}",
                          style: TextStyle(
                            color: textDarkGrey,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                            fontSize: height * 0.017,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: height * 0.02),
                    child: SFButton(
                        buttonLabel: "Agendar",
                        color: secondaryYellow,
                        textPadding: EdgeInsets.all(width * 0.03),
                        onTap: () =>
                            widget.viewModel.courtReservation(context)),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
