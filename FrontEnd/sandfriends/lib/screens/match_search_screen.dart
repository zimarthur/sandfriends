import 'dart:convert';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/models/court.dart';
import 'package:sandfriends/models/court_available_hours.dart';
import 'package:sandfriends/models/court_price.dart';
import 'package:sandfriends/widgets/Modal/SF_ModalDatePicker.dart';
import 'package:sandfriends/widgets/SF_CourtCard.dart';
import 'package:sandfriends/widgets/SF_Scaffold.dart';
import 'package:sandfriends/widgets/SF_SearchFilter.dart';
import '../models/city.dart';
import '../models/region.dart';
import '../models/enums.dart';
import 'package:time_range/time_range.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

import '../../models/enums.dart';
import '../../theme/app_theme.dart';
import '../../widgets/SF_Button.dart';
import '../models/store.dart';
import '../providers/match_provider.dart';

class MatchSearchScreen extends StatefulWidget {
  const MatchSearchScreen({Key? key}) : super(key: key);

  @override
  State<MatchSearchScreen> createState() => _MatchSearchScreen();
}

class _MatchSearchScreen extends State<MatchSearchScreen> {
  Widget widgetLoading = SizedBox(
    height: 10,
    width: 10,
    child: CircularProgressIndicator(),
  );

  int? selectedCourt;
  int? selectedTime;

  List<Court> courts = [];

  bool showModal = false;
  Widget? modalWidget;

  RangeValues _currentRangeValues = RangeValues(0, 23);

  TimeRangeResult? timePickerRange;
  final defaultTimePickerRange = TimeRangeResult(
    const TimeOfDay(hour: 0, minute: 0),
    const TimeOfDay(hour: 23, minute: 00),
  );

  final Map<int, Widget> segmentedTexts = <int, Widget>{
    0: Text("Todos"),
    1: Text("Quadras"),
    2: Text("Partidas"),
  };
  int segmentedTextValue = 0;

