import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/Court/Model/HourPrice.dart';
import 'package:sandfriends/SharedComponents/Providers/CategoriesProvider/CategoriesProvider.dart';

import '../../../SharedComponents/Model/AppRecurrentMatch.dart';
import '../../../SharedComponents/View/SFButton.dart';
import '../../../SharedComponents/View/SFLoading.dart';
import '../../../Utils/Constants.dart';
import '../../../Utils/SFDateTime.dart';
import 'RecurrentMatchCardDate.dart';

class RecurrentMatchCard extends StatefulWidget {
  AppRecurrentMatch recurrentMatch;
  bool expanded;
  RecurrentMatchCard({
    Key? key,
    required this.recurrentMatch,
    required this.expanded,
  }) : super(key: key);

  @override
  State<RecurrentMatchCard> createState() => _RecurrentMatchCardState();
}

class _RecurrentMatchCardState extends State<RecurrentMatchCard> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return LayoutBuilder(builder: (layoutContext, layoutConstraints) {
      return Container(
        margin: EdgeInsets.symmetric(
          vertical: height * 0.01,
        ),
        height: widget.expanded ? layoutConstraints.maxHeight : 160,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: primaryLightBlue,
            width: 1,
          ),
          color: primaryLightBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Container(
              height: 25,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: primaryLightBlue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Text(
                "${weekDaysPortuguese[widget.recurrentMatch.weekday]}:  ${widget.recurrentMatch.timeBegin.hourString} - ${widget.recurrentMatch.timeEnd.hourString}",
                style: const TextStyle(
                    color: textWhite, fontWeight: FontWeight.w500),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Container(
                        height: 100,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: CachedNetworkImage(
                                imageUrl:
                                    widget.recurrentMatch.court.store!.imageUrl,
                                height: 80,
                                width: 80,
                                placeholder: (context, url) => const SizedBox(
                                  height: 80,
                                  width: 80,
                                  child: Center(
                                    child: SFLoading(),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  height: 80,
                                  width: 80,
                                  color: textLightGrey.withOpacity(0.5),
                                  child: const Center(
                                    child: Icon(Icons.dangerous),
                                  ),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                right: 20,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          r'assets\icon\location_ping.svg',
                                          color: textDarkGrey,
                                          width: 15,
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                right: width * 0.02)),
                                        Expanded(
                                          child: Text(
                                            widget.recurrentMatch.court.store!
                                                .name,
                                            style: const TextStyle(
                                              color: textDarkGrey,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              "Partidas jogadas:",
                                              style: TextStyle(
                                                color: textDarkGrey,
                                              ),
                                            ),
                                            Text(
                                              "${widget.recurrentMatch.recurrentMatchesCounter}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: textDarkGrey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: defaultPadding / 8,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              "Renovar até: ",
                                              style: TextStyle(
                                                color: textDarkGrey,
                                              ),
                                            ),
                                            Text(
                                              DateFormat("dd/MM/yy").format(
                                                widget
                                                    .recurrentMatch.validUntil,
                                              ),
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: widget.recurrentMatch
                                                            .validUntil
                                                            .difference(
                                                                DateTime.now())
                                                            .inDays <
                                                        10
                                                    ? red
                                                    : textDarkGrey,
                                              ),
                                            ),
                                          ],
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
                      if (widget.expanded)
                        Column(
                          children: [
                            SizedBox(
                              height: defaultPadding,
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        "Próximas partidas:",
                                        style: TextStyle(
                                          color: primaryLightBlue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: defaultPadding / 2,
                                ),
                                SizedBox(
                                  height: 80,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: widget.recurrentMatch
                                        .monthRecurrentMatches.length,
                                    itemBuilder: ((context, index) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(context,
                                                '/match_screen/${widget.recurrentMatch.monthRecurrentMatches[index].matchUrl}');
                                          },
                                          child: RecurrentMatchCardDate(
                                              day: widget
                                                  .recurrentMatch
                                                  .monthRecurrentMatches[index]
                                                  .date
                                                  .day,
                                              month: monthsPortuguese[widget
                                                      .recurrentMatch
                                                      .monthRecurrentMatches[
                                                          index]
                                                      .date
                                                      .month -
                                                  1]),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: defaultPadding,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Pagamentos:",
                                  style: TextStyle(
                                    color: primaryLightBlue,
                                  ),
                                ),
                                SizedBox(
                                  height: defaultPadding / 2,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${widget.recurrentMatch.monthRecurrentMatches.length} Partida(s) (R\$ ${widget.recurrentMatch.monthRecurrentMatches.first.cost}):",
                                      style: const TextStyle(
                                        color: textDarkGrey,
                                      ),
                                      textScaleFactor: 0.9,
                                    ),
                                    Text(
                                      "R\$ ${widget.recurrentMatch.currentMonthPrice()}",
                                      style: const TextStyle(
                                        color: textDarkGrey,
                                      ),
                                      textScaleFactor: 0.9,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: defaultPadding / 2,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Mensalista desde:",
                                      style: TextStyle(
                                        color: textDarkGrey,
                                      ),
                                      textScaleFactor: 0.9,
                                    ),
                                    Text(
                                      DateFormat("dd/MM/yyyy").format(
                                          widget.recurrentMatch.creationDate),
                                      style: const TextStyle(
                                        color: textDarkGrey,
                                      ),
                                      textScaleFactor: 0.9,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: defaultPadding / 2,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Última renovação:",
                                      style: TextStyle(
                                        color: textDarkGrey,
                                      ),
                                      textScaleFactor: 0.9,
                                    ),
                                    Text(
                                      DateFormat("dd/MM/yyyy").format(widget
                                          .recurrentMatch.lastPaymentDate),
                                      style: TextStyle(
                                        color: secondaryYellow,
                                      ),
                                      textScaleFactor: 0.9,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
            widget.expanded
                ? Column(
                    children: [
                      if (areInTheSameMonth(
                          widget.recurrentMatch.validUntil, DateTime.now()))
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.05,
                          ),
                          child: SFButton(
                            buttonLabel: "Renovar Horário",
                            color: primaryLightBlue,
                            textPadding:
                                EdgeInsets.symmetric(vertical: height * 0.01),
                            onTap: () {
                              List<HourPrice> hourPrices = [];
                              Provider.of<CategoriesProvider>(context,
                                      listen: false)
                                  .hours
                                  .forEach((hour) {
                                if (hour.hour >=
                                        widget.recurrentMatch.timeBegin.hour &&
                                    hour.hour <
                                        widget.recurrentMatch.timeEnd.hour) {
                                  hourPrices.add(
                                    HourPrice(
                                      hour: hour,
                                      price: widget.recurrentMatch
                                          .monthRecurrentMatches.first.cost,
                                    ),
                                  );
                                }
                              });
                              Navigator.pushNamed(
                                context,
                                "/checkout",
                                arguments: {
                                  'court': widget.recurrentMatch.court,
                                  'hourPrices': hourPrices,
                                  'sport': widget.recurrentMatch.sport,
                                  'date': null,
                                  'weekday': widget.recurrentMatch.weekday,
                                  'isRecurrent': true,
                                  'isRenovating': true,
                                },
                              );
                            },
                          ),
                        ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: SvgPicture.asset(
                          r"assets\icon\arrow_up.svg",
                          color: primaryLightBlue,
                        ),
                      ),
                    ],
                  )
                : Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: SvgPicture.asset(
                      r"assets\icon\arrow_down.svg",
                      color: primaryLightBlue,
                    ),
                  ),
          ],
        ),
      );
    });
  }
}
