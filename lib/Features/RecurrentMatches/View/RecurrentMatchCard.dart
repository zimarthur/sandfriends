import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../SharedComponents/Model/RecurrentMatch.dart';
import '../../../SharedComponents/View/SFLoading.dart';
import '../../../Utils/Constants.dart';
import '../../../Utils/SFDateTime.dart';
import '../../../oldApp/widgets/SF_Button.dart';
import 'RecurrentMatchCardDate.dart';

class RecurrentMatchCard extends StatefulWidget {
  RecurrentMatch recurrentMatch;
  bool expanded;
  RecurrentMatchCard({
    required this.recurrentMatch,
    required this.expanded,
  });

  @override
  State<RecurrentMatchCard> createState() => _RecurrentMatchCardState();
}

class _RecurrentMatchCardState extends State<RecurrentMatchCard> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: height * 0.01,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: primaryLightBlue,
          width: 1,
        ),
        color: secondaryLightBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            height: 25,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: primaryLightBlue,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Text(
              "${weekDaysPortuguese[widget.recurrentMatch.weekday]}:  ${widget.recurrentMatch.timeBegin} - ${widget.recurrentMatch.timeEnd}",
              style: TextStyle(color: textWhite, fontWeight: FontWeight.w500),
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
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: CachedNetworkImage(
                              imageUrl:
                                  "widget.recurrentMatch.court.store.imageUrl",
                              height: 80,
                              width: 80,
                              placeholder: (context, url) => Container(
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
                                child: Center(
                                  child: Icon(Icons.dangerous),
                                ),
                              ),
                            ),
                          ),
                          Padding(
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
                                          "widget.recurrentMatch.court.store.name",
                                          style: TextStyle(
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
                                          Text(
                                            "Partidas jogadas:",
                                            style: TextStyle(
                                              color: textDarkGrey,
                                            ),
                                          ),
                                          Text(
                                            "${widget.recurrentMatch.recurrentMatchesCounter}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: textDarkGrey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Mensalista desde: ",
                                            style: TextStyle(
                                              color: textDarkGrey,
                                            ),
                                          ),
                                          Text(
                                            DateFormat("dd/MM/yyyy").format(
                                                widget.recurrentMatch
                                                    .creationDate),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: textDarkGrey,
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
                    widget.expanded == false
                        ? Container()
                        : Column(
                            children: [
                              SizedBox(
                                height: height * 0.03,
                              ),
                              Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Partidas nesse mês:",
                                          style: TextStyle(
                                            color: primaryLightBlue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Container(
                                    height: 80,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: widget.recurrentMatch
                                          .monthRecurrentMatches.length,
                                      itemBuilder: ((context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10.0),
                                          child: InkWell(
                                            onTap: () {
                                              // context.go(
                                              //    '/match_screen/${widget.recurrentMatch.monthRecurrentMatches[index].matchUrl}/recurrent_match_screen/null/null');
                                            },
                                            child: RecurrentMatchCardDate(
                                                day: widget
                                                    .recurrentMatch
                                                    .monthRecurrentMatches[
                                                        index]
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
                                height: height * 0.03,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Pagamentos:",
                                    style: TextStyle(
                                      color: primaryLightBlue,
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${widget.recurrentMatch.monthRecurrentMatches.length} Partidas (R\$ ${widget.recurrentMatch.monthRecurrentMatches.first.cost}):",
                                        style: TextStyle(
                                          color: textDarkGrey,
                                        ),
                                      ),
                                      Text(
                                        "R\$ ${widget.recurrentMatch.currentMonthPrice()}",
                                        style: TextStyle(
                                          color: textDarkGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Última Renovação:",
                                        style: TextStyle(
                                          color: textDarkGrey,
                                        ),
                                      ),
                                      Text(
                                        DateFormat("dd/MM/yyyy").format(widget
                                            .recurrentMatch.lastPaymentDate),
                                        style: TextStyle(
                                          color: textDarkGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Vencimento:",
                                        style: TextStyle(
                                          color: textDarkGrey,
                                        ),
                                      ),
                                      Text(
                                        "01/01/2023",
                                        style: TextStyle(
                                          color: secondaryYellow,
                                        ),
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
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.05,
                      ),
                      child: SFButton(
                        buttonLabel: "Renovar Horário",
                        color: secondaryLightBlue,
                        textPadding:
                            EdgeInsets.symmetric(vertical: height * 0.01),
                        onTap: () {},
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: SvgPicture.asset(
                        r"assets\icon\arrow_up.svg",
                        color: secondaryLightBlue,
                      ),
                    ),
                  ],
                )
              : Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: SvgPicture.asset(
                    r"assets\icon\arrow_down.svg",
                    color: secondaryLightBlue,
                  ),
                ),
        ],
      ),
    );
  }
}
