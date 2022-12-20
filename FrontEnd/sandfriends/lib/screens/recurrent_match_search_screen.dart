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
import 'package:sandfriends/providers/court_provider.dart';
import 'package:sandfriends/providers/store_provider.dart';
import 'package:sandfriends/providers/user_provider.dart';
import 'package:sandfriends/widgets/Modal/SF_ModalDatePicker.dart';
import 'package:sandfriends/widgets/SFLoading.dart';
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
                                      .dateText,
                              iconPath: r"assets\icon\calendar.svg",
                              margin: EdgeInsets.only(left: width * 0.02),
                              padding: EdgeInsets.symmetric(
                                  vertical: appBarHeight * 0.02),
                              onTap: () {
                                onBackgroundTapFunc = () {
                                  setState(() {
                                    if (Provider.of<RecurrentMatchProvider>(
                                            context,
                                            listen: false)
                                        .selectedDates
                                        .isNotEmpty) {
                                      var startDate = ConvertDatetime(
                                          Provider.of<RecurrentMatchProvider>(
                                                  context,
                                                  listen: false)
                                              .selectedDates[0]!);
                                      var endDate =
                                          Provider.of<RecurrentMatchProvider>(
                                                          context,
                                                          listen: false)
                                                      .selectedDates
                                                      .length >
                                                  1
                                              ? ConvertDatetime(Provider.of<
                                                          RecurrentMatchProvider>(
                                                      context,
                                                      listen: false)
                                                  .selectedDates[1]!)
                                              : 'null';

                                      if (Provider.of<RecurrentMatchProvider>(
                                                      context,
                                                      listen: false)
                                                  .selectedDates
                                                  .length >
                                              1 &&
                                          Provider.of<RecurrentMatchProvider>(
                                                      context,
                                                      listen: false)
                                                  .selectedDates[0] !=
                                              Provider.of<RecurrentMatchProvider>(
                                                      context,
                                                      listen: false)
                                                  .selectedDates[1]) {
                                        Provider.of<RecurrentMatchProvider>(
                                                    context,
                                                    listen: false)
                                                .dateText =
                                            "${Provider.of<RecurrentMatchProvider>(context, listen: false).selectedDates[0]!.day.toString().padLeft(2, '0')}/${Provider.of<RecurrentMatchProvider>(context, listen: false).selectedDates[0]!.month.toString().padLeft(2, '0')} - ${Provider.of<RecurrentMatchProvider>(context, listen: false).selectedDates[1]!.day.toString().padLeft(2, '0')}/${Provider.of<RecurrentMatchProvider>(context, listen: false).selectedDates[1]!.month.toString().padLeft(2, '0')}";
                                      } else {
                                        Provider.of<RecurrentMatchProvider>(
                                                    context,
                                                    listen: false)
                                                .dateText =
                                            "${Provider.of<RecurrentMatchProvider>(context, listen: false).selectedDates[0]!.day.toString().padLeft(2, '0')}/${Provider.of<RecurrentMatchProvider>(context, listen: false).selectedDates[0]!.month.toString().padLeft(2, '0')}";
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
                                            initialValue: Provider.of<
                                                        RecurrentMatchProvider>(
                                                    context,
                                                    listen: false)
                                                .selectedDates,
                                            onValueChanged: (values) {
                                              setState(() {
                                                Provider.of<RecurrentMatchProvider>(
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
                                              if (Provider.of<
                                                          RecurrentMatchProvider>(
                                                      context,
                                                      listen: false)
                                                  .selectedDates
                                                  .isNotEmpty) {
                                                var startDate = ConvertDatetime(
                                                    Provider.of<RecurrentMatchProvider>(
                                                            context,
                                                            listen: false)
                                                        .selectedDates[0]!);
                                                var endDate = Provider.of<
                                                                    RecurrentMatchProvider>(
                                                                context,
                                                                listen: false)
                                                            .selectedDates
                                                            .length >
                                                        1
                                                    ? ConvertDatetime(Provider
                                                            .of<RecurrentMatchProvider>(
                                                                context,
                                                                listen: false)
                                                        .selectedDates[1]!)
                                                    : 'null';

                                                if (Provider.of<RecurrentMatchProvider>(
                                                                context,
                                                                listen: false)
                                                            .selectedDates
                                                            .length >
                                                        1 &&
                                                    Provider.of<RecurrentMatchProvider>(
                                                                context,
                                                                listen: false)
                                                            .selectedDates[0] !=
                                                        Provider.of<RecurrentMatchProvider>(
                                                                context,
                                                                listen: false)
                                                            .selectedDates[1]) {
                                                  Provider.of<RecurrentMatchProvider>(
                                                              context,
                                                              listen: false)
                                                          .dateText =
                                                      "${Provider.of<RecurrentMatchProvider>(context, listen: false).selectedDates[0]!.day.toString().padLeft(2, '0')}/${Provider.of<RecurrentMatchProvider>(context, listen: false).selectedDates[0]!.month.toString().padLeft(2, '0')} - ${Provider.of<RecurrentMatchProvider>(context, listen: false).selectedDates[1]!.day.toString().padLeft(2, '0')}/${Provider.of<RecurrentMatchProvider>(context, listen: false).selectedDates[1]!.month.toString().padLeft(2, '0')}";
                                                } else {
                                                  Provider.of<RecurrentMatchProvider>(
                                                              context,
                                                              listen: false)
                                                          .dateText =
                                                      "${Provider.of<RecurrentMatchProvider>(context, listen: false).selectedDates[0]!.day.toString().padLeft(2, '0')}/${Provider.of<RecurrentMatchProvider>(context, listen: false).selectedDates[0]!.month.toString().padLeft(2, '0')}";
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
                                            buttonType: ButtonType.Secondary,
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
                            // if (Provider.of<RecurrentMatchProvider>(context,
                            //             listen: false)
                            //         .selectedDates
                            //         .isEmpty ||
                            //     Provider.of<RecurrentMatchProvider>(context,
                            //                 listen: false)
                            //             .selectedRegion ==
                            //         null) {
                            //   print("erro");
                            // } else {
                            //   setState(() {
                            //     isLoading = true;
                            //   });
                            //   Provider.of<RecurrentMatchProvider>(context, listen: false)
                            //           .selectedTimeRange ??=
                            //       TimeRangeResult(
                            //           const TimeOfDay(hour: 1, minute: 00),
                            //           const TimeOfDay(hour: 23, minute: 00));
                            // }
                          }),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(color: Colors.amber),
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
}
