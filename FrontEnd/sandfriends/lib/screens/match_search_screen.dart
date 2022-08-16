import 'dart:convert';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/models/court.dart';
import 'package:sandfriends/models/court_available_hours.dart';
import 'package:sandfriends/widgets/Modal/SF_ModalDatePicker.dart';
import 'package:sandfriends/widgets/SF_CourtCard.dart';
import 'package:sandfriends/widgets/SF_Scaffold.dart';
import 'package:sandfriends/widgets/SF_SearchFilter.dart';
import '../models/enums.dart';
import 'package:time_range/time_range.dart';
import 'dart:async';

import '../../models/enums.dart';
import '../../theme/app_theme.dart';
import '../../widgets/SF_Button.dart';
import '../providers/match_provider.dart';

class MatchSearchScreen extends StatefulWidget {
  const MatchSearchScreen({Key? key}) : super(key: key);

  @override
  State<MatchSearchScreen> createState() => _MatchSearchScreen();
}

class _MatchSearchScreen extends State<MatchSearchScreen> {
  List<Court> courts = [];

  bool showModal = false;
  Widget? modalWidget;
  SearchFilter? searchFilter;

  String localText = "Cidade";
  String dateText = "Data";
  String timeText = "Hora";

  List<DateTime?> datePickerRange = [];

  TimeRangeResult? timePickerRange;
  final defaultTimePickerRange = TimeRangeResult(
    const TimeOfDay(hour: 0, minute: 0),
    const TimeOfDay(hour: 23, minute: 30),
  );

  final Map<int, Widget> segmentedTexts = <int, Widget>{
    0: Text("Todos"),
    1: Text("Quadras"),
    2: Text("Partidas"),
  };
  int segmentedTextValue = 0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double appBarHeight = height * 0.3 > 150 ? 150 : height * 0.3;

    String ConvertDatetime(DateTime dateTime) {
      return dateTime.toString().replaceAll('00:00:00.000', '');
    }

