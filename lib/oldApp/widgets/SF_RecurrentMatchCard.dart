import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../SharedComponents/Model/RecurrentMatch.dart';
import '../providers/categories_provider.dart';
import '../theme/app_theme.dart';
import '../../SharedComponents/View/SFLoading.dart';
import 'SF_Button.dart';
import 'SF_RecurrentMatchDateCard.dart';

class RecurrentMatchCard extends StatefulWidget {
  RecurrentMatch recurrentMatch;
  bool expanded;
  RecurrentMatchCard(
      {Key? key, required this.recurrentMatch, required this.expanded})
      : super(key: key);

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
          color: AppTheme.colors.primaryLightBlue,
          width: 1,
        ),
        color: AppTheme.colors.secondaryLightBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            height: 25,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppTheme.colors.primaryLightBlue,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Text(
              "${Provider.of<CategoriesProvider>(context, listen: false).weekDaysPortuguese[widget.recurrentMatch.weekday]}:  ${widget.recurrentMatch.timeBegin} - ${widget.recurrentMatch.timeEnd}",
              style: TextStyle(
                  color: AppTheme.colors.textWhite,
                  fontWeight: FontWeight.w500),
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
                                color: AppTheme.colors.textLightGrey
                                    .withOpacity(0.5),
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
                                        color: AppTheme.colors.textDarkGrey,
                                        width: 15,
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              right: width * 0.02)),
                                      Expanded(
                                        child: Text(
                                          "widget.recurrentMatch.court.store.name",
                                          style: TextStyle(
                                            color: AppTheme.colors.textDarkGrey,
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
                                              color:
                                                  AppTheme.colors.textDarkGrey,
                                            ),
                                          ),
                                          Text(
                                            "${widget.recurrentMatch.recurrentMatchesCounter}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  AppTheme.colors.textDarkGrey,
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
                                              color:
                                                  AppTheme.colors.textDarkGrey,
                                            ),
                                          ),
                                          Text(
                                            DateFormat("dd/MM/yyyy").format(
                                                widget.recurrentMatch
                                                    .creationDate),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  AppTheme.colors.textDarkGrey,
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
                                            color: AppTheme
                                                .colors.primaryLightBlue,
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
                                              context.go(
                                                  '/match_screen/${widget.recurrentMatch.monthRecurrentMatches[index].matchUrl}/recurrent_match_screen/null/null');
                                            },
                                            child: RecurrentMatchDateCard(
                                                day: widget
                                                    .recurrentMatch
                                                    .monthRecurrentMatches[
                                                        index]
                                                    .date
                                                    .day,
                                                month: Provider.of<
                                                            CategoriesProvider>(
                                                        context,
                                                        listen: false)
                                                    .monthsPortuguese[widget
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
                                      color: AppTheme.colors.primaryLightBlue,
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
                                          color: AppTheme.colors.textDarkGrey,
                                        ),
                                      ),
                                      Text(
                                        "R\$ ${widget.recurrentMatch.currentMonthPrice()}",
                                        style: TextStyle(
                                          color: AppTheme.colors.textDarkGrey,
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
                                          color: AppTheme.colors.textDarkGrey,
                                        ),
                                      ),
                                      Text(
                                        DateFormat("dd/MM/yyyy").format(widget
                                            .recurrentMatch.lastPaymentDate),
                                        style: TextStyle(
                                          color: AppTheme.colors.textDarkGrey,
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
                                          color: AppTheme.colors.textDarkGrey,
                                        ),
                                      ),
                                      Text(
                                        "01/01/2023",
                                        style: TextStyle(
                                          color:
                                              AppTheme.colors.secondaryYellow,
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
                        buttonType: ButtonType.LightBluePrimary,
                        textPadding:
                            EdgeInsets.symmetric(vertical: height * 0.01),
                        onTap: () {},
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: SvgPicture.asset(
                        r"assets\icon\arrow_up.svg",
                        color: AppTheme.colors.secondaryLightBlue,
                      ),
                    ),
                  ],
                )
              : Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: SvgPicture.asset(
                    r"assets\icon\arrow_down.svg",
                    color: AppTheme.colors.secondaryLightBlue,
                  ),
                ),
        ],
      ),
    );
  }
}