  @override
  Widget build(BuildContext context) {
    final courts = Provider.of<MatchProvider>(context).courts;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double appBarHeight = height * 0.3 > 150 ? 150 : height * 0.3;

    String ConvertDatetime(DateTime dateTime) {
      return dateTime.toString().replaceAll('00:00:00.000', '');
    }

    return SFScaffold(
      titleText:
          "Busca - ${Provider.of<MatchProvider>(context).selectedSport!.description}",
      goNamed: 'home',
      goNamedParams: {'initialPage': 'sport_selection_screen'},
      appBarType: AppBarType.Primary,
      showModal: showModal,
      modalWidget: modalWidget,
      onTapBackground: () {
        setState(() {
          showModal = false;
        });
      },
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: appBarHeight,
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                      height: appBarHeight * 0.33,
                      child: SFSearchFilter(
                        labelText:
                            Provider.of<MatchProvider>(context).regionText,
                        iconPath: r"assets\icon\location_ping.svg",
                        margin: EdgeInsets.only(left: width * 0.02),
                        padding:
                            EdgeInsets.symmetric(vertical: appBarHeight * 0.02),
                        onTap: () {
                          setState(() {
                            GetCities(context);
                            modalWidget = widgetLoading;
                            showModal = true;
                          });
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: width * 0.02,
                                vertical: appBarHeight * 0.06),
                            height: appBarHeight * 0.33,
                            child: SFSearchFilter(
                              labelText:
                                  Provider.of<MatchProvider>(context).dateText,
                              iconPath: r"assets\icon\calendar.svg",
                              margin: EdgeInsets.only(left: width * 0.02),
                              padding: EdgeInsets.symmetric(
                                  vertical: appBarHeight * 0.02),
                              onTap: () {
                                setState(() {
                                  modalWidget = Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(width * 0.03),
                                        child: CalendarDatePicker2(
                                            config: CalendarDatePicker2Config(
                                              weekdayLabels: [
                                                'Dom',
                                                'Seg',
                                                'Ter',
                                                'Qua',
                                                'Qui',
                                                'Sex',
                                                'Sáb'
                                              ],
                                              firstDate: DateTime(today.year,
                                                  today.month, today.day),
                                              calendarType:
                                                  CalendarDatePicker2Type.range,
                                              selectedDayHighlightColor:
                                                  AppTheme.colors.primaryBlue,
                                              weekdayLabelTextStyle:
                                                  const TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              controlsTextStyle:
                                                  const TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            initialValue:
                                                Provider.of<MatchProvider>(
                                                        context,
                                                        listen: false)
                                                    .selectedDates,
                                            onValueChanged: (values) {
                                              setState(() {
                                                Provider.of<MatchProvider>(
                                                        context,
                                                        listen: false)
                                                    .selectedDates = values;
                                              });
                                            }),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: width * 0.15,
                                            left: width * 0.15,
                                            bottom: height * 0.03),
                                        child: SFButton(
                                          iconPath: r"assets\icon\search.svg",
                                          buttonLabel: "Aplicar Filtro",
                                          textPadding: EdgeInsets.symmetric(
                                              vertical: height * 0.005),
                                          buttonType: ButtonType.Secondary,
                                          onTap: () {
                                            setState(() {
                                              if (Provider.of<MatchProvider>(
                                                      context,
                                                      listen: false)
                                                  .selectedDates
                                                  .isNotEmpty) {
                                                var startDate = ConvertDatetime(
                                                    Provider.of<MatchProvider>(
                                                            context,
                                                            listen: false)
                                                        .selectedDates[0]!);
                                                var endDate = Provider.of<
                                                                    MatchProvider>(
                                                                context,
                                                                listen: false)
                                                            .selectedDates
                                                            .length >
                                                        1
                                                    ? ConvertDatetime(Provider
                                                            .of<MatchProvider>(
                                                                context,
                                                                listen: false)
                                                        .selectedDates[1]!)
                                                    : 'null';

                                                if (Provider.of<MatchProvider>(
                                                                context,
                                                                listen: false)
                                                            .selectedDates
                                                            .length >
                                                        1 &&
                                                    Provider.of<MatchProvider>(
                                                                context,
                                                                listen: false)
                                                            .selectedDates[0] !=
                                                        Provider.of<MatchProvider>(
                                                                context,
                                                                listen: false)
                                                            .selectedDates[1]) {
                                                  Provider.of<MatchProvider>(
                                                              context,
                                                              listen: false)
                                                          .dateText =
                                                      "${Provider.of<MatchProvider>(context, listen: false).selectedDates[0]!.day.toString().padLeft(2, '0')}/${Provider.of<MatchProvider>(context, listen: false).selectedDates[0]!.month.toString().padLeft(2, '0')} - ${Provider.of<MatchProvider>(context, listen: false).selectedDates[1]!.day.toString().padLeft(2, '0')}/${Provider.of<MatchProvider>(context, listen: false).selectedDates[1]!.month.toString().padLeft(2, '0')}";
                                                } else {
                                                  Provider.of<MatchProvider>(
                                                              context,
                                                              listen: false)
                                                          .dateText =
                                                      "${Provider.of<MatchProvider>(context, listen: false).selectedDates[0]!.day.toString().padLeft(2, '0')}/${Provider.of<MatchProvider>(context, listen: false).selectedDates[0]!.month.toString().padLeft(2, '0')}";
                                                }
                                                showModal = false;
                                              }
                                            });
                                          },
                                        ),
                                      )
                                    ],
                                  );

                                  showModal = true;
                                });
                              },
                            ),
                          ),
                        ),
                        /*Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: width * 0.02,
                                vertical: appBarHeight * 0.06),
                            height: appBarHeight * 0.33,
                            child: SFSearchFilter(
                              labelText:
                                  Provider.of<MatchProvider>(context).timeText,
                              iconPath: r"assets\icon\clock.svg",
                              margin: EdgeInsets.only(left: width * 0.02),
                              padding: EdgeInsets.symmetric(
                                  vertical: appBarHeight * 0.02),
                              onTap: () {
                                setState(
                                  () {
                                    modalWidget = Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: width * 0.05,
                                              vertical: height * 0.02),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: FittedBox(
                                                  fit: BoxFit.fitWidth,
                                                  child: Text(
                                                    "Que horas você quer jogar?",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: AppTheme.colors
                                                            .primaryBlue),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        RangeSlider(
                                          values: _currentRangeValues,
                                          min: 0,
                                          max: 23,
                                          //divisions: 5,
                                          onChanged: (RangeValues values) {
                                            setState(() {
                                              print(_currentRangeValues.start
                                                  .toString());
                                              print(_currentRangeValues.end
                                                  .toString());
                                              _currentRangeValues = values;
                                            });
                                          },
                                        ),
                                      ],
                                    );
                                    showModal = true;
                                  },
                                );
                              },
                            ),
                          ),
                        ),*/

                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: width * 0.02,
                                vertical: appBarHeight * 0.06),
                            height: appBarHeight * 0.33,
                            child: SFSearchFilter(
                              labelText:
                                  Provider.of<MatchProvider>(context).timeText,
                              iconPath: r"assets\icon\clock.svg",
                              margin: EdgeInsets.only(left: width * 0.02),
                              padding: EdgeInsets.symmetric(
                                  vertical: appBarHeight * 0.02),
                              onTap: () {
                                setState(() {
                                  modalWidget = Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: width * 0.05,
                                            vertical: height * 0.02),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: FittedBox(
                                                fit: BoxFit.fitWidth,
                                                child: Text(
                                                  "Que horas você quer jogar?",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppTheme
                                                          .colors.primaryBlue),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    left: width * 0.08)),
                                            SFButton(
                                                textPadding: EdgeInsets.all(
                                                    width * 0.01),
                                                buttonLabel: "Limpar",
                                                buttonType: ButtonType.Primary,
                                                onTap: () {
                                                  setState(() {
                                                    Provider.of<MatchProvider>(
                                                                context,
                                                                listen: false)
                                                            .selectedTime =
                                                        defaultTimePickerRange;
                                                    Provider.of<MatchProvider>(
                                                                context,
                                                                listen: false)
                                                            .timeText =
                                                        "${Provider.of<MatchProvider>(context, listen: false).selectedTime!.start.hour.toString().padLeft(2, '0')}:${Provider.of<MatchProvider>(context, listen: false).selectedTime!.start.minute.toString().padLeft(2, '0')} - ${Provider.of<MatchProvider>(context, listen: false).selectedTime!.end.hour.toString().padLeft(2, '0')}:${Provider.of<MatchProvider>(context, listen: false).selectedTime!.end.minute.toString().padLeft(2, '0')}";
                                                    showModal = false;
                                                  });
                                                })
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: height * 0.02),
                                        child: TimeRange(
                                          fromTitle: Text(
                                            'De',
                                          ),
                                          toTitle: Text(
                                            'Até',
                                          ),
                                          titlePadding: 20,
                                          textStyle: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black87),
                                          activeTextStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                          borderColor:
                                              AppTheme.colors.primaryBlue,
                                          backgroundColor: Colors.transparent,
                                          activeBackgroundColor:
                                              AppTheme.colors.primaryBlue,
                                          initialRange:
                                              Provider.of<MatchProvider>(
                                                      context,
                                                      listen: false)
                                                  .selectedTime,
                                          firstTime:
                                              TimeOfDay(hour: 0, minute: 0),
                                          lastTime:
                                              TimeOfDay(hour: 23, minute: 30),
                                          timeStep: 60,
                                          timeBlock: 60,
                                          onRangeCompleted: (range) => setState(
                                              () => Provider.of<MatchProvider>(
                                                      context,
                                                      listen: false)
                                                  .selectedTime = range),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: height * 0.02,
                                            horizontal: width * 0.15),
                                        child: SFButton(
                                            iconPath: r"assets\icon\search.svg",
                                            buttonLabel: "Aplicar Filtro",
                                            textPadding: EdgeInsets.symmetric(
                                                vertical: appBarHeight * 0.02),
                                            buttonType: ButtonType.Secondary,
                                            onTap: () {
                                              setState(() {
                                                if (Provider.of<MatchProvider>(
                                                            context,
                                                            listen: false)
                                                        .selectedTime !=
                                                    null) {
                                                  Provider.of<MatchProvider>(
                                                              context,
                                                              listen: false)
                                                          .timeText =
                                                      "${Provider.of<MatchProvider>(context, listen: false).selectedTime!.start.hour.toString().padLeft(2, '0')}:${Provider.of<MatchProvider>(context, listen: false).selectedTime!.start.minute.toString().padLeft(2, '0')} - ${Provider.of<MatchProvider>(context, listen: false).selectedTime!.end.hour.toString().padLeft(2, '0')}:${Provider.of<MatchProvider>(context, listen: false).selectedTime!.end.minute.toString().padLeft(2, '0')}";
                                                }
                                                showModal = false;
                                              });
                                            }),
                                      )
                                    ],
                                  );
                                  showModal = true;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.02,
                          vertical: appBarHeight * 0.06),
                      height: appBarHeight * 0.33,
                      child: SFButton(
                          buttonLabel: "Buscar",
                          buttonType: ButtonType.Secondary,
                          iconPath: r"assets\icon\search.svg",
                          textPadding: EdgeInsets.symmetric(
                              vertical: appBarHeight * 0.02),
                          onTap: () {
                            if (Provider.of<MatchProvider>(context,
                                            listen: false)
                                        .selectedDates ==
                                    null ||
                                Provider.of<MatchProvider>(context,
                                            listen: false)
                                        .selectedRegion ==
                                    null) {
                              print("erro");
                            } else {
                              Provider.of<MatchProvider>(context, listen: false)
                                      .selectedTime ??=
                                  TimeRangeResult(
                                      const TimeOfDay(hour: 00, minute: 00),
                                      const TimeOfDay(hour: 23, minute: 30));
                              loadDates();
                            }
                          }),
                    ),
                  ],
                ),
              ),
              Provider.of<MatchProvider>(context).searchStatus ==
                      EnumSearchStatus.NoFilterApplied
                  ? Expanded(
                      child: Container(
                          color: AppTheme.colors.secondaryBack,
                          child: Center(
                            child: Container(
                              height: height * 0.2,
                              padding: EdgeInsets.only(
                                  left: width * 0.2, right: width * 0.2),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SvgPicture.asset(
                                    r"assets\icon\happy_face.svg",
                                    height: height * 0.1,
                                  ),
                                  SizedBox(
                                    height: height * 0.05,
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        "Use os filtros para buscar por\n quadras e partidas disponíveis.",
                                        style: TextStyle(
                                          color: AppTheme.colors.textBlue,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height:
                                        height * 0.01 > 4 ? 4 : height * 0.01,
                                    width: width * 0.8,
                                    color: AppTheme.colors.divider,
                                  ),
                                ],
                              ),
                            ),
                          )),
                    )
                  : Provider.of<MatchProvider>(context).searchStatus ==
                          EnumSearchStatus.NoResultsFound
                      ? Expanded(
                          child: Container(
                              color: AppTheme.colors.secondaryBack,
                              child: Center(
                                child: Container(
                                  height: height * 0.2,
                                  padding: EdgeInsets.only(
                                      left: width * 0.2, right: width * 0.2),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      SvgPicture.asset(
                                        r"assets\icon\sad_face.svg",
                                        height: height * 0.1,
                                      ),
                                      SizedBox(
                                        height: height * 0.05,
                                        child: FittedBox(
                                          fit: BoxFit.contain,
                                          child: Text(
                                            "Ops! Não encontramos resultados. \nTente outra data ou horário.",
                                            style: TextStyle(
                                              color: AppTheme.colors.textBlue,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: height * 0.01 > 4
                                            ? 4
                                            : height * 0.01,
                                        width: width * 0.8,
                                        color: AppTheme.colors.divider,
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        )
                      : Provider.of<MatchProvider>(context).searchStatus ==
                              EnumSearchStatus.Results
                          ? Expanded(
                              child: Container(
                                color: AppTheme.colors.secondaryBack,
                                child: Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                          vertical: height * 0.01),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: CupertinoSegmentedControl(
                                          borderColor: Colors.transparent,
                                          unselectedColor:
                                              AppTheme.colors.textDisabled,
                                          selectedColor:
                                              AppTheme.colors.primaryBlue,
                                          children: segmentedTexts,
                                          onValueChanged: (int val) {
                                            setState(() {
                                              segmentedTextValue = val;
                                            });
                                          },
                                          groupValue: segmentedTextValue),
                                    ),
                                    segmentedTextValue == 0 ||
                                            segmentedTextValue == 1
                                        ? Expanded(
                                            child: ListView.builder(
                                              itemCount: courts.length,
                                              itemBuilder: ((context, index) {
                                                if ((index == 0) ||
                                                    (courts[index].day !=
                                                        courts[index - 1]
                                                            .day)) {
                                                  return Column(
                                                    children: [
                                                      index == 0
                                                          ? Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          width *
                                                                              0.05),
                                                              child: Row(
                                                                children: [
                                                                  SvgPicture.asset(
                                                                      r'assets\icon\court.svg'),
                                                                  Container(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            width *
                                                                                0.02),
                                                                    child: Text(
                                                                      "Quadras",
                                                                      style: TextStyle(
                                                                          color: AppTheme
                                                                              .colors
                                                                              .primaryBlue,
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: SvgPicture
                                                                        .asset(
                                                                            r'assets\icon\divider.svg'),
                                                                  )
                                                                ],
                                                              ),
                                                            )
                                                          : Container(),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    width *
                                                                        0.03,
                                                                vertical:
                                                                    height *
                                                                        0.02),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right: 5),
                                                              child: SvgPicture
                                                                  .asset(
                                                                      r'assets\icon\calendar.svg'),
                                                            ),
                                                            Text(
                                                              courts[index].day,
                                                              style: TextStyle(
                                                                  color: AppTheme
                                                                      .colors
                                                                      .primaryBlue,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: (() {
                                                          Provider.of<MatchProvider>(
                                                                      context,
                                                                      listen: false)
                                                                  .selectedCourt =
                                                              courts[index];
                                                          context.goNamed(
                                                              'court_screen',
                                                              params: {
                                                                'param':
                                                                    'viewOnly'
                                                              });
                                                        }),
                                                        child: SFCourtCard(
                                                            court:
                                                                courts[index]),
                                                      )
                                                    ],
                                                  );
                                                } else {
                                                  return InkWell(
                                                    onTap: (() {
                                                      Provider.of<MatchProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .selectedCourt =
                                                          courts[index];
                                                      context.goNamed(
                                                          'court_screen',
                                                          params: {
                                                            'param': 'viewOnly'
                                                          });
                                                    }),
                                                    child: SFCourtCard(
                                                        court: courts[index]),
                                                  );
                                                }
                                              }),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                            )
                          : Expanded(
                              child: Container(
                                  color: AppTheme.colors.secondaryBack,
                                  child: Center(
                                    child: Container(
                                      height: height * 0.2,
                                      padding: EdgeInsets.only(
                                          left: width * 0.2,
                                          right: width * 0.2),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          SvgPicture.asset(
                                            r"assets\icon\sad_face.svg",
                                            height: height * 0.1,
                                          ),
                                          SizedBox(
                                            height: height * 0.05,
                                            child: FittedBox(
                                              fit: BoxFit.contain,
                                              child: Text(
                                                "Ops! Tivemos um problema. \nTente novamente.",
                                                style: TextStyle(
                                                  color:
                                                      AppTheme.colors.textBlue,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: height * 0.01 > 4
                                                ? 4
                                                : height * 0.01,
                                            width: width * 0.8,
                                            color: AppTheme.colors.divider,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                            )
            ],
          ),
        ],
      ),
    );
  }

  Future<void> loadDates() async {
    var response = await http.post(
      Uri.parse('https://www.sandfriends.com.br/SearchCourts'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, Object>{
        'sportId': Provider.of<MatchProvider>(context, listen: false)
            .selectedSport!
            .idSport
            .toString(),
        'cityId': Provider.of<MatchProvider>(context, listen: false)
            .selectedRegion!
            .selectedCity!
            .cityId
            .toString(),
        'dateStart': DateFormat("yyyy-MM-dd").format(
            Provider.of<MatchProvider>(context, listen: false)
                .selectedDates[0]!),
        'dateEnd': Provider.of<MatchProvider>(context, listen: false)
                    .selectedDates
                    .length <
                2
            ? DateFormat("yyyy-MM-dd").format(
                Provider.of<MatchProvider>(context, listen: false)
                    .selectedDates[0]!)
            : DateFormat("yyyy-MM-dd").format(
                Provider.of<MatchProvider>(context, listen: false)
                    .selectedDates[1]!),
        'timeStart': Provider.of<MatchProvider>(context, listen: false)
            .selectedTime!
            .start
            .format(context),
        'timeEnd': Provider.of<MatchProvider>(context, listen: false)
            .selectedTime!
            .end
            .format(context),
      }),
    );
    if (response.statusCode == 200) {
      Provider.of<MatchProvider>(context, listen: false).clearCourts();
      Provider.of<MatchProvider>(context, listen: false).clearStores();
      final responseBody = json.decode(response.body);
      final courts = responseBody['dates'];
      final stores = responseBody['stores'];

      for (int i = 0; i < stores.length; i++) {
        Store newStore = Store();
        Map storeJson = stores[i];
        newStore.idStore = storeJson['IdStore'];
        newStore.name = storeJson['name'];
        newStore.address = storeJson['address'];
        newStore.imageUrl = storeJson['imageURL'];
        newStore.descriptionText = storeJson['description'];
        for (int photoIndex = 0;
            photoIndex < storeJson['storePhotos'].length;
            photoIndex++) {
          Map photo = storeJson['storePhotos'][photoIndex];
          newStore.addPhoto(photo['storePhoto']);
        }
        Provider.of<MatchProvider>(context, listen: false).addStore(newStore);
      }

      Court court = Court();
      int courtIndexTotal = 0;

      for (int dateIndex = 0; dateIndex < courts.length; dateIndex++) {
        Map firstLevel = courts[dateIndex];
        for (int courtIndex = 0;
            courtIndex < firstLevel['places'].length;
            courtIndex++) {
          Map secondLevel = firstLevel['places'][courtIndex];
          court.day = firstLevel['date'];
          Provider.of<MatchProvider>(context, listen: false)
              .stores
              .forEach((store) {
            if (store.idStore == secondLevel['IdStore']) {
              court.store = store;
            }
          });
          for (int availableHoursIndex = 0;
              availableHoursIndex < secondLevel['available'].length;
              availableHoursIndex++) {
            Map thirdLevel = secondLevel['available'][availableHoursIndex];
            List<CourtPrice> courtPriceList = [];
            for (int availableCourts = 0;
                availableCourts < thirdLevel['courts'].length;
                availableCourts++) {
              Map fourthLevel = thirdLevel['courts'][availableCourts];
              courtPriceList.add(CourtPrice(
                  fourthLevel['idStoreCourt'], fourthLevel['price']));
            }
            court.availableHours.add(CourtAvailableHours(availableHoursIndex,
                thirdLevel['time'], thirdLevel['timeInt'], courtPriceList));
          }
          court.index = courtIndexTotal;
          courtIndexTotal++;
          Provider.of<MatchProvider>(context, listen: false).addCourt(court);
          court = Court();
        }
      }

      Provider.of<MatchProvider>(context, listen: false).searchStatus =
          EnumSearchStatus.Results;
    } else if (response.statusCode == 412) {
      Provider.of<MatchProvider>(context, listen: false).searchStatus =
          EnumSearchStatus.NoResultsFound;
    } else {
      Provider.of<MatchProvider>(context, listen: false).searchStatus =
          EnumSearchStatus.Error;
    }
  }

  Future<void> GetCities(BuildContext context) async {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    var response = await http
        .get(Uri.parse('https://www.sandfriends.com.br/GetAvailableCities'));

    if (response.statusCode == 200) {
      Provider.of<MatchProvider>(context, listen: false).clearRegions();
      final cities = json.decode(response.body);
      bool stateExists = false;

      for (int i = 0; i < cities.length; i++) {
        stateExists = false;
        Provider.of<MatchProvider>(context, listen: false)
            .availableRegions
            .forEach((region) {
          if (region.state == cities[i]["cityState"]) {
            stateExists = true;
            Provider.of<MatchProvider>(context, listen: false).addCity(
                region,
                City(
                    cityId: int.parse(cities[i]["cityId"]),
                    city: cities[i]["cityName"]));
          }
        });

        if (!stateExists) {
          Region newRegion =
              Region(state: cities[i]["cityState"], uf: cities[i]["cityUF"]);
          Provider.of<MatchProvider>(context, listen: false)
              .addRegion(newRegion);
          Provider.of<MatchProvider>(context, listen: false).addCity(
              newRegion,
              City(
                  cityId: int.parse(cities[i]["cityId"]),
                  city: cities[i]["cityName"]));
        }
      }
    }

    List<Region> _availableRegions =
        Provider.of<MatchProvider>(context, listen: false).availableRegions;

    modalWidget = Container(
      height: height * 0.7,
      child: Column(
        children: [
          Container(
              height: height * 0.07,
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.1, vertical: height * 0.01),
              child: FittedBox(
                  fit: BoxFit.fill,
                  child: Text(
                    "Escolha a cidade",
                    style: TextStyle(color: AppTheme.colors.primaryBlue),
                  ))),
          Expanded(
            child: ListView.builder(
              itemCount: _availableRegions.length,
              itemBuilder: (BuildContext context, int index) {
                return ExpansionTile(
                  title: Text(
                    _availableRegions[index].state,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  children: _availableRegions[index]
                      .cities
                      .map(
                        (city) => InkWell(
                          child: Container(
                            padding:
                                EdgeInsets.symmetric(vertical: height * 0.01),
                            child: Text(city.city),
                          ),
                          onTap: () {
                            setState(() {
                              _availableRegions.forEach((region) {
                                if (region.state ==
                                    _availableRegions[index].state) {
                                  region.cities.forEach((cityList) {
                                    if (cityList.city == city.city) {
                                      Provider.of<MatchProvider>(context,
                                              listen: false)
                                          .selectedRegion = Region(
                                        state: _availableRegions[index].state,
                                        uf: _availableRegions[index].uf,
                                      );
                                      Provider.of<MatchProvider>(context,
                                                  listen: false)
                                              .selectedRegion!
                                              .selectedCity =
                                          City(
                                              cityId: cityList.cityId,
                                              city: cityList.city);
                                    }
                                  });
                                }
                              });
                              Provider.of<MatchProvider>(context, listen: false)
                                  .regionText = Provider.of<MatchProvider>(
                                          context,
                                          listen: false)
                                      .selectedRegion!
                                      .selectedCity!
                                      .city +
                                  "/" +
                                  Provider.of<MatchProvider>(context,
                                          listen: false)
                                      .selectedRegion!
                                      .uf;
                              showModal = false;
                            });
                          },
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
