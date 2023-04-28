import 'dart:convert';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/models/store.dart';
import 'package:sandfriends/models/store_day.dart';
import 'package:sandfriends/models/court_available_hours.dart';
import 'package:sandfriends/models/court.dart';
import 'package:sandfriends/providers/categories_provider.dart';
import 'package:sandfriends/providers/court_provider.dart';
import 'package:sandfriends/providers/store_provider.dart';
import 'package:sandfriends/providers/user_provider.dart';
import 'package:sandfriends/widgets/Modal/SF_ModalDatePicker.dart';
import 'package:sandfriends/SharedComponents/View/SFLoading.dart';
import 'package:sandfriends/widgets/SF_CourtCard.dart';
import 'package:sandfriends/widgets/SF_OpenMatchVertical.dart';
import 'package:sandfriends/widgets/SF_Scaffold.dart';
import 'package:sandfriends/widgets/SF_SearchFilter.dart';
import 'package:time_range/time_range.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

import '../models/city.dart';
import '../models/region.dart';
import '../models/enums.dart';
import '../../models/enums.dart';
import '../../theme/app_theme.dart';
import '../../widgets/SF_Button.dart';
import '../models/store.dart';
import '../providers/match_provider.dart';
import '../providers/recurrent_match_provider.dart';
import '../providers/redirect_provider.dart';
import '../providers/store_provider.dart';
import '../widgets/SF_OpenMatchHorizontal.dart';

class RecurrentMatchSearchScreen extends StatefulWidget {
  const RecurrentMatchSearchScreen({Key? key}) : super(key: key);

  @override
  State<RecurrentMatchSearchScreen> createState() =>
      _RecurrentMatchSearchScreen();
}

class _RecurrentMatchSearchScreen extends State<RecurrentMatchSearchScreen> {
  bool isLoading = false;

  int? selectedCourt;
  int? selectedTime;

  bool showModal = false;
  Widget? modalWidget;

  VoidCallback onBackgroundTapFunc = () {};

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double appBarHeight = height * 0.3 > 150 ? 150 : height * 0.3;

