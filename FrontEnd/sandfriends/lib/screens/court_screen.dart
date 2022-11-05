import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/models/enums.dart';
import 'package:sandfriends/models/store_day.dart';
import 'package:sandfriends/providers/redirect_provider.dart';
import 'package:sandfriends/theme/app_theme.dart';
import 'package:sandfriends/widgets/Modal/SF_Modal.dart';
import 'package:sandfriends/widgets/Modal/SF_ModalMessage.dart';
import 'package:sandfriends/widgets/SF_Button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import '../models/court_available_hours.dart';
import '../models/court.dart';
import '../providers/match_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/SFLoading.dart';
import '../widgets/SF_AvailableHours.dart';

class CourtScreen extends StatefulWidget {
  const CourtScreen({
    this.param,
    required this.returnTo,
    this.returnToParam,
    this.returnToParamValue,
  });
  final String? param;
  final String returnTo;
  final String? returnToParam;
  final String? returnToParamValue;

  @override
  State<CourtScreen> createState() => _CourtScreenState();
}

class _CourtScreenState extends State<CourtScreen> {
  bool isLoading = true;
  bool showModal = false;
  Widget? modalWidget;
  bool viewOnly = true;
  final ScrollController _controller = ScrollController();

  //List<Court> availableCourts = [];

  void _onScrollEvent() {
    if (_controller.position.pixels.toInt() %
            (MediaQuery.of(context).size.width).toInt() ==
        0) {
      Provider.of<MatchProvider>(context, listen: false).indexCurrentPhoto =
          (_controller.position.pixels ~/ (MediaQuery.of(context).size.width))
              .round();
    }
  }

  GoogleMapController? mapController; //contrller for Google map
  Set<Marker> markers = {}; //markers for google map
  LatLng? showLocation;

