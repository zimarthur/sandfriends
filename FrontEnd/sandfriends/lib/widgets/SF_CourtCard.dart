import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/models/court_available_hours.dart';
import 'package:sandfriends/providers/match_provider.dart';
import 'package:sandfriends/widgets/SF_AvailableHours.dart';
import 'package:sandfriends/widgets/SF_Button.dart';

import '../models/store_day.dart';
import '../theme/app_theme.dart';
import 'SFLoading.dart';

class SFCourtCard extends StatefulWidget {
  final StoreDay storeDay;
  final int widgetIndexStore;
  final VoidCallback onOnTap;

  const SFCourtCard(
      {required this.storeDay,
      required this.widgetIndexStore,
      required this.onOnTap});

  @override
  State<SFCourtCard> createState() => _SFCourtCardState();
}

class _SFCourtCardState extends State<SFCourtCard> {
  bool isSelectedCourt(BuildContext context, bool listen) {
    if (Provider.of<MatchProvider>(context, listen: listen)
            .indexSelectedCourt ==
        widget.widgetIndexStore) {
      return true;
    } else {
      return false;
    }
  }

  List<CourtAvailableHours> availableHours = [];

  void availableHoursLength() {
    availableHours.clear();
    bool newHour = true;
    for (int courtsIndex = 0;
        courtsIndex < widget.storeDay.courts.length;
        courtsIndex++) {
      for (int hoursIndex = 0;
          hoursIndex <
              widget.storeDay.courts[courtsIndex].availableHours.length;
          hoursIndex++) {
        for (int i = 0; i < availableHours.length; i++) {
          if (availableHours[i].hourIndex ==
              widget.storeDay.courts[courtsIndex].availableHours[hoursIndex]
                  .hourIndex) {
            newHour = false;

            if (availableHours[i].price.toInt() >
                widget.storeDay.courts[courtsIndex].availableHours[hoursIndex]
                    .price
                    .toInt()) {
              availableHours[i].price = widget.storeDay.courts[courtsIndex]
                  .availableHours[hoursIndex].price;
            }
          }
        }
        if (newHour == true || availableHours.isEmpty) {
          availableHours.add(CourtAvailableHours(
              widget
                  .storeDay.courts[courtsIndex].availableHours[hoursIndex].hour,
              widget.storeDay.courts[courtsIndex].availableHours[hoursIndex]
                  .hourIndex,
              widget.storeDay.courts[courtsIndex].availableHours[hoursIndex]
                  .hourFinish,
              widget.storeDay.courts[courtsIndex].availableHours[hoursIndex]
                  .price));
          newHour = true;
          /*print(
              "new hour: ${widget.storeDay.courts[courtsIndex].availableHours[hoursIndex].hourIndex}");*/
        }
        /*else {
          print(
              "NOT new hour: ${widget.storeDay.courts[courtsIndex].availableHours[hoursIndex].hourIndex}");
        }*/
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    availableHoursLength();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.03),
      margin: EdgeInsets.symmetric(vertical: height * 0.005),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: AppTheme.colors.secondaryPaper,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.colors.divider,
            width: 0.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl: widget.storeDay.store.imageUrl,
                      height: 82,
                      width: 82,
                      placeholder: (context, url) => Container(
                        height: 82,
                        width: 82,
                        child: Center(
                          child: SFLoading(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppTheme.colors.textLightGrey.withOpacity(0.5),
                        height: 82,
                        width: 82,
                        child: Center(
                          child: Icon(
                            Icons.dangerous,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(right: 12)),
                  Expanded(
                      child: SizedBox(
                    height: 82,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.storeDay.store.name,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: AppTheme.colors.primaryBlue),
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(r"assets\icon\location_ping.svg"),
                            Text(
                              widget.storeDay.store.address,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                  color: AppTheme.colors.primaryBlue),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Horários disponíveis",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: AppTheme.colors.textDarkGrey),
                            ),
                            Text(
                              "Selecione o início do jogo",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                  color: AppTheme.colors.textDarkGrey),
                            ),
                          ],
                        )
                      ],
                    ),
                  )),
                ],
              ),
            ),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: availableHours.length,
                itemBuilder: ((context, index) {
                  return SFAvailableHours(
                    availableHours: availableHours,
                    widgetIndexTime: index,
                    widgetIndexStore: widget.widgetIndexStore,
                    multipleSelection: false,
                  );
                }),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.03, vertical: height * 0.01),
              child: SFButton(
                  buttonLabel: "Prosseguir",
                  buttonType: isSelectedCourt(context, true)
                      ? ButtonType.Primary
                      : ButtonType.Disabled,
                  textPadding: const EdgeInsets.symmetric(vertical: 5),
                  onTap: () {
                    if (isSelectedCourt(context, false)) {
                      widget.onOnTap();
                      Provider.of<MatchProvider>(context, listen: false)
                          .selectedStoreDay = widget.storeDay;
                      Provider.of<MatchProvider>(context, listen: false)
                          .indexSelectedTime
                          .clear();
                      context.goNamed('court_screen', params: {
                        'viewOnly': 'null',
                        'returnTo': 'match_search_screen',
                        'returnToParam': 'null',
                        'returnToParamValue': 'null',
                      });
                    } else {
                      print("seleciona horario antes");
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