    final storeDayList =
        List.from(Provider.of<RecurrentMatchProvider>(context).storeDayList);
    return SFScaffold(
      titleText:
          "Busca Mensalista - ${Provider.of<RecurrentMatchProvider>(context).selectedSport!.description}",
      onTapReturn: () =>
          context.goNamed('recurrent_match_sport_selection_screen'),
      appBarType: AppBarType.PrimaryLightBlue,
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
                        labelText: Provider.of<RecurrentMatchProvider>(context)
                            .regionText,
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
                                  Provider.of<RecurrentMatchProvider>(context)
                                      .dayText,
                              iconPath: r"assets\icon\calendar.svg",
                              margin: EdgeInsets.only(left: width * 0.02),
                              padding: EdgeInsets.symmetric(
                                  vertical: appBarHeight * 0.02),
                              onTap: () {
                                setState(() {
                                  modalWidget = Container(
                                    height: height * 0.7,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: width * 0.1,
                                              vertical: height * 0.02,
                                            ),
                                            child: ListView.builder(
                                              itemCount: Provider.of<
                                                          CategoriesProvider>(
                                                      context,
                                                      listen: false)
                                                  .weekDaysPortuguese
                                                  .length,
                                              itemBuilder: (context, index) {
                                                return InkWell(
                                                  onTap: () {
                                                    Provider.of<RecurrentMatchProvider>(
                                                            context,
                                                            listen: false)
                                                        .clickedDay(index);

                                                    if (Provider.of<RecurrentMatchProvider>(
                                                                context,
                                                                listen: false)
                                                            .selectedDays
                                                            .length ==
                                                        0) {
                                                      Provider.of<RecurrentMatchProvider>(
                                                              context,
                                                              listen: false)
                                                          .dayText = "Dia";
                                                    } else {
                                                      Provider.of<RecurrentMatchProvider>(
                                                              context,
                                                              listen: false)
                                                          .dayText = "";
                                                    }

                                                    for (int i = 0;
                                                        i <
                                                            Provider.of<RecurrentMatchProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .selectedDays
                                                                .length;
                                                        i++) {
                                                      Provider.of<RecurrentMatchProvider>(
                                                              context,
                                                              listen: false)
                                                          .dayText += Provider
                                                              .of<CategoriesProvider>(
                                                                  context,
                                                                  listen: false)
                                                          .shortWeekDaysPortuguese[Provider
                                                              .of<RecurrentMatchProvider>(
                                                                  context,
                                                                  listen: false)
                                                          .selectedDays[i]];
                                                      if (i !=
                                                          Provider.of<RecurrentMatchProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .selectedDays
                                                                  .length -
                                                              1) {
                                                        Provider.of<RecurrentMatchProvider>(
                                                                context,
                                                                listen: false)
                                                            .dayText += "/";
                                                      }
                                                    }
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: height * 0.02),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical:
                                                                height * 0.02,
                                                            horizontal:
                                                                width * 0.05),
                                                    decoration: BoxDecoration(
                                                      color: AppTheme
                                                          .colors.secondaryBack,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                      border: Border.all(
                                                        color: Provider.of<
                                                                        RecurrentMatchProvider>(
                                                                    context)
                                                                .selectedDays
                                                                .contains(index)
                                                            ? AppTheme.colors
                                                                .secondaryLightBlue
                                                            : AppTheme.colors
                                                                .textLightGrey,
                                                        width: Provider.of<
                                                                        RecurrentMatchProvider>(
                                                                    context)
                                                                .selectedDays
                                                                .contains(index)
                                                            ? 2
                                                            : 1,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      Provider.of<CategoriesProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .weekDaysPortuguese[
                                                          index],
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: Provider.of<
                                                                          RecurrentMatchProvider>(
                                                                      context)
                                                                  .selectedDays
                                                                  .contains(
                                                                      index)
                                                              ? AppTheme.colors
                                                                  .secondaryLightBlue
                                                              : AppTheme.colors
                                                                  .textDarkGrey),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: height * 0.01,
                                              horizontal: width * 0.1),
                                          child: SFButton(
                                              iconPath:
                                                  r"assets\icon\search.svg",
                                              buttonLabel: "Aplicar Filtro",
                                              textPadding: EdgeInsets.symmetric(
                                                  vertical:
                                                      appBarHeight * 0.02),
                                              buttonType:
                                                  ButtonType.LightBluePrimary,
                                              onTap: () {
                                                setState(() {
                                                  showModal = false;
                                                });
                                              }),
                                        )
                                      ],
                                    ),
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
                                  Provider.of<RecurrentMatchProvider>(context)
                                      .timeText,
                              iconPath: r"assets\icon\clock.svg",
                              margin: EdgeInsets.only(left: width * 0.02),
                              padding: EdgeInsets.symmetric(
                                  vertical: appBarHeight * 0.02),
                              onTap: () {
                                setState(() {
                                  onBackgroundTapFunc = () {
                                    setState(() {
                                      if (Provider.of<RecurrentMatchProvider>(
                                                  context,
                                                  listen: false)
                                              .selectedTimeRange !=
                                          null) {
                                        Provider.of<RecurrentMatchProvider>(
                                                    context,
                                                    listen: false)
                                                .timeText =
                                            "${Provider.of<RecurrentMatchProvider>(context, listen: false).selectedTimeRange!.start.hour.toString().padLeft(2, '0')}:${Provider.of<RecurrentMatchProvider>(context, listen: false).selectedTimeRange!.start.minute.toString().padLeft(2, '0')} - ${Provider.of<RecurrentMatchProvider>(context, listen: false).selectedTimeRange!.end.hour.toString().padLeft(2, '0')}:${Provider.of<RecurrentMatchProvider>(context, listen: false).selectedTimeRange!.end.minute.toString().padLeft(2, '0')}";
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
                                                      color: AppTheme.colors
                                                          .secondaryLightBlue),
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
                                                buttonType:
                                                    ButtonType.LightBluePrimary,
                                                onTap: () {
                                                  setState(() {
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
                                          borderColor: AppTheme
                                              .colors.secondaryLightBlue,
                                          backgroundColor: Colors.transparent,
                                          activeBackgroundColor: AppTheme
                                              .colors.secondaryLightBlue,
                                          initialRange: Provider.of<
                                                      RecurrentMatchProvider>(
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
                                              () => Provider.of<
                                                          RecurrentMatchProvider>(
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
                                            buttonType:
                                                ButtonType.LightBluePrimary,
                                            onTap: () {
                                              setState(() {
                                                if (Provider.of<RecurrentMatchProvider>(
                                                            context,
                                                            listen: false)
                                                        .selectedTimeRange !=
                                                    null) {
                                                  Provider.of<RecurrentMatchProvider>(
                                                              context,
                                                              listen: false)
                                                          .timeText =
                                                      "${Provider.of<RecurrentMatchProvider>(context, listen: false).selectedTimeRange!.start.hour.toString().padLeft(2, '0')}:${Provider.of<RecurrentMatchProvider>(context, listen: false).selectedTimeRange!.start.minute.toString().padLeft(2, '0')} - ${Provider.of<RecurrentMatchProvider>(context, listen: false).selectedTimeRange!.end.hour.toString().padLeft(2, '0')}:${Provider.of<RecurrentMatchProvider>(context, listen: false).selectedTimeRange!.end.minute.toString().padLeft(2, '0')}";
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
                          buttonType: ButtonType.LightBlueSecondary,
                          iconPath: r"assets\icon\search.svg",
                          textPadding: EdgeInsets.symmetric(
                              vertical: appBarHeight * 0.02),
                          onTap: () {
                            if (Provider.of<RecurrentMatchProvider>(context,
                                        listen: false)
                                    .selectedDays
                                    .isEmpty ||
                                Provider.of<RecurrentMatchProvider>(context,
                                            listen: false)
                                        .selectedRegion ==
                                    null) {
                              print("erro");
                            } else {
                              setState(() {
                                isLoading = true;
                              });
                              Provider.of<RecurrentMatchProvider>(context,
                                          listen: false)
                                      .selectedTimeRange ??=
                                  TimeRangeResult(
                                      const TimeOfDay(hour: 1, minute: 00),
                                      const TimeOfDay(hour: 23, minute: 00));
                              searchRecurrentMatches();
                            }
                          }),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: AppTheme.colors.secondaryBack,
                  child: Provider.of<RecurrentMatchProvider>(context)
                              .searchStatus ==
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
                      : Provider.of<RecurrentMatchProvider>(context)
                                  .searchStatus ==
                              EnumSearchStatus.NoResultsFound
                          ? Expanded(
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
                                                "Ops! Não encontramos resultados. \nTente outra data ou horário.",
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
                          : Provider.of<RecurrentMatchProvider>(context)
                                      .searchStatus ==
                                  EnumSearchStatus.Results
                              ? ListView.builder(
                                  itemCount: storeDayList.isEmpty
                                      ? 1
                                      : storeDayList.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        storeDayList.isEmpty
                                            ? Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: width * 0.05,
                                                ),
                                                margin: EdgeInsets.symmetric(
                                                  vertical: height * 0.04,
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "Nenhuma horário disponível",
                                                  style: TextStyle(
                                                    color: AppTheme
                                                        .colors.textLightGrey,
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                child: index == 0 ||
                                                        storeDayList[index]
                                                                .day !=
                                                            storeDayList[
                                                                    index - 1]
                                                                .day
                                                    ? Column(
                                                        children: [
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
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    r'assets\icon\calendar.svg',
                                                                    color: AppTheme
                                                                        .colors
                                                                        .primaryLightBlue,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  Provider.of<CategoriesProvider>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .weekDaysPortuguese[int.parse(storeDayList[
                                                                          index]
                                                                      .day)],
                                                                  style: TextStyle(
                                                                      color: AppTheme
                                                                          .colors
                                                                          .primaryLightBlue,
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
                                                                        'recurrent_match_search_screen',
                                                                    'returnToParam':
                                                                        'null',
                                                                    'returnToParamValue':
                                                                        'null',
                                                                    'isRecurrentMatch':
                                                                        '1',
                                                                  });
                                                            }),
                                                            child: SFCourtCard(
                                                                isRecurrentMatch:
                                                                    true,
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
                                                      )
                                                    : InkWell(
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
                                                                    'recurrent_match_search_screen',
                                                                'returnToParam':
                                                                    'null',
                                                                'returnToParamValue':
                                                                    'null',
                                                                'isRecurrentMatch':
                                                                    '1',
                                                              });
                                                        }),
                                                        child: SFCourtCard(
                                                            isRecurrentMatch:
                                                                true,
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
                                                      ),
                                              ),
                                      ],
                                    );
                                  },
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
                                                    color: AppTheme
                                                        .colors.textBlue,
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
                                ),
                ),
              )
            ],
          ),
          isLoading
              ? Container(
                  color: AppTheme.colors.secondaryLightBlue.withOpacity(0.3),
                  child: const Center(
                    child: SFLoading(),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  Future<void> GetCities(BuildContext context) async {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    var response = await http
        .get(Uri.parse('https://www.sandfriends.com.br/GetAvailableCities'));

    if (response.statusCode == 200) {
      Provider.of<RecurrentMatchProvider>(context, listen: false)
          .clearRegions();

      Map<String, dynamic> responseBody = json.decode(response.body);
      final responseCities = responseBody['Cities'];
      final responseStates = responseBody['States'];

      for (int stateIndex = 0;
          stateIndex < responseStates.length;
          stateIndex++) {
        Provider.of<RecurrentMatchProvider>(context, listen: false)
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
                Provider.of<RecurrentMatchProvider>(context, listen: false)
                    .availableRegions
                    .length;
            allRegionsIndex++) {
          if (Provider.of<RecurrentMatchProvider>(context, listen: false)
                  .availableRegions[allRegionsIndex]
                  .idState ==
              responseCities[cityIndex]['State']['IdState']) {
            Provider.of<RecurrentMatchProvider>(context, listen: false)
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
          Provider.of<RecurrentMatchProvider>(context, listen: false)
              .availableRegions;

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
                                      Provider.of<RecurrentMatchProvider>(
                                              context,
                                              listen: false)
                                          .selectedRegion = Region(
                                        idState: region.idState,
                                        state: region.state,
                                        uf: region.uf,
                                      );
                                      Provider.of<RecurrentMatchProvider>(
                                                  context,
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

                              Provider.of<RecurrentMatchProvider>(context,
                                          listen: false)
                                      .regionText =
                                  Provider.of<RecurrentMatchProvider>(context,
                                              listen: false)
                                          .selectedRegion!
                                          .selectedCity!
                                          .city +
                                      "/" +
                                      Provider.of<RecurrentMatchProvider>(
                                              context,
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
                                        Provider.of<RecurrentMatchProvider>(
                                                context,
                                                listen: false)
                                            .selectedRegion = Region(
                                          idState:
                                              _availableRegions[index].idState,
                                          state: _availableRegions[index].state,
                                          uf: _availableRegions[index].uf,
                                        );
                                        Provider.of<RecurrentMatchProvider>(
                                                    context,
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
                                Provider.of<RecurrentMatchProvider>(context,
                                            listen: false)
                                        .regionText =
                                    Provider.of<RecurrentMatchProvider>(context,
                                                listen: false)
                                            .selectedRegion!
                                            .selectedCity!
                                            .city +
                                        "/" +
                                        Provider.of<RecurrentMatchProvider>(
                                                context,
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
                                    Provider.of<RecurrentMatchProvider>(context,
                                            listen: false)
                                        .selectedRegion = Region(
                                      idState: _availableRegions[index].idState,
                                      state: _availableRegions[index].state,
                                      uf: _availableRegions[index].uf,
                                    );
                                    Provider.of<RecurrentMatchProvider>(context,
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
                            Provider.of<RecurrentMatchProvider>(context,
                                        listen: false)
                                    .regionText =
                                Provider.of<RecurrentMatchProvider>(context,
                                            listen: false)
                                        .selectedRegion!
                                        .selectedCity!
                                        .city +
                                    "/" +
                                    Provider.of<RecurrentMatchProvider>(context,
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

  Future<void> searchRecurrentMatches() async {
    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: "AccessToken");
    if (accessToken != null) {
      var response = await http.post(
        Uri.parse('https://www.sandfriends.com.br/SearchRecurrentMatches'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, Object>{
          'accessToken': accessToken,
          'sportId': Provider.of<RecurrentMatchProvider>(context, listen: false)
              .selectedSport!
              .idSport
              .toString(),
          'cityId': Provider.of<RecurrentMatchProvider>(context, listen: false)
              .selectedRegion!
              .selectedCity!
              .cityId
              .toString(),
          'days': Provider.of<RecurrentMatchProvider>(context, listen: false)
              .selectedDays
              .join(";"),
          'timeStart':
              Provider.of<RecurrentMatchProvider>(context, listen: false)
                  .selectedTimeRange!
                  .start
                  .format(context),
          'timeEnd': Provider.of<RecurrentMatchProvider>(context, listen: false)
              .selectedTimeRange!
              .end
              .format(context),
        }),
      );
      if (mounted) {
        if (response.statusCode == 200) {
          Provider.of<RecurrentMatchProvider>(context, listen: false)
              .clearStoreDayList();
          Provider.of<RecurrentMatchProvider>(context, listen: false)
              .clearOpenMatchList();
          Provider.of<CourtProvider>(context, listen: false).clearCourts();

          final responseBody = json.decode(response.body);
          final responseDates = responseBody['Dates'];
          final responseStores = responseBody['Stores'];
          final responseCourts = responseBody['Courts'];

          for (int i = 0; i < responseStores.length; i++) {
            Map storeJson = responseStores[i];

            Provider.of<StoreProvider>(context, listen: false)
                .addStore(storeFromJson(storeJson['Store']));
          }

          for (int i = 0; i < responseCourts.length; i++) {
            Map courtJson = responseCourts[i];
            Provider.of<CourtProvider>(context, listen: false)
                .addCourt(courtFromJson(responseCourts[i]));
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
                Map thirdLevel = secondLevel['Available'][availableHoursIndex];
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
                      storeDay.courts[i].availableHours.add(CourtAvailableHours(
                          thirdLevel['TimeBegin'],
                          thirdLevel['TimeInteger'],
                          thirdLevel['TimeFinish'],
                          fourthLevel['Price']));
                    }
                  }
                }
              }
              Provider.of<RecurrentMatchProvider>(context, listen: false)
                  .addStoreDay(storeDay);
            }
          }

          Provider.of<RecurrentMatchProvider>(context, listen: false)
              .searchStatus = EnumSearchStatus.Results;
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }
}
