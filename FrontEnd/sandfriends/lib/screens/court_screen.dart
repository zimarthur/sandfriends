import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/models/enums.dart';
import 'package:sandfriends/models/store_day.dart';
import 'package:sandfriends/theme/app_theme.dart';
import 'package:sandfriends/widgets/Modal/SF_Modal.dart';
import 'package:sandfriends/widgets/Modal/SF_ModalMessage.dart';
import 'package:sandfriends/widgets/SF_Button.dart';
import 'package:sandfriends/widgets/SF_Scaffold.dart';
import 'package:photo_view/photo_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import '../models/court_available_hours.dart';
import '../models/court.dart';
import '../models/user.dart';
import '../providers/match_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/SF_AvailableHours.dart';

class CourtScreen extends StatefulWidget {
  const CourtScreen({this.param});
  final String? param;

  @override
  State<CourtScreen> createState() => _CourtScreenState();
}

class _CourtScreenState extends State<CourtScreen> {
  bool showModal = false;
  Widget? modalWidget;
  bool viewOnly = true;
  ScrollController _controller = ScrollController();

  List<Court> availableCourts = [];

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
  Set<Marker> markers = Set(); //markers for google map
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

    if (viewOnly == false) {
      availableCourts.clear();

      StoreDay selectedStoreDay =
          Provider.of<MatchProvider>(context, listen: false).selectedStoreDay!;
      int selectedTime = Provider.of<MatchProvider>(context, listen: false)
          .selectedTime
          .first
          .hourIndex;
      bool newHour = false;
      int lastAvailableHour = -1;
      int hourIndexPace;

      List<CourtAvailableHours> availableHoursList = [];

      for (int courtIndex = 0;
          courtIndex < selectedStoreDay.courts.length;
          courtIndex++) {
        lastAvailableHour = -1;
        for (int hourIndex = 0;
            hourIndex <
                selectedStoreDay.courts[courtIndex].availableHours.length;
            hourIndex++) {
          if (selectedStoreDay
                  .courts[courtIndex].availableHours[hourIndex].hourIndex ==
              selectedTime) {
            lastAvailableHour = selectedTime;
            newHour = true;
          } else if (selectedStoreDay
                  .courts[courtIndex].availableHours[hourIndex].hourIndex >
              selectedTime) {
            if (selectedStoreDay.courts[courtIndex].availableHours[hourIndex]
                        .hourIndex -
                    lastAvailableHour ==
                1) {
              lastAvailableHour = selectedStoreDay
                  .courts[courtIndex].availableHours[hourIndex].hourIndex;
              newHour = true;
            }
          }
          if (newHour) {
            newHour = false;
            availableHoursList.add(CourtAvailableHours(
                selectedStoreDay
                    .courts[courtIndex].availableHours[hourIndex].hour,
                selectedStoreDay
                    .courts[courtIndex].availableHours[hourIndex].hourIndex,
                selectedStoreDay
                    .courts[courtIndex].availableHours[hourIndex].hourFinish,
                selectedStoreDay
                    .courts[courtIndex].availableHours[hourIndex].price));
          }
        }
        if (availableHoursList.length > 0) {
          Court newCourt = Court(
              selectedStoreDay.courts[courtIndex].idStoreCourt,
              selectedStoreDay.courts[courtIndex].storeCourtName);
          newCourt.availableHours = List.from(availableHoursList);
          availableCourts.add(newCourt);
          availableHoursList.clear();
        }
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              Stack(
                children: [
                  Container(
                    height: height * 0.40,
                    width: width,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        ListView.builder(
                          controller: _controller,
                          scrollDirection: Axis.horizontal,
                          physics: PageScrollPhysics(),
                          itemCount:
                              Provider.of<MatchProvider>(context, listen: false)
                                  .selectedStoreDay!
                                  .store
                                  .photos
                                  .length,
                          itemBuilder: ((context, index) {
                            return Container(
                              width: width,
                              child: FittedBox(
                                fit: BoxFit.cover,
                                child: Image.network(Provider.of<MatchProvider>(
                                        context,
                                        listen: false)
                                    .selectedStoreDay!
                                    .store
                                    .photos[index]),
                              ),
                            );
                          }),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: height * 0.06),
                          child: Container(
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
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(30.0),
                        topRight: const Radius.circular(30.0),
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
                              child: Image.network(
                                Provider.of<MatchProvider>(context,
                                        listen: false)
                                    .selectedStoreDay!
                                    .store
                                    .imageUrl,
                                height: height * 0.13,
                                width: height * 0.13,
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
                                    Container(
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
                                            color: AppTheme.colors.primaryBlue,
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
                                      .day,
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
                              "Selecione a quadra e o horário do jogo",
                              style: TextStyle(
                                  color: AppTheme.colors.textDarkGrey,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: availableCourts.length,
                            itemBuilder: (context, indexcourt) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: height * 0.01),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width * 0.02),
                                      child: Text(
                                        availableCourts[indexcourt]
                                            .storeCourtName,
                                        style: TextStyle(
                                          color: AppTheme.colors.primaryBlue,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 50,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: availableCourts[indexcourt]
                                            .availableHours
                                            .length,
                                        itemBuilder: ((context, indexHour) {
                                          return SFAvailableHours(
                                            availableHours:
                                                availableCourts[indexcourt]
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
                        Container(
                          height: height * 0.025,
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Text(
                              "${Provider.of<MatchProvider>(context, listen: false).selectedStoreDay!.store.phone}",
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
                        Container(
                          height: height * 0.025,
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Text(
                              "${Provider.of<MatchProvider>(context, listen: false).selectedStoreDay!.store.instagram}",
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
                context.goNamed('match_search_screen');
                Provider.of<MatchProvider>(context, listen: false)
                    .indexSelectedTime
                    .clear();
                Provider.of<MatchProvider>(context, listen: false)
                    .selectedTime
                    .clear();
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
                                        .indexSelectedTime
                                        .isEmpty
                                    ? "${Provider.of<MatchProvider>(context).selectedTime.first.hour} -"
                                    : "${Provider.of<MatchProvider>(context).matchDetailsTime}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: height * 0.02,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                Provider.of<MatchProvider>(context,
                                            listen: false)
                                        .indexSelectedTime
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
                                      .indexSelectedTime
                                      .isEmpty
                                  ? ButtonType.Disabled
                                  : ButtonType.Primary,
                              textPadding: EdgeInsets.all(width * 0.03),
                              onTap: () {
                                if (Provider.of<MatchProvider>(context,
                                        listen: false)
                                    .indexSelectedTime
                                    .isNotEmpty) {
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
        ],
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
          "idStore": Provider.of<MatchProvider>(context, listen: false)
              .selectedStoreDay!
              .store
              .idStore,
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
                  .day)),
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
                    .nextMatchNeedsRefresh = true;
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
