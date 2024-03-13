import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Features/Court/View/Mobile/CourtContact.dart';
import 'package:sandfriends/Common/Features/Court/View/Mobile/CourtDescription.dart';
import 'package:sandfriends/Common/Features/Court/View/Mobile/CourtPhotos.dart';
import 'package:sandfriends/Common/Features/Court/View/CourtReservationSection.dart';
import 'package:sandfriends/Common/Model/Court.dart';
import 'package:sandfriends/Common/Utils/TypeExtensions.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../Components/SFButton.dart';
import '../../../../Providers/Environment/EnvironmentProvider.dart';
import '../../../../Providers/Categories/CategoriesProvider.dart';
import '../../../../Components/SFLoading.dart';
import '../../../../StandardScreen/StandardScreenViewModel.dart';
import '../../../../Utils/Constants.dart';
import '../../ViewModel/CourtViewModel.dart';
import 'CourtMap.dart';

class CourtWidgetMobile extends StatefulWidget {
  final CourtViewModel viewModel;
  const CourtWidgetMobile({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  State<CourtWidgetMobile> createState() => _CourtWidgetMobileState();
}

class _CourtWidgetMobileState extends State<CourtWidgetMobile> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Color themeColor =
        !widget.viewModel.canMakeReservation || !widget.viewModel.isRecurrent!
            ? primaryBlue
            : primaryLightBlue;
    return widget.viewModel.store == null
        ? Center(child: SFLoading())
        : Stack(
            children: [
              ListView(
                padding: EdgeInsets.zero,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: width * 0.7,
                        width: width,
                        child: CourtPhotos(
                          selectedPhotoIndex:
                              widget.viewModel.selectedPhotoIndex,
                          onSelectedPhotoChanged: (newIndex) =>
                              widget.viewModel.onSelectedPhotoChanged(newIndex),
                          imagesUrl: widget.viewModel.store!.photos,
                          themeColor: themeColor,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: width * 0.7 - 2 * defaultPadding,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.05,
                        ),
                        height: height * 0.15,
                        decoration: const BoxDecoration(
                          color: secondaryBack,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(2 * defaultPadding),
                            topRight: Radius.circular(2 * defaultPadding),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top: height * 0.02),
                          child: SizedBox(
                            height: height * 0.2,
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16.0),
                                  child: CachedNetworkImage(
                                    imageUrl: Provider.of<EnvironmentProvider>(
                                            context,
                                            listen: false)
                                        .urlBuilder(
                                      widget.viewModel.store!.logo!,
                                      isImage: true,
                                    ),
                                    height: height * 0.13,
                                    width: height * 0.13,
                                    placeholder: (context, url) => SizedBox(
                                      height: height * 0.13,
                                      width: height * 0.13,
                                      child: Center(
                                        child: SFLoading(),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      height: height * 0.13,
                                      width: height * 0.13,
                                      color: textLightGrey.withOpacity(0.5),
                                      child: const Center(
                                        child: Icon(Icons.dangerous),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: height * 0.05,
                                          child: FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Text(
                                              widget.viewModel.store!.name,
                                              style: TextStyle(
                                                color: themeColor,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              launchUrl(Uri.parse(
                                                  "https://maps.google.com/maps?q=${widget.viewModel.store!.latitude},${widget.viewModel.store!.longitude}"));
                                            },
                                            child: Center(
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SvgPicture.asset(
                                                    r'assets/icon/location_ping.svg',
                                                    color: themeColor,
                                                    width: 15,
                                                  ),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          right: width * 0.02)),
                                                  Expanded(
                                                    child: Text(
                                                      widget.viewModel.store!
                                                          .completeAddress,
                                                      style: TextStyle(
                                                        color: themeColor,
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
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (widget.viewModel.canMakeReservation)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                      child: CourtReservationSection(
                        viewModel: widget.viewModel,
                        themeColor: themeColor,
                      ),
                    ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  CourtDescription(
                    description: widget.viewModel.store!.description,
                    themeColor: themeColor,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: height * 0.02),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                    height: height * 0.2,
                    child: CourtMap(
                      store: widget.viewModel.store!,
                    ),
                  ),
                  CourtContact(
                    store: widget.viewModel.store!,
                    themeColor: themeColor,
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
                  onTap: () => Provider.of<StandardScreenViewModel>(context,
                          listen: false)
                      .onTapReturn(context),
                  child: Container(
                    height: width * 0.1,
                    width: width * 0.1,
                    padding: EdgeInsets.all(width * 0.02),
                    decoration: const BoxDecoration(
                        color: secondaryBack, shape: BoxShape.circle),
                    child: SvgPicture.asset(
                      r'assets/icon/arrow_left.svg',
                      color: themeColor,
                    ),
                  ),
                ),
              ),
              if (widget.viewModel.selectedHourPrices.isNotEmpty)
                Positioned(
                  bottom: MediaQuery.of(context).padding.bottom,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                    decoration: const BoxDecoration(
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
                                "${widget.viewModel.reservationCost!.formatPrice()}",
                                style: TextStyle(
                                  color: textDarkGrey,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                  fontSize: height * 0.017,
                                  decorationColor: textDarkGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: height * 0.02),
                          child: SFButton(
                              buttonLabel: "Escolher pagamento",
                              color: secondaryYellow,
                              textPadding: EdgeInsets.all(width * 0.03),
                              onTap: () {
                                Court checkoutCourt = Court.copyFrom(
                                  widget.viewModel.selectedCourt!,
                                );
                                checkoutCourt.store = widget.viewModel.store;
                                Provider.of<StandardScreenViewModel>(context,
                                        listen: false)
                                    .setLoading();
                                print(checkoutCourt);
                                print(widget.viewModel.selectedHourPrices);
                                print(widget.viewModel.selectedSport);
                                print(widget.viewModel.selectedDate);
                                print(widget.viewModel.selectedWeekday);
                                print(widget.viewModel.isRecurrent);

                                Navigator.pushNamed(
                                  context,
                                  "/checkout",
                                  arguments: {
                                    'court': checkoutCourt,
                                    'hourPrices':
                                        widget.viewModel.selectedHourPrices,
                                    'sport': widget.viewModel.selectedSport,
                                    'date': widget.viewModel.selectedDate,
                                    'weekday': widget.viewModel.selectedWeekday,
                                    'isRecurrent': widget.viewModel.isRecurrent,
                                    'isRenovating': false,
                                  },
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
  }
}