    return SFScaffold(
      titleText:
          "Busca - ${Provider.of<MatchProvider>(context).matchSport!.toShortString()}",
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
                        labelText: localText,
                        iconPath: r"assets\icon\location_ping.svg",
                        margin: EdgeInsets.only(left: width * 0.02),
                        padding:
                            EdgeInsets.symmetric(vertical: appBarHeight * 0.02),
                        onTap: () {
                          setState(() {
                            showModal = true;
                            searchFilter = SearchFilter.Local;
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
                              labelText: dateText,
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
                                            controlsTextStyle: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          initialValue: datePickerRange,
                                          onValueChanged: (values) => setState(
                                              () => datePickerRange = values),
                                        ),
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
                                              if (datePickerRange.isNotEmpty) {
                                                var startDate = ConvertDatetime(
                                                    datePickerRange[0]!);
                                                var endDate =
                                                    datePickerRange.length > 1
                                                        ? ConvertDatetime(
                                                            datePickerRange[1]!)
                                                        : 'null';

                                                if (datePickerRange.length >
                                                    1) {
                                                  dateText =
                                                      "${datePickerRange[0]!.day.toString().padLeft(2, '0')}/${datePickerRange[0]!.month.toString().padLeft(2, '0')} - ${datePickerRange[1]!.day.toString().padLeft(2, '0')}/${datePickerRange[1]!.month.toString().padLeft(2, '0')}";
                                                } else {
                                                  dateText =
                                                      "${datePickerRange[0]!.day.toString().padLeft(2, '0')}/${datePickerRange[0]!.month.toString().padLeft(2, '0')}";
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
                                  searchFilter = SearchFilter.Date;
                                });
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: width * 0.02,
                                vertical: appBarHeight * 0.06),
                            height: appBarHeight * 0.33,
                            child: SFSearchFilter(
                              labelText: timeText,
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
                                                    timePickerRange =
                                                        defaultTimePickerRange;
                                                    timeText =
                                                        "${timePickerRange!.start.hour.toString().padLeft(2, '0')}:${timePickerRange!.start.minute.toString().padLeft(2, '0')} - ${timePickerRange!.end.hour.toString().padLeft(2, '0')}:${timePickerRange!.end.minute.toString().padLeft(2, '0')}";
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
                                          initialRange: timePickerRange,
                                          firstTime:
                                              TimeOfDay(hour: 0, minute: 0),
                                          lastTime:
                                              TimeOfDay(hour: 23, minute: 30),
                                          timeStep: 30,
                                          timeBlock: 30,
                                          onRangeCompleted: (range) => setState(
                                              () => timePickerRange = range),
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
                                                if (timePickerRange != null) {
                                                  timeText =
                                                      "${timePickerRange!.start.hour.toString().padLeft(2, '0')}:${timePickerRange!.start.minute.toString().padLeft(2, '0')} - ${timePickerRange!.end.hour.toString().padLeft(2, '0')}:${timePickerRange!.end.minute.toString().padLeft(2, '0')}";
                                                }
                                                showModal = false;
                                              });
                                            }),
                                      )
                                    ],
                                  );
                                  showModal = true;
                                  searchFilter = SearchFilter.Time;
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
                            loadDates();
                            setState(() {
                              Provider.of<MatchProvider>(context, listen: false)
                                  .searchStatus = EnumSearchStatus.Results;
                            });
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
                                    child: Text(
                                      "Use os filtros para buscar por quadras e partidas disponíveis.",
                                      style: TextStyle(
                                        color: AppTheme.colors.textBlue,
                                        fontWeight: FontWeight.w700,
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
                  : Expanded(
                      child: Container(
                        color: AppTheme.colors.secondaryBack,
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding:
                                  EdgeInsets.symmetric(vertical: height * 0.01),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: CupertinoSegmentedControl(
                                  borderColor: Colors.transparent,
                                  unselectedColor: AppTheme.colors.textDisabled,
                                  selectedColor: AppTheme.colors.primaryBlue,
                                  children: segmentedTexts,
                                  onValueChanged: (int val) {
                                    setState(() {
                                      segmentedTextValue = val;
                                    });
                                  },
                                  groupValue: segmentedTextValue),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: courts.length,
                                itemBuilder: ((context, index) {
                                  if ((index == 0) ||
                                      (courts[index].day !=
                                          courts[index - 1].day)) {
                                    return Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: width * 0.03,
                                              vertical: height * 0.02),
                                          child: Row(
                                            children: [
                                              Container(
                                                padding:
                                                    EdgeInsets.only(right: 5),
                                                child: SvgPicture.asset(
                                                    r'assets\icon\calendar.svg'),
                                              ),
                                              Text(
                                                courts[index].day,
                                                style: TextStyle(
                                                    color: AppTheme
                                                        .colors.primaryBlue,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SFCourtCard(court: courts[index])
                                      ],
                                    );
                                  } else {
                                    return SFCourtCard(court: courts[index]);
                                  }
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
            ],
          ),
        ],
      ),
    );
  }

  Future<void> loadDates() async {
    final String response = await rootBundle.loadString(r'assets\match.json');
    final payload = await json.decode(response)['dates'];

    for (int dateIndex = 0; dateIndex < payload.length; dateIndex++) {
      Court court = Court();
      Map firstLevel = payload[dateIndex];
      court.day = firstLevel['date'];
      for (int courtIndex = 0;
          courtIndex < firstLevel['places'].length;
          courtIndex++) {
        Map secondLevel = firstLevel['places'][courtIndex];
        court.name = secondLevel['name'];
        court.address = secondLevel['address'];
        court.imageUrl = secondLevel['imageUrl'];
        for (int availableHoursIndex = 0;
            availableHoursIndex < secondLevel['available'].length;
            availableHoursIndex++) {
          Map thirdLevel = secondLevel['available'][availableHoursIndex];
          court.availableHours.add(CourtAvailableHours(
              availableHoursIndex, thirdLevel['time'], thirdLevel['price']));
        }
        courts.add(court);
      }
    }
  }
}
