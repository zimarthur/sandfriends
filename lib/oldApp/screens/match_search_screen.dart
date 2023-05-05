import 'dart:convert';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/SharedComponents/Model/Store.dart';
import 'package:sandfriends/SharedComponents/Model/CourtAvailabeHour.dart';
import 'package:sandfriends/SharedComponents/Model/Court.dart';
import 'package:sandfriends/oldApp/providers/court_provider.dart';
import 'package:sandfriends/oldApp/providers/store_provider.dart';
import 'package:sandfriends/oldApp/providers/user_provider.dart';
import 'package:sandfriends/oldApp/widgets/Modal/SF_ModalDatePicker.dart';
import 'package:sandfriends/SharedComponents/View/SFLoading.dart';
import 'package:sandfriends/oldApp/widgets/SF_CourtCard.dart';
import 'package:sandfriends/oldApp/widgets/SF_OpenMatchVertical.dart';
import 'package:sandfriends/oldApp/widgets/SF_Scaffold.dart';
import 'package:sandfriends/oldApp/widgets/SF_SearchFilter.dart';
import 'package:time_range/time_range.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

import '../../SharedComponents/Model/City.dart';
import '../../SharedComponents/Model/Region.dart';
import '../../SharedComponents/Model/StoreDay.dart';
import '../models/enums.dart';
import '../models/enums.dart';
import '../theme/app_theme.dart';
import '../widgets/SF_Button.dart';
import '../../SharedComponents/Model/Store.dart';
import '../providers/match_provider.dart';
import '../providers/redirect_provider.dart';
import '../providers/store_provider.dart';
import '../widgets/SF_OpenMatchHorizontal.dart';

class MatchSearchScreen extends StatefulWidget {
  const MatchSearchScreen({Key? key}) : super(key: key);

  @override
  State<MatchSearchScreen> createState() => _MatchSearchScreen();
}

class _MatchSearchScreen extends State<MatchSearchScreen> {
  bool isLoading = false;

  int? selectedCourt;
  int? selectedTime;

  bool showModal = false;
  Widget? modalWidget;

  final RangeValues _currentRangeValues = const RangeValues(0, 23);

  TimeRangeResult? timePickerRange;
  final defaultTimePickerRange = TimeRangeResult(
    const TimeOfDay(hour: 01, minute: 0),
    const TimeOfDay(hour: 23, minute: 00),
  );

  final Map<int, Widget> segmentedTexts = <int, Widget>{
    0: const Text("Todos"),
    1: const Text("Quadras"),
    2: const Text("Partidas"),
  };
  int segmentedTextValue = 0;

  VoidCallback onBackgroundTapFunc = () {};

