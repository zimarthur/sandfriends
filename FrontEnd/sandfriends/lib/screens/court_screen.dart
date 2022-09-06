import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/models/enums.dart';
import 'package:sandfriends/theme/app_theme.dart';
import 'package:sandfriends/widgets/SF_Scaffold.dart';
import 'package:photo_view/photo_view.dart';

import '../models/court_available_hours.dart';
import '../models/court_price.dart';
import '../providers/match_provider.dart';

class CourtScreen extends StatefulWidget {
  const CourtScreen({this.param});
  final String? param;

  @override
  State<CourtScreen> createState() => _CourtScreenState();
}

class _CourtScreenState extends State<CourtScreen> {
  bool showModal = false;
  bool viewOnly = true;
  ScrollController _controller = ScrollController();

  void _onScrollEvent() {
    if (_controller.position.pixels.toInt() %
            (MediaQuery.of(context).size.width * 0.94).toInt() ==
        0) {
      Provider.of<MatchProvider>(context, listen: false).indexCurrentPhoto =
          (_controller.position.pixels ~/
                  (MediaQuery.of(context).size.width * 0.94))
              .round();
    }
  }

  @override
  void initState() {
    _controller.addListener(_onScrollEvent);
    if (widget.param == 'viewOnly') {
      viewOnly = true;
    } else {
      viewOnly = false;
    }
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
    // var filteredCourt = Provider.of<MatchProvider>(context, listen: false)
    //     .selectedCourt!
    //     .availableHours
    //     .where((hour) =>
    //         hour.hourIndex ==
    //         Provider.of<MatchProvider>(context, listen: false)
    //             .selectedCourtTime)
    //     .first
    //     .courtPrices;
    var originalCourt = List.from(
        Provider.of<MatchProvider>(context, listen: false)
            .selectedCourt!
            .availableHours);
    List<CourtAvailableHours> filteredCourts = [];
    int widgetIndex = 0;
    for (int hoursLoop = 0; hoursLoop < originalCourt.length; hoursLoop++) {
      if (originalCourt[hoursLoop].hourIndex ==
          Provider.of<MatchProvider>(context, listen: false)
              .selectedCourtTime) {
        print("IGUALLLL");
        List<CourtPrice> filteredCourtPrices = [];
        for (int courtsLoop = 0;
            courtsLoop < originalCourt[hoursLoop].courtPrices.length;
            courtsLoop++) {
          filteredCourtPrices.add(CourtPrice(
              originalCourt[hoursLoop].courtPrices[courtsLoop].idStoreCourt,
              originalCourt[hoursLoop].courtPrices[courtsLoop].storeCourtName,
              originalCourt[hoursLoop].courtPrices[courtsLoop].price));
        }
        filteredCourts.add(CourtAvailableHours(
            widgetIndex,
            originalCourt[hoursLoop].hour,
            originalCourt[hoursLoop].hourIndex,
            filteredCourtPrices));
      } else if (originalCourt[hoursLoop].hourIndex >=
          Provider.of<MatchProvider>(context, listen: false)
              .selectedCourtTime) {
        List<CourtPrice> filteredCourtPrices = [];
        for (int courtsLoop = 0;
            courtsLoop < originalCourt[hoursLoop].courtPrices.length;
            courtsLoop++) {
          filteredCourtPrices.add(CourtPrice(
              originalCourt[hoursLoop].courtPrices[courtsLoop].idStoreCourt,
              originalCourt[hoursLoop].courtPrices[courtsLoop].storeCourtName,
              originalCourt[hoursLoop].courtPrices[courtsLoop].price));
        }
        filteredCourts.add(CourtAvailableHours(
            widgetIndex,
            originalCourt[hoursLoop].hour,
            originalCourt[hoursLoop].hourIndex,
            filteredCourtPrices));
      }
    }
    for (int j = 0; j < filteredCourts.length; j++) {
      print(filteredCourts[j].hour);
      print(filteredCourts[j].hourIndex);
      for (int k = 0; k < filteredCourts[j].courtPrices.length; k++) {
        print(filteredCourts[j].courtPrices[k].storeCourtName);
        print(filteredCourts[j].courtPrices[k].price);
      }
    }
    return SFScaffold(
      titleText: viewOnly ? "Explorar quadras" : "Agendamento",
      goNamed: 'match_search_screen',
      appBarType: AppBarType.Primary,
      showModal: showModal,
      child: Container(
        width: width,
        color: AppTheme.colors.secondaryBack,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: width * 0.03),
          child: ListView(
            children: [
              Container(
                height: height * 0.2,
                width: width * 0.94,
                margin: EdgeInsets.symmetric(vertical: height * 0.01),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    ListView.builder(
                      controller: _controller,
                      scrollDirection: Axis.horizontal,
                      physics: PageScrollPhysics(),
                      itemCount:
                          Provider.of<MatchProvider>(context, listen: false)
                              .selectedCourt!
                              .store
                              .photos
                              .length,
                      itemBuilder: ((context, index) {
                        return Container(
                          width: width * 0.94,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Image.network(Provider.of<MatchProvider>(
                                    context,
                                    listen: false)
                                .selectedCourt!
                                .store
                                .photos[index]),
                          ),
                        );
                      }),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: height * 0.01),
                      child: Container(
                        height: width * 0.02,
                        width: width *
                            0.04 *
                            Provider.of<MatchProvider>(context, listen: false)
                                .selectedCourt!
                                .store
                                .photos
                                .length,
                        child: ListView.builder(
                          itemCount:
                              Provider.of<MatchProvider>(context, listen: false)
                                  .selectedCourt!
                                  .store
                                  .photos
                                  .length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: ((context, index) {
                            bool isIndex = Provider.of<MatchProvider>(context)
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
              SizedBox(
                height: height * 0.1,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Image.network(
                        Provider.of<MatchProvider>(context, listen: false)
                            .selectedCourt!
                            .store
                            .imageUrl,
                        height: height * 0.1,
                        width: height * 0.1,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: height * 0.05,
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  Provider.of<MatchProvider>(context,
                                          listen: false)
                                      .selectedCourt!
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
                                    padding:
                                        EdgeInsets.only(right: width * 0.02)),
                                Expanded(
                                  child: Text(
                                    "${Provider.of<MatchProvider>(context, listen: false).selectedCourt!.store.address} - ${Provider.of<MatchProvider>(context, listen: false).regionText}",
                                    style: TextStyle(
                                      color: AppTheme.colors.primaryBlue,
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
              Container(
                color: AppTheme.colors.textLightGrey,
                margin: EdgeInsets.symmetric(vertical: height * 0.02),
                height: 1,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: height * 0.01),
                child: Text(
                  "Sobre a quadra",
                  style: TextStyle(
                      color: AppTheme.colors.primaryBlue,
                      fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                Provider.of<MatchProvider>(context, listen: false)
                    .selectedCourt!
                    .store
                    .descriptionText,
                style: TextStyle(color: AppTheme.colors.textDarkGrey),
              ),
              viewOnly
                  ? Container()
                  : Column(
                      children: [
                        Container(
                          color: AppTheme.colors.textLightGrey,
                          margin: EdgeInsets.symmetric(vertical: height * 0.02),
                          height: 1,
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: height * 0.01),
                          child: Text(
                            Provider.of<MatchProvider>(context, listen: false)
                                .selectedCourt!
                                .day,
                            style: TextStyle(
                                color: AppTheme.colors.primaryBlue,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: height * 0.01),
                          child: Text(
                            Provider.of<MatchProvider>(context, listen: false)
                                .selectedCourtTime
                                .toString(),
                            style: TextStyle(
                                color: AppTheme.colors.primaryBlue,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        // ListView.builder(
                        //   shrinkWrap: true,
                        //   itemCount: filteredCourt.length,
                        //   itemBuilder: (context, index) {
                        //     return Column(
                        //       children: [
                        //         Text(filteredCourt[index].storeCourtName),
                        //       ],
                        //     );
                        //   },
                        // ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