  @override
  void initState() {
    _controller.addListener(_onScrollEvent);
    if (widget.param == 'viewOnly') {
      viewOnly = true;
    } else {
      viewOnly = false;
    }
    showLocation = LatLng(
        double.parse(Provider.of<MatchProvider>(context, listen: false)
            .selectedStoreDay!
            .store
            .latitude),
        double.parse(Provider.of<MatchProvider>(context, listen: false)
            .selectedStoreDay!
            .store
            .longitude));
    markers.add(Marker(
      //add marker on google map
      markerId: MarkerId(showLocation.toString()),
      position: showLocation!, //position of marker
      infoWindow: InfoWindow(
        //popup info
        title: Provider.of<MatchProvider>(context, listen: false)
            .selectedStoreDay!
            .store
            .name,
      ),
      icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    ));
    super.initState();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onScrollEvent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    // if (viewOnly == false) {
    //   availableCourts.clear();

    //   StoreDay selectedStoreDay =
    //       Provider.of<MatchProvider>(context, listen: false).selectedStoreDay!;
    //   int selectedTime = Provider.of<MatchProvider>(context, listen: false)
    //       .selectedTime
    //       .first
    //       .hourIndex;
    //   bool newHour = false;
    //   int lastAvailableHour = -1;
    //   int hourIndexPace;

    //   List<CourtAvailableHours> availableHoursList = [];

    //   for (int courtIndex = 0;
    //       courtIndex < selectedStoreDay.courts.length;
    //       courtIndex++) {
    //     lastAvailableHour = -1;
    //     for (int hourIndex = 0;
    //         hourIndex <
    //             selectedStoreDay.courts[courtIndex].availableHours.length;
    //         hourIndex++) {
    //       if (selectedStoreDay
    //               .courts[courtIndex].availableHours[hourIndex].hourIndex ==
    //           selectedTime) {
    //         lastAvailableHour = selectedTime;
    //         newHour = true;
    //       } else if (selectedStoreDay
    //               .courts[courtIndex].availableHours[hourIndex].hourIndex >
    //           selectedTime) {
    //         if (selectedStoreDay.courts[courtIndex].availableHours[hourIndex]
    //                     .hourIndex -
    //                 lastAvailableHour ==
    //             1) {
    //           lastAvailableHour = selectedStoreDay
    //               .courts[courtIndex].availableHours[hourIndex].hourIndex;
    //           newHour = true;
    //         }
    //       }
    //       if (newHour) {
    //         newHour = false;
    //         availableHoursList.add(CourtAvailableHours(
    //             selectedStoreDay
    //                 .courts[courtIndex].availableHours[hourIndex].hour,
    //             selectedStoreDay
    //                 .courts[courtIndex].availableHours[hourIndex].hourIndex,
    //             selectedStoreDay
    //                 .courts[courtIndex].availableHours[hourIndex].hourFinish,
    //             selectedStoreDay
    //                 .courts[courtIndex].availableHours[hourIndex].price));
    //       }
    //     }
    //     if (availableHoursList.isNotEmpty) {
    //       Court newCourt = Court(
    //         store: selectedStoreDay.store,
    //         idStoreCourt: selectedStoreDay.courts[courtIndex].idStoreCourt,
    //         storeCourtName: selectedStoreDay.courts[courtIndex].storeCourtName,
    //         isIndoor: selectedStoreDay.courts[courtIndex].isIndoor,
    //       );
    //       newCourt.availableHours = List.from(availableHoursList);
    //       availableCourts.add(newCourt);
    //       availableHoursList.clear();
    //     }
    //   }
    // }

    return WillPopScope(
      onWillPop: () async {
        if (widget.returnToParam == null) {
          context.goNamed(
            widget.returnTo,
          );
        } else {
          String returnTo;
          String returnToParam;
          String returnToParamValue;
          if (Provider.of<Redirect>(context, listen: false).originalPage ==
              EnumReturnPages.MatchSearchScreen) {
            returnTo = 'match_search_screen';
            returnToParam = 'null';
            returnToParamValue = 'null';
          } else {
            returnTo = 'home';
            returnToParam = 'initialPage';
            returnToParamValue = 'feed_screen';
          }
          context.goNamed(widget.returnTo, params: {
            widget.returnToParam!: widget.returnToParamValue!,
            'returnTo': returnTo,
            'returnToParam': returnToParam,
            'returnToParamValue': returnToParamValue
          });
        }

        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            ListView(
              padding: EdgeInsets.zero,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: height * 0.40,
                      width: width,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          ListView.builder(
                            controller: _controller,
                            scrollDirection: Axis.horizontal,
                            physics: const PageScrollPhysics(),
                            itemCount: Provider.of<MatchProvider>(context,
                                    listen: false)
                                .selectedStoreDay!
                                .store
                                .photos
                                .length,
                            itemBuilder: ((context, index) {
                              return SizedBox(
                                width: width,
                                child: CachedNetworkImage(
                                  imageUrl: Provider.of<MatchProvider>(context,
                                          listen: false)
                                      .selectedStoreDay!
                                      .store
                                      .photos[index],
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    width: width * 0.1,
                                    child: Center(
                                      child: SFLoading(),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Center(
                                    child: Icon(Icons.dangerous),
                                  ),
                                ),
                              );
                            }),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: height * 0.06),
                            child: SizedBox(
                              height: width * 0.02,
                              width: width *
                                  0.04 *
                                  Provider.of<MatchProvider>(context,
                                          listen: false)
                                      .selectedStoreDay!
                                      .store
                                      .photos
                                      .length,
                              child: ListView.builder(
                                itemCount: Provider.of<MatchProvider>(context,
                                        listen: false)
                                    .selectedStoreDay!
                                    .store
                                    .photos
                                    .length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: ((context, index) {
                                  bool isIndex =
                                      Provider.of<MatchProvider>(context)
                                              .indexCurrentPhoto ==
                                          index;
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.01,
                                    ),
                                    child: ClipOval(
                                      child: Container(
                                        color: isIndex
                                            ? AppTheme.colors.primaryBlue
                                            : AppTheme.colors.secondaryBack,
                                        height: width * 0.02,
                                        width: width * 0.02,
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ],
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
                        color: AppTheme.colors.secondaryBack,
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
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: CachedNetworkImage(
                                  imageUrl: Provider.of<MatchProvider>(context,
                                          listen: false)
                                      .selectedStoreDay!
                                      .store
                                      .imageUrl,
                                  height: height * 0.13,
                                  width: height * 0.13,
                                  placeholder: (context, url) => Container(
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
                                    color: AppTheme.colors.textLightGrey
                                        .withOpacity(0.5),
                                    child: Center(
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
                                            Provider.of<MatchProvider>(context,
                                                    listen: false)
                                                .selectedStoreDay!
                                                .store
                                                .name,
                                            style: TextStyle(
                                              color:
                                                  AppTheme.colors.primaryBlue,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            r'assets\icon\location_ping.svg',
                                            color: AppTheme.colors.primaryBlue,
                                            width: 15,
                                          ),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  right: width * 0.02)),
                                          Expanded(
                                            child: Text(
                                              "${Provider.of<MatchProvider>(context, listen: false).selectedStoreDay!.store.address} - ${Provider.of<MatchProvider>(context, listen: false).regionText}",
                                              style: TextStyle(
                                                color:
                                                    AppTheme.colors.primaryBlue,
                                              ),
                                            ),
                                          ),
                                        ],
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
                viewOnly
                    ? Container()
                    : Container(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              color: AppTheme.colors.textLightGrey,
                              margin: EdgeInsets.symmetric(
                                  vertical: height * 0.02,
                                  horizontal: width * 0.02),
                              height: 1,
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(vertical: height * 0.01),
                              child: Row(
                                children: [
                                  SvgPicture.asset(r'assets\icon\calendar.svg'),
                                  Padding(
                                      padding:
                                          EdgeInsets.only(right: width * 0.01)),
                                  Text(
                                    Provider.of<MatchProvider>(context,
                                            listen: false)
                                        .selectedStoreDay!
                                        .day!,
                                    style: TextStyle(
                                        color: AppTheme.colors.primaryBlue,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(vertical: height * 0.01),
                              child: Text(
                                Provider.of<MatchProvider>(context,
                                                listen: false)
                                            .selectedStoreDay!
                                            .courts
                                            .length >
                                        1
                                    ? "Selecione a quadra e a duração do jogo"
                                    : "Selecione a duração do jogo",
                                style: TextStyle(
                                    color: AppTheme.colors.textDarkGrey,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: Provider.of<MatchProvider>(context,
                                      listen: false)
                                  .selectedStoreDay!
                                  .courts
                                  .length,
                              itemBuilder: (context, indexcourt) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: height * 0.015),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          right: width * 0.02,
                                          bottom: width * 0.02,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              Provider.of<MatchProvider>(
                                                      context,
                                                      listen: false)
                                                  .selectedStoreDay!
                                                  .courts[indexcourt]
                                                  .storeCourtName,
                                              style: TextStyle(
                                                color:
                                                    AppTheme.colors.primaryBlue,
                                              ),
                                            ),
                                            Text(
                                              Provider.of<MatchProvider>(
                                                          context,
                                                          listen: false)
                                                      .selectedStoreDay!
                                                      .courts[indexcourt]
                                                      .isIndoor
                                                  ? "Quadra Coberta"
                                                  : "Quadra Descoberta",
                                              textScaleFactor: 0.8,
                                              style: TextStyle(
                                                  color: AppTheme
                                                      .colors.textDarkGrey),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 50,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: Provider.of<MatchProvider>(
                                                  context,
                                                  listen: false)
                                              .selectedStoreDay!
                                              .courts[indexcourt]
                                              .availableHours
                                              .length,
                                          itemBuilder: ((context, indexHour) {
                                            return SFAvailableHours(
                                              availableHours:
                                                  Provider.of<MatchProvider>(
                                                          context,
                                                          listen: false)
                                                      .selectedStoreDay!
                                                      .courts[indexcourt]
                                                      .availableHours,
                                              widgetIndexTime: indexHour,
                                              widgetIndexStore: indexcourt,
                                              multipleSelection: true,
                                            );
                                          }),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                Container(
                  color: AppTheme.colors.textLightGrey,
                  margin: EdgeInsets.symmetric(
                      vertical: height * 0.02, horizontal: width * 0.02),
                  height: 1,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: height * 0.01, horizontal: width * 0.02),
                  child: Text(
                    "Sobre a quadra",
                    style: TextStyle(
                        color: AppTheme.colors.primaryBlue,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: height * 0.01, horizontal: width * 0.02),
                  child: Text(
                    Provider.of<MatchProvider>(context, listen: false)
                        .selectedStoreDay!
                        .store
                        .descriptionText,
                    style: TextStyle(color: AppTheme.colors.textDarkGrey),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: height * 0.02),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                  height: height * 0.2,
                  child: GoogleMap(
                    //Map widget from google_maps_flutter package
                    zoomGesturesEnabled: true, //enable Zoom in, out on map
                    initialCameraPosition: CameraPosition(
                      //innital position in map
                      target: showLocation!, //initial position
                      zoom: 13.0, //initial zoom level
                    ),
                    markers: markers, //markers to show on map
                    mapType: MapType.normal, //map type
                    onMapCreated: (controller) {
                      //method called when map is created
                      setState(() {
                        mapController = controller;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: height * 0.02, horizontal: width * 0.02),
                  child: Text(
                    "Contato",
                    style: TextStyle(
                        color: AppTheme.colors.primaryBlue,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                InkWell(
                  onTap: () {
                    final url = Uri.parse(
                        //"https://api.whatsapp.com/send?phone=${Provider.of<MatchProvider>(context, listen: false).selectedStoreDay!.store.phone}");
                        "https://wa.me/${Provider.of<MatchProvider>(context, listen: false).selectedStoreDay!.store.phone}");
                    UrlLauncher(url);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                    child: Container(
                      width: double.infinity,
                      height: height * 0.06,
                      decoration: BoxDecoration(
                        color: AppTheme.colors.primaryBlue.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: AppTheme.colors.primaryBlue.withOpacity(0.4),
                            width: 1),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: width * 0.04),
                            child: SvgPicture.asset(
                              r'assets\icon\whatsapp.svg',
                              height: height * 0.03,
                              width: height * 0.03,
                              color: AppTheme.colors.primaryBlue,
                            ),
                          ),
                          SizedBox(
                            height: height * 0.025,
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(
                                Provider.of<MatchProvider>(context,
                                        listen: false)
                                    .selectedStoreDay!
                                    .store
                                    .phone,
                                style: TextStyle(
                                  color: AppTheme.colors.primaryBlue,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: height * 0.02,
                  ),
                ),
                InkWell(
                  onTap: () {
                    final url = Uri.parse(
                        'https://www.instagram.com/${Provider.of<MatchProvider>(context, listen: false).selectedStoreDay!.store.instagram}');
                    UrlLauncher(url);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                    child: Container(
                      width: double.infinity,
                      height: height * 0.06,
                      decoration: BoxDecoration(
                        color: AppTheme.colors.primaryBlue.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: AppTheme.colors.primaryBlue.withOpacity(0.4),
                            width: 1),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: width * 0.04),
                            child: SvgPicture.asset(
                              r'assets\icon\instagram.svg',
                              height: height * 0.03,
                              width: height * 0.03,
                              color: AppTheme.colors.primaryBlue,
                            ),
                          ),
                          SizedBox(
                            height: height * 0.025,
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(
                                Provider.of<MatchProvider>(context,
                                        listen: false)
                                    .selectedStoreDay!
                                    .store
                                    .instagram,
                                style: TextStyle(
                                  color: AppTheme.colors.primaryBlue,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
                onTap: () {
                  viewOnly = true;
                  Provider.of<MatchProvider>(context, listen: false)
                      .indexSelectedCourt = -1;
                  Provider.of<MatchProvider>(context, listen: false)
                      .selectedTime
                      .clear();
                  Provider.of<MatchProvider>(context, listen: false)
                      .selectedTime
                      .clear();
                  if (widget.returnToParam == null) {
                    context.goNamed(
                      widget.returnTo,
                    );
                  } else {
                    String returnTo;
                    String returnToParam;
                    String returnToParamValue;
                    if (Provider.of<Redirect>(context, listen: false)
                            .originalPage ==
                        EnumReturnPages.MatchSearchScreen) {
                      returnTo = 'match_search_screen';
                      returnToParam = 'null';
                      returnToParamValue = 'null';
                    } else {
                      returnTo = 'home';
                      returnToParam = 'initialPage';
                      returnToParamValue = 'feed_screen';
                    }
                    context.goNamed(widget.returnTo, params: {
                      widget.returnToParam!: widget.returnToParamValue!,
                      'returnTo': returnTo,
                      'returnToParam': returnToParam,
                      'returnToParamValue': returnToParamValue
                    });
                  }
                },
                child: Container(
                  height: width * 0.1,
                  width: width * 0.1,
                  padding: EdgeInsets.all(width * 0.02),
                  decoration: BoxDecoration(
                      color: AppTheme.colors.secondaryBack,
                      shape: BoxShape.circle),
                  child: SvgPicture.asset(
                    r'assets\icon\arrow_left.svg',
                    color: AppTheme.colors.primaryBlue,
                  ),
                ),
              ),
            ),
            viewOnly
                ? Container()
                : Positioned(
                    bottom: MediaQuery.of(context).padding.bottom,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                      decoration: BoxDecoration(
                        color: AppTheme.colors.secondaryPaper,
                        border: Border(
                          top: BorderSide(
                            color: AppTheme.colors.divider,
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
                                  Provider.of<MatchProvider>(context,
                                              listen: false)
                                          .selectedTime
                                          .isEmpty
                                      ? " -"
                                      : Provider.of<MatchProvider>(context)
                                          .matchDetailsTime,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: height * 0.02,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  Provider.of<MatchProvider>(context,
                                              listen: false)
                                          .selectedTime
                                          .isEmpty
                                      ? "R\$ -"
                                      : "R\$${Provider.of<MatchProvider>(context).matchDetailsPrice}",
                                  style: TextStyle(
                                    color: AppTheme.colors.textDarkGrey,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.underline,
                                    fontSize: height * 0.017,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding:
                                EdgeInsets.symmetric(vertical: height * 0.02),
                            child: SFButton(
                                buttonLabel: "Agendar",
                                buttonType: Provider.of<MatchProvider>(context,
                                            listen: false)
                                        .selectedTime
                                        .isEmpty
                                    ? ButtonType.Disabled
                                    : ButtonType.YellowPrimary,
                                textPadding: EdgeInsets.all(width * 0.03),
                                onTap: () {
                                  if (Provider.of<MatchProvider>(context,
                                          listen: false)
                                      .selectedTime
                                      .isNotEmpty) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    CourtReservation(context);
                                  }
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
            showModal
                ? SFModal(
                    child: modalWidget!,
                    onTapBackground: () {
                      setState(() {
                        showModal = false;
                      });
                    },
                  )
                : Container(),
            isLoading
                ? Container(
                    color: AppTheme.colors.primaryBlue.withOpacity(0.3),
                    child: const Center(
                      child: SFLoading(),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  void UrlLauncher(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> CourtReservation(BuildContext context) async {
    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: "AccessToken");
    if (accessToken != null) {
      var response = await http.post(
        Uri.parse('https://www.sandfriends.com.br/CourtReservation'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, Object>{
          "accessToken": accessToken,
          "idStoreCourt": Provider.of<MatchProvider>(context, listen: false)
              .selectedStoreDay!
              .courts[Provider.of<MatchProvider>(context, listen: false)
                  .indexSelectedCourt!]
              .idStoreCourt,
          "sportId": Provider.of<MatchProvider>(context, listen: false)
              .selectedSport!
              .idSport,
          "date": DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy')
              .parse(Provider.of<MatchProvider>(context, listen: false)
                  .selectedStoreDay!
                  .day!)),
          "timeBegin": Provider.of<MatchProvider>(context, listen: false)
              .selectedTime
              .first
              .hour,
          "timeEnd": Provider.of<MatchProvider>(context, listen: false)
              .selectedTime
              .last
              .hourFinish,
          "cost": Provider.of<MatchProvider>(context, listen: false)
              .matchDetailsPrice
        }),
      );
      setState(() {
        isLoading = false;
      });
      if (response.statusCode == 200) {
        setState(() {
          modalWidget = SFModalMessage(
            modalStatus: GenericStatus.Success,
            message: "Horário Agendado",
            onTap: () {
              setState(() {
                showModal = false;
                context.goNamed('home', params: {'initialPage': 'feed_screen'});
                Provider.of<MatchProvider>(context, listen: false)
                    .needsRefresh = true;
                Provider.of<UserProvider>(context, listen: false)
                    .feedNeedsRefresh = true;
              });
            },
          );
          showModal = true;
        });
      } else if (response.statusCode == 413) {
        setState(() {
          modalWidget = SFModalMessage(
            modalStatus: GenericStatus.Failed,
            message: "Esse Horário não está mais disponível",
            onTap: () {
              showModal = false;
              Provider.of<MatchProvider>(context, listen: false).needsRefresh =
                  true;
              context.goNamed('match_search_screen');
            },
          );
          showModal = true;
        });
      }
    }
  }
}