  @override
  Widget build(BuildContext context) {
    Provider.of<Redirect>(context, listen: false).originalPage =
        EnumReturnPages.MatchSearchScreen;

    final storeDayList =
        List.from(Provider.of<MatchProvider>(context).storeDayList);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double appBarHeight = height * 0.3 > 150 ? 150 : height * 0.3;

    String ConvertDatetime(DateTime dateTime) {
      return dateTime.toString().replaceAll('00:00:00.000', '');
    }

    if (Provider.of<MatchProvider>(context, listen: false).needsRefresh ==
        true) {
      if (Provider.of<MatchProvider>(context, listen: false).selectedRegion ==
          null) {
        Provider.of<MatchProvider>(context, listen: false).storeDayList.clear();
      } else {
        loadDates();
      }
    }
    return SFScaffold(
      titleText:
          "Busca - ${Provider.of<MatchProvider>(context).selectedSport!.description}",
      onTapReturn: () => context
          .goNamed('home', params: {'initialPage': 'sport_selection_screen'}),
      appBarType: AppBarType.Primary,
      showModal: showModal,
      modalWidget: modalWidget,
      onTapBackground: () {
        onBackgroundTapFunc();
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
                            showModal = true;
                            modalWidget = SizedBox(
                              height: height * 0.7,
                              child: const Center(
                                child: SFLoading(),
                              ),
                            );
                            GetCities(context);
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
                                onBackgroundTapFunc = () {
                                  setState(() {
                                    if (Provider.of<MatchProvider>(context,
                                            listen: false)
                                        .selectedDates
                                        .isNotEmpty) {
                                      var startDate = ConvertDatetime(
                                          Provider.of<MatchProvider>(context,
                                                  listen: false)
                                              .selectedDates[0]!);
                                      var endDate = Provider.of<MatchProvider>(
                                                      context,
                                                      listen: false)
                                                  .selectedDates
                                                  .length >
                                              1
                                          ? ConvertDatetime(
                                              Provider.of<MatchProvider>(
                                                      context,
                                                      listen: false)
                                                  .selectedDates[1]!)
                                          : 'null';

                                      if (Provider.of<MatchProvider>(context,
                                                      listen: false)
                                                  .selectedDates
                                                  .length >
                                              1 &&
                                          Provider.of<MatchProvider>(context,
                                                      listen: false)
                                                  .selectedDates[0] !=
                                              Provider.of<MatchProvider>(
                                                      context,
                                                      listen: false)
                                                  .selectedDates[1]) {
                                        Provider.of<MatchProvider>(context,
                                                    listen: false)
                                                .dateText =
                                            "${Provider.of<MatchProvider>(context, listen: false).selectedDates[0]!.day.toString().padLeft(2, '0')}/${Provider.of<MatchProvider>(context, listen: false).selectedDates[0]!.month.toString().padLeft(2, '0')} - ${Provider.of<MatchProvider>(context, listen: false).selectedDates[1]!.day.toString().padLeft(2, '0')}/${Provider.of<MatchProvider>(context, listen: false).selectedDates[1]!.month.toString().padLeft(2, '0')}";
                                      } else {
                                        Provider.of<MatchProvider>(context,
                                                    listen: false)
                                                .dateText =
                                            "${Provider.of<MatchProvider>(context, listen: false).selectedDates[0]!.day.toString().padLeft(2, '0')}/${Provider.of<MatchProvider>(context, listen: false).selectedDates[0]!.month.toString().padLeft(2, '0')}";
                                      }
                                      showModal = false;
                                    }
                                  });
                                };
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
                                  onBackgroundTapFunc = () {
                                    setState(() {
                                      if (Provider.of<MatchProvider>(context,
                                                  listen: false)
                                              .selectedTimeRange !=
                                          null) {
                                        Provider.of<MatchProvider>(context,
                                                    listen: false)
                                                .timeText =
                                            "${Provider.of<MatchProvider>(context, listen: false).selectedTimeRange!.start.hour.toString().padLeft(2, '0')}:${Provider.of<MatchProvider>(context, listen: false).selectedTimeRange!.start.minute.toString().padLeft(2, '0')} - ${Provider.of<MatchProvider>(context, listen: false).selectedTimeRange!.end.hour.toString().padLeft(2, '0')}:${Provider.of<MatchProvider>(context, listen: false).selectedTimeRange!.end.minute.toString().padLeft(2, '0')}";
                                      }
                                      showModal = false;
                                    });
                                  };
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
                                                            .selectedTimeRange =
                                                        defaultTimePickerRange;
                                                    Provider.of<MatchProvider>(
                                                                context,
                                                                listen: false)
                                                            .timeText =
                                                        "${Provider.of<MatchProvider>(context, listen: false).selectedTimeRange!.start.hour.toString().padLeft(2, '0')}:${Provider.of<MatchProvider>(context, listen: false).selectedTimeRange!.start.minute.toString().padLeft(2, '0')} - ${Provider.of<MatchProvider>(context, listen: false).selectedTimeRange!.end.hour.toString().padLeft(2, '0')}:${Provider.of<MatchProvider>(context, listen: false).selectedTimeRange!.end.minute.toString().padLeft(2, '0')}";
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
                                          fromTitle: const Text(
                                            'De',
                                          ),
                                          toTitle: const Text(
                                            'Até',
                                          ),
                                          titlePadding: 20,
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black87),
                                          activeTextStyle: const TextStyle(
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
                                                  .selectedTimeRange,
                                          firstTime: const TimeOfDay(
                                              hour: 1, minute: 0),
                                          lastTime: const TimeOfDay(
                                              hour: 23, minute: 00),
                                          timeStep: 60,
                                          timeBlock: 60,
                                          onRangeCompleted: (range) => setState(
                                              () => Provider.of<MatchProvider>(
                                                      context,
                                                      listen: false)
                                                  .selectedTimeRange = range),
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
                                                        .selectedTimeRange !=
                                                    null) {
                                                  Provider.of<MatchProvider>(
                                                              context,
                                                              listen: false)
                                                          .timeText =
                                                      "${Provider.of<MatchProvider>(context, listen: false).selectedTimeRange!.start.hour.toString().padLeft(2, '0')}:${Provider.of<MatchProvider>(context, listen: false).selectedTimeRange!.start.minute.toString().padLeft(2, '0')} - ${Provider.of<MatchProvider>(context, listen: false).selectedTimeRange!.end.hour.toString().padLeft(2, '0')}:${Provider.of<MatchProvider>(context, listen: false).selectedTimeRange!.end.minute.toString().padLeft(2, '0')}";
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
                                    .selectedDates
                                    .isEmpty ||
                                Provider.of<MatchProvider>(context,
                                            listen: false)
                                        .selectedRegion ==
                                    null) {
                              print("erro");
                            } else {
                              setState(() {
                                isLoading = true;
                              });
                              Provider.of<MatchProvider>(context, listen: false)
                                      .selectedTimeRange ??=
                                  TimeRangeResult(
                                      const TimeOfDay(hour: 1, minute: 00),
                                      const TimeOfDay(hour: 23, minute: 00));
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
                                    Expanded(
                                      child: segmentedTextValue == 0
                                          ? storeDayList.isEmpty
                                              ? Column(
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      width *
                                                                          0.05),
                                                          child: Row(
                                                            children: [
                                                              SvgPicture.asset(
                                                                  r'assets\icon\trophy.svg'),
                                                              Container(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                  horizontal:
                                                                      width *
                                                                          0.02,
                                                                ),
                                                                child: Text(
                                                                  "Partidas Abertas",
                                                                  style: TextStyle(
                                                                      color: AppTheme
                                                                          .colors
                                                                          .primaryBlue,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: SvgPicture
                                                                    .asset(
                                                                        r'assets\icon\divider.svg'),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      width *
                                                                          0.05),
                                                          width:
                                                              double.infinity,
                                                          child: Text(
                                                            "Escolha uma partida e desafie novos jogadores",
                                                            textScaleFactor:
                                                                0.9,
                                                            style: TextStyle(
                                                                color: AppTheme
                                                                    .colors
                                                                    .textDarkGrey),
                                                          ),
                                                        ),
                                                        Container(
                                                          height: 240,
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      height *
                                                                          0.02),
                                                          child:
                                                              ListView.builder(
                                                            itemCount: Provider
                                                                    .of<MatchProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                .openMatchList
                                                                .length,
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            itemBuilder:
                                                                ((context,
                                                                    index) {
                                                              return SFOpenMatchHorizontal(
                                                                match: Provider.of<
                                                                            MatchProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .openMatchList[index],
                                                              );
                                                            }),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  width * 0.05),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              SvgPicture.asset(
                                                                  r'assets\icon\court.svg'),
                                                              Container(
                                                                padding: EdgeInsets
                                                                    .symmetric(
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
                                                                          FontWeight
                                                                              .w700),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: SvgPicture
                                                                    .asset(
                                                                        r'assets\icon\divider.svg'),
                                                              )
                                                            ],
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                              vertical:
                                                                  height * 0.04,
                                                            ),
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              "Nenhuma horário disponível",
                                                              style: TextStyle(
                                                                color: AppTheme
                                                                    .colors
                                                                    .textLightGrey,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                )
                                              : ListView.builder(
                                                  itemCount:
                                                      storeDayList.length,
                                                  itemBuilder:
                                                      ((context, index) {
                                                    if ((index == 0) ||
                                                        (storeDayList[index]
                                                                .day !=
                                                            storeDayList[
                                                                    index - 1]
                                                                .day)) {
                                                      return Column(
                                                        children: [
                                                          index == 0
                                                              ? Column(
                                                                  children: [
                                                                    Provider.of<MatchProvider>(context,
                                                                                listen: false)
                                                                            .openMatchList
                                                                            .isNotEmpty
                                                                        ? Column(
                                                                            children: [
                                                                              Container(
                                                                                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                                                                                child: Row(
                                                                                  children: [
                                                                                    SvgPicture.asset(r'assets\icon\trophy.svg'),
                                                                                    Container(
                                                                                      padding: EdgeInsets.symmetric(
                                                                                        horizontal: width * 0.02,
                                                                                      ),
                                                                                      child: Text(
                                                                                        "Partidas Abertas",
                                                                                        style: TextStyle(color: AppTheme.colors.primaryBlue, fontWeight: FontWeight.w700),
                                                                                      ),
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: SvgPicture.asset(r'assets\icon\divider.svg'),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                                                                                width: double.infinity,
                                                                                child: Text(
                                                                                  "Escolha uma partida e desafie novos jogadores",
                                                                                  textScaleFactor: 0.9,
                                                                                  style: TextStyle(color: AppTheme.colors.textDarkGrey),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                height: 240,
                                                                                margin: EdgeInsets.symmetric(vertical: height * 0.02),
                                                                                child: ListView.builder(
                                                                                  itemCount: Provider.of<MatchProvider>(context, listen: false).openMatchList.length,
                                                                                  scrollDirection: Axis.horizontal,
                                                                                  itemBuilder: ((context, index) {
                                                                                    return SFOpenMatchHorizontal(
                                                                                      match: Provider.of<MatchProvider>(context, listen: false).openMatchList[index],
                                                                                    );
                                                                                  }),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          )
                                                                        : Container(
                                                                            padding:
                                                                                EdgeInsets.symmetric(horizontal: width * 0.05),
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                Row(
                                                                                  children: [
                                                                                    SvgPicture.asset(r'assets\icon\trophy.svg'),
                                                                                    Container(
                                                                                      padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                                                                                      child: Text(
                                                                                        "Partidas Abertas",
                                                                                        style: TextStyle(color: AppTheme.colors.primaryBlue, fontWeight: FontWeight.w700),
                                                                                      ),
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: SvgPicture.asset(r'assets\icon\divider.svg'),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                                Container(
                                                                                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                                                                                  width: double.infinity,
                                                                                  child: Text(
                                                                                    "Escolha uma partida e desafie novos jogadores",
                                                                                    textScaleFactor: 0.9,
                                                                                    style: TextStyle(color: AppTheme.colors.textDarkGrey),
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  margin: EdgeInsets.symmetric(
                                                                                    vertical: height * 0.04,
                                                                                  ),
                                                                                  alignment: Alignment.center,
                                                                                  child: Text(
                                                                                    "Sem partidas abertas",
                                                                                    style: TextStyle(
                                                                                      color: AppTheme.colors.textLightGrey,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(
                                                                                    bottom: height * 0.02,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                    Container(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              width * 0.05),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              SvgPicture.asset(r'assets\icon\court.svg'),
                                                                              Container(
                                                                                padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                                                                                child: Text(
                                                                                  "Quadras",
                                                                                  style: TextStyle(color: AppTheme.colors.primaryBlue, fontWeight: FontWeight.w700),
                                                                                ),
                                                                              ),
                                                                              Expanded(
                                                                                child: SvgPicture.asset(r'assets\icon\divider.svg'),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          Container(
                                                                            padding:
                                                                                EdgeInsets.symmetric(horizontal: width * 0.05),
                                                                            width:
                                                                                double.infinity,
                                                                            child:
                                                                                Text(
                                                                              "Agende um horário na sua quadra de preferência",
                                                                              textScaleFactor: 0.9,
                                                                              style: TextStyle(color: AppTheme.colors.textDarkGrey),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
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
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      right: 5),
                                                                  child: SvgPicture
                                                                      .asset(
                                                                          r'assets\icon\calendar.svg'),
                                                                ),
                                                                Text(
                                                                  storeDayList[
                                                                          index]
                                                                      .day,
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
                                                              setState(() {
                                                                isLoading =
                                                                    true;
                                                              });
                                                              Provider.of<MatchProvider>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .selectedStoreDay =
                                                                  storeDayList[
                                                                      index];

                                                              context.goNamed(
                                                                  'court_screen',
                                                                  params: {
                                                                    'viewOnly':
                                                                        'viewOnly',
                                                                    'returnTo':
                                                                        'match_search_screen',
                                                                    'returnToParam':
                                                                        'null',
                                                                    'returnToParamValue':
                                                                        'null',
                                                                    'isRecurrentMatch':
                                                                        'null'
                                                                  });
                                                            }),
                                                            child: SFCourtCard(
                                                                onOnTap: () {
                                                                  setState(() {
                                                                    isLoading =
                                                                        true;
                                                                  });
                                                                },
                                                                widgetIndexStore:
                                                                    index,
                                                                storeDay:
                                                                    storeDayList[
                                                                        index]),
                                                          )
                                                        ],
                                                      );
                                                    } else {
                                                      return InkWell(
                                                        onTap: (() {
                                                          Provider.of<MatchProvider>(
                                                                      context,
                                                                      listen: false)
                                                                  .selectedStoreDay =
                                                              storeDayList[
                                                                  index];
                                                          context.goNamed(
                                                              'court_screen',
                                                              params: {
                                                                'viewOnly':
                                                                    'viewOnly',
                                                                'returnTo':
                                                                    'match_search_screen',
                                                                'returnToParam':
                                                                    'null',
                                                                'returnToParamValue':
                                                                    'null',
                                                                'isRecurrentMatch':
                                                                    'null'
                                                              });
                                                        }),
                                                        child: SFCourtCard(
                                                            onOnTap: () {
                                                              setState(() {
                                                                isLoading =
                                                                    true;
                                                              });
                                                            },
                                                            widgetIndexStore:
                                                                index,
                                                            storeDay:
                                                                storeDayList[
                                                                    index]),
                                                      );
                                                    }
                                                  }),
                                                )
                                          : segmentedTextValue == 1
                                              ? ListView.builder(
                                                  itemCount:
                                                      storeDayList.isEmpty
                                                          ? 1
                                                          : storeDayList.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Column(
                                                      children: [
                                                        index == 0
                                                            ? Container(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            width *
                                                                                0.05),
                                                                child: Column(
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        SvgPicture.asset(
                                                                            r'assets\icon\court.svg'),
                                                                        Container(
                                                                          padding:
                                                                              EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                width * 0.02,
                                                                          ),
                                                                          child:
                                                                              Text(
                                                                            "Quadras",
                                                                            style:
                                                                                TextStyle(color: AppTheme.colors.primaryBlue, fontWeight: FontWeight.w700),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                              SvgPicture.asset(r'assets\icon\divider.svg'),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    Container(
                                                                      padding:
                                                                          EdgeInsets
                                                                              .symmetric(
                                                                        horizontal:
                                                                            width *
                                                                                0.05,
                                                                      ),
                                                                      width: double
                                                                          .infinity,
                                                                      child:
                                                                          Text(
                                                                        "Agende um horário na sua quadra de preferência",
                                                                        textScaleFactor:
                                                                            0.9,
                                                                        style: TextStyle(
                                                                            color:
                                                                                AppTheme.colors.textDarkGrey),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding:
                                                                          EdgeInsets
                                                                              .only(
                                                                        bottom: height *
                                                                            0.01,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            : Container(),
                                                        storeDayList.isEmpty
                                                            ? Container(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                  horizontal:
                                                                      width *
                                                                          0.05,
                                                                ),
                                                                margin: EdgeInsets
                                                                    .symmetric(
                                                                  vertical:
                                                                      height *
                                                                          0.04,
                                                                ),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                  "Nenhuma horário disponível",
                                                                  style:
                                                                      TextStyle(
                                                                    color: AppTheme
                                                                        .colors
                                                                        .textLightGrey,
                                                                  ),
                                                                ),
                                                              )
                                                            : Container(
                                                                child: index ==
                                                                            0 ||
                                                                        storeDayList[index].day !=
                                                                            storeDayList[index - 1].day
                                                                    ? Column(
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                                EdgeInsets.symmetric(horizontal: width * 0.03, vertical: height * 0.02),
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                Container(
                                                                                  padding: const EdgeInsets.only(right: 5),
                                                                                  child: SvgPicture.asset(r'assets\icon\calendar.svg'),
                                                                                ),
                                                                                Text(
                                                                                  storeDayList[index].day,
                                                                                  style: TextStyle(color: AppTheme.colors.primaryBlue, fontWeight: FontWeight.w700),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          InkWell(
                                                                            onTap:
                                                                                (() {
                                                                              setState(() {
                                                                                isLoading = true;
                                                                              });
                                                                              Provider.of<MatchProvider>(context, listen: false).selectedStoreDay = storeDayList[index];
                                                                              context.goNamed('court_screen', params: {
                                                                                'viewOnly': 'viewOnly',
                                                                                'returnTo': 'match_search_screen',
                                                                                'returnToParam': 'null',
                                                                                'returnToParamValue': 'null',
                                                                                'isRecurrentMatch': 'null',
                                                                              });
                                                                            }),
                                                                            child: SFCourtCard(
                                                                                onOnTap: () {
                                                                                  setState(() {
                                                                                    isLoading = true;
                                                                                  });
                                                                                },
                                                                                widgetIndexStore: index,
                                                                                storeDay: storeDayList[index]),
                                                                          )
                                                                        ],
                                                                      )
                                                                    : InkWell(
                                                                        onTap:
                                                                            (() {
                                                                          Provider.of<MatchProvider>(context, listen: false).selectedStoreDay =
                                                                              storeDayList[index];
                                                                          context.goNamed(
                                                                              'court_screen',
                                                                              params: {
                                                                                'viewOnly': 'viewOnly',
                                                                                'returnTo': 'match_search_screen',
                                                                                'returnToParam': 'null',
                                                                                'returnToParamValue': 'null',
                                                                                'isRecurrentMatch': 'null'
                                                                              });
                                                                        }),
                                                                        child: SFCourtCard(
                                                                            onOnTap: () {
                                                                              setState(() {
                                                                                isLoading = true;
                                                                              });
                                                                            },
                                                                            widgetIndexStore: index,
                                                                            storeDay: storeDayList[index]),
                                                                      ),
                                                              ),
                                                      ],
                                                    );
                                                  },
                                                )
                                              : ListView.builder(
                                                  itemCount: Provider.of<
                                                                  MatchProvider>(
                                                              context,
                                                              listen: false)
                                                          .openMatchList
                                                          .isEmpty
                                                      ? 1
                                                      : Provider.of<
                                                                  MatchProvider>(
                                                              context,
                                                              listen: false)
                                                          .openMatchList
                                                          .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Column(children: [
                                                      index == 0
                                                          ? Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          width *
                                                                              0.05),
                                                              child: Column(
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      SvgPicture
                                                                          .asset(
                                                                              r'assets\icon\trophy.svg'),
                                                                      Container(
                                                                        padding:
                                                                            EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              width * 0.02,
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          "Partidas Abertas",
                                                                          style: TextStyle(
                                                                              color: AppTheme.colors.primaryBlue,
                                                                              fontWeight: FontWeight.w700),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child: SvgPicture.asset(
                                                                            r'assets\icon\divider.svg'),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  Container(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .symmetric(
                                                                      horizontal:
                                                                          width *
                                                                              0.05,
                                                                    ),
                                                                    width: double
                                                                        .infinity,
                                                                    child: Text(
                                                                      "Escolha uma partida e desafie novos jogadores",
                                                                      textScaleFactor:
                                                                          0.9,
                                                                      style: TextStyle(
                                                                          color: AppTheme
                                                                              .colors
                                                                              .textDarkGrey),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .only(
                                                                      bottom:
                                                                          height *
                                                                              0.01,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          : Container(),
                                                      Provider.of<MatchProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .openMatchList
                                                              .isEmpty
                                                          ? Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                horizontal:
                                                                    width *
                                                                        0.05,
                                                              ),
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                vertical:
                                                                    height *
                                                                        0.02,
                                                              ),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                "Sem partidas abertas",
                                                                style:
                                                                    TextStyle(
                                                                  color: AppTheme
                                                                      .colors
                                                                      .textLightGrey,
                                                                ),
                                                              ),
                                                            )
                                                          : SFOpenMatchVertical(
                                                              buttonCallback:
                                                                  () {
                                                                // context.go(
                                                                //     '/match_screen/${Provider.of<MatchProvider>(context, listen: false).openMatchList[index].matchUrl}/match_search_screen/null/null');
                                                              },
                                                              match: Provider.of<
                                                                          MatchProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .openMatchList[index],
                                                            )
                                                    ]);
                                                  },
                                                ),
                                    )
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
                                              "Ops! Tivemos um problema. \nTente novamente.",
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
                                ),
                              ),
                            )
            ],
          ),
          isLoading
              ? Container(
                  color: AppTheme.colors.primaryBlue.withOpacity(0.3),
                  child: const Center(
                    child: SFLoading(),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  Future<void> loadDates() async {
    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: "AccessToken");
    if (accessToken != null) {
      var response = await http.post(
        Uri.parse('https://www.sandfriends.com.br/SearchCourts'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, Object>{
          'accessToken': accessToken,
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
              .selectedTimeRange!
              .start
              .format(context),
          'timeEnd': Provider.of<MatchProvider>(context, listen: false)
              .selectedTimeRange!
              .end
              .format(context),
        }),
      );

      if (mounted) {
        if (response.statusCode == 200) {
          if (mounted) {
            Provider.of<MatchProvider>(context, listen: false)
                .clearStoreDayList();
            Provider.of<MatchProvider>(context, listen: false)
                .clearOpenMatchList();
            Provider.of<CourtProvider>(context, listen: false).clearCourts();

            final responseBody = json.decode(response.body);
            final responseDates = responseBody['Dates'];
            final responseStores = responseBody['Stores'];
            final responseCourts = responseBody['Courts'];
            final responseOpenMatches = responseBody['OpenMatches'];

            for (int i = 0; i < responseStores.length; i++) {
              Map storeJson = responseStores[i];
              Map storeDetailsJson = storeJson['Store'];
              var storePhotosJson = storeJson['StorePhoto'];
              Store newStore = Store(
                idStore: storeDetailsJson['IdStore'],
                name: storeDetailsJson['Name'],
                address: storeDetailsJson['Address'],
                latitude: storeDetailsJson['Latitude'],
                longitude: storeDetailsJson['Longitude'],
                imageUrl: storeDetailsJson['Logo'],
                descriptionText: storeDetailsJson['Description'],
                instagram: storeDetailsJson['Instagram'],
                phone: storeDetailsJson['PhoneNumber1'],
              );

              for (int photoIndex = 0;
                  photoIndex < storePhotosJson.length;
                  photoIndex++) {
                Map photo = storePhotosJson[photoIndex];
                newStore.photos.add(photo['Photo']);
              }
              Provider.of<StoreProvider>(context, listen: false)
                  .addStore(newStore);
            }

            for (int i = 0; i < responseCourts.length; i++) {
              Map courtJson = responseCourts[i];
              Provider.of<CourtProvider>(context, listen: false)
                  .addCourt(Court.fromJson(responseCourts[i]));
            }

            var newStore;
            int courtIndexTotal = 0;
            for (int dateIndex = 0;
                dateIndex < responseDates.length;
                dateIndex++) {
              Map firstLevel = responseDates[dateIndex];
              for (int storeIndex = 0;
                  storeIndex < firstLevel['Places'].length;
                  storeIndex++) {
                Map secondLevel = firstLevel['Places'][storeIndex];
                Provider.of<StoreProvider>(context, listen: false)
                    .stores
                    .forEach((store) {
                  if (store.idStore == secondLevel['IdStore']) {
                    newStore = store;
                  }
                });
                StoreDay storeDay = StoreDay(
                  store: newStore,
                  day: firstLevel['Date'],
                );

                for (int availableHoursIndex = 0;
                    availableHoursIndex < secondLevel['Available'].length;
                    availableHoursIndex++) {
                  Map thirdLevel =
                      secondLevel['Available'][availableHoursIndex];
                  for (int courtIndex = 0;
                      courtIndex < thirdLevel['Courts'].length;
                      courtIndex++) {
                    Map fourthLevel = thirdLevel['Courts'][courtIndex];

                    bool newcourt = false;
                    if (storeDay.courts.isEmpty ||
                        (storeDay.courts.any((court) =>
                                court.idStoreCourt ==
                                fourthLevel['IdStoreCourt']) ==
                            false)) {
                      newcourt = true;
                    }
                    if (newcourt) {
                      Provider.of<CourtProvider>(context, listen: false)
                          .courts
                          .forEach((court) {
                        if (court.idStoreCourt == fourthLevel['IdStoreCourt']) {
                          storeDay.courts.add(court);
                        }
                      });
                    }
                    for (int i = 0; i < storeDay.courts.length; i++) {
                      if (storeDay.courts[i].idStoreCourt ==
                          fourthLevel['IdStoreCourt']) {
                        storeDay.courts[i].availableHours.add(
                            CourtAvailableHour(
                                thirdLevel['TimeBegin'],
                                thirdLevel['TimeInteger'],
                                thirdLevel['TimeFinish'],
                                fourthLevel['Price']));
                      }
                    }
                  }
                }
                Provider.of<MatchProvider>(context, listen: false)
                    .addStoreDay(storeDay);
              }
            }

            for (int i = 0; i < responseOpenMatches.length; i++) {
              Provider.of<MatchProvider>(context, listen: false)
                  .addOpenMatch(responseOpenMatches[i]);
            }

            Provider.of<MatchProvider>(context, listen: false).searchStatus =
                EnumSearchStatus.Results;
          }
        } else if (response.statusCode == 412) {
          Provider.of<MatchProvider>(context, listen: false).searchStatus =
              EnumSearchStatus.NoResultsFound;
        } else {
          Provider.of<MatchProvider>(context, listen: false).searchStatus =
              EnumSearchStatus.Error;
        }
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> GetCities(BuildContext context) async {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    var response = await http
        .get(Uri.parse('https://www.sandfriends.com.br/GetAvailableCities'));

    if (response.statusCode == 200) {
      Provider.of<MatchProvider>(context, listen: false).clearRegions();

      Map<String, dynamic> responseBody = json.decode(response.body);
      final responseCities = responseBody['Cities'];
      final responseStates = responseBody['States'];

      for (int stateIndex = 0;
          stateIndex < responseStates.length;
          stateIndex++) {
        Provider.of<MatchProvider>(context, listen: false)
            .availableRegions
            .add(Region(
              idState: responseStates[stateIndex]['IdState'],
              state: responseStates[stateIndex]['State'],
              uf: responseStates[stateIndex]['UF'],
            ));
      }
      for (int cityIndex = 0; cityIndex < responseCities.length; cityIndex++) {
        for (int allRegionsIndex = 0;
            allRegionsIndex <
                Provider.of<MatchProvider>(context, listen: false)
                    .availableRegions
                    .length;
            allRegionsIndex++) {
          if (Provider.of<MatchProvider>(context, listen: false)
                  .availableRegions[allRegionsIndex]
                  .idState ==
              responseCities[cityIndex]['State']['IdState']) {
            Provider.of<MatchProvider>(context, listen: false)
                .availableRegions[allRegionsIndex]
                .cities
                .add(City(
                  cityId: responseCities[cityIndex]['IdCity'],
                  city: responseCities[cityIndex]['City'],
                ));
          }
        }
      }

      List<Region> _availableRegions =
          Provider.of<MatchProvider>(context, listen: false).availableRegions;

      modalWidget = SizedBox(
        height: height * 0.7,
        child: ListView.builder(
          itemCount: _availableRegions.length,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Column(
                children: [
                  Provider.of<UserProvider>(context, listen: false)
                              .user!
                              .city ==
                          null
                      ? Container()
                      : InkWell(
                          onTap: () {
                            setState(() {
                              for (var region in _availableRegions) {
                                if (region.idState ==
                                    Provider.of<UserProvider>(context,
                                            listen: false)
                                        .user!
                                        .city!
                                        .state!
                                        .idState) {
                                  for (var cityList in region.cities) {
                                    if (cityList.cityId ==
                                        Provider.of<UserProvider>(context,
                                                listen: false)
                                            .user!
                                            .city!
                                            .cityId) {
                                      Provider.of<MatchProvider>(context,
                                              listen: false)
                                          .selectedRegion = Region(
                                        idState: region.idState,
                                        state: region.state,
                                        uf: region.uf,
                                      );
                                      Provider.of<MatchProvider>(context,
                                                  listen: false)
                                              .selectedRegion!
                                              .selectedCity =
                                          City(
                                              cityId: cityList.cityId,
                                              city: cityList.city);
                                    }
                                  }
                                }
                              }

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
                          child: Container(
                            alignment: Alignment.centerLeft,
                            height: height * 0.07,
                            padding: EdgeInsets.symmetric(
                              vertical: height * 0.01,
                              horizontal: width * 0.05,
                            ),
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    r"assets\icon\location_ping.svg",
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      right: width * 0.02,
                                    ),
                                  ),
                                  Text(
                                    "${Provider.of<UserProvider>(context, listen: false).user!.city!.city} / ${Provider.of<UserProvider>(context, listen: false).user!.city!.state!.uf}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: AppTheme.colors.textBlue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                  ExpansionTile(
                    title: Text(
                      _availableRegions[index].state,
                      style: const TextStyle(
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
                                for (var region in _availableRegions) {
                                  if (region.state ==
                                      _availableRegions[index].state) {
                                    for (var cityList in region.cities) {
                                      if (cityList.city == city.city) {
                                        Provider.of<MatchProvider>(context,
                                                listen: false)
                                            .selectedRegion = Region(
                                          idState:
                                              _availableRegions[index].idState,
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
                                    }
                                  }
                                }
                                Provider.of<MatchProvider>(context,
                                        listen: false)
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
                  ),
                ],
              );
            } else {
              return ExpansionTile(
                title: Text(
                  _availableRegions[index].state,
                  style: const TextStyle(
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
                            for (var region in _availableRegions) {
                              if (region.state ==
                                  _availableRegions[index].state) {
                                for (var cityList in region.cities) {
                                  if (cityList.city == city.city) {
                                    Provider.of<MatchProvider>(context,
                                            listen: false)
                                        .selectedRegion = Region(
                                      idState: _availableRegions[index].idState,
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
                                }
                              }
                            }
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
            }
          },
        ),
      );
    }
  }
}
