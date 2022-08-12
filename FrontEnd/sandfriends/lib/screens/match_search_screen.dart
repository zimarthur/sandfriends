import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/widgets/Modal/SF_ModalDatePicker.dart';
import 'package:sandfriends/widgets/SF_Scaffold.dart';
import 'package:sandfriends/widgets/SF_SearchFilter.dart';
import '../models/enums.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:time_range/time_range.dart';

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
  bool showModal = false;
  Widget? modalWidget;
  SearchFilter? searchFilter;

  bool hasAnyFilter = true;

  String localText = "Cidade";
  String dateText = "Data";
  String timeText = "Hora";

  List<DateTime?> datePickerRange = [];

  TimeRangeResult? timePickerRange;
  final defaultTimePickerRange = TimeRangeResult(
    const TimeOfDay(hour: 0, minute: 0),
    const TimeOfDay(hour: 23, minute: 30),
  );

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
          "Busca - ${Provider.of<Match>(context).matchSport!.toShortString()}",
      goNamed: 'sport_selection',
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
                                  modalWidget = SFModalDatePicker(
                                      datePickerRange: datePickerRange,
                                      showModal: showModal,
                                      dateText: dateText);
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
                          onTap: () {}),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: AppTheme.colors.secondaryBack,
                  child: Center(
                    child: Container(
                      height: height * 0.2,
                      padding: EdgeInsets.only(
                          left: width * 0.2, right: width * 0.2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                            height: height * 0.01 > 4 ? 4 : height * 0.01,
                            width: width * 0.8,
                            color: AppTheme.colors.divider,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          showModal ? modalWidget! : Container()
        ],
      ),
    );

    // Scaffold(
    //   resizeToAvoidBottomInset: true,
    //   backgroundColor: AppTheme.colors.primaryBlue,
    //   body: SafeArea(
    //     child: Stack(
    //       children: [
    //         Container(
    //           child: Column(
    //             children: [
    //               Container(
    //                 height: appBarHeight,
    //                 padding: EdgeInsets.symmetric(horizontal: width * 0.05),
    //                 child: Column(
    //                   children: [
    //                     Container(
    //                       padding: EdgeInsets.symmetric(
    //                           horizontal: width * 0.02,
    //                           vertical: appBarHeight * 0.06),
    //                       height: appBarHeight * 0.26,
    //                       child: SFSearchFilter(
    //                         labelText: localText,
    //                         iconPath: r"assets\icon\location_ping.svg",
    //                         margin: EdgeInsets.only(left: width * 0.02),
    //                         padding: EdgeInsets.symmetric(
    //                             vertical: appBarHeight * 0.02),
    //                         onTap: () {
    //                           setState(() {
    //                             showModal = true;
    //                             searchFilter = SearchFilter.Local;
    //                           });
    //                         },
    //                       ),
    //                     ),
    //                     Row(
    //                       children: [
    //                         Expanded(
    //                           child: Container(
    //                             padding: EdgeInsets.symmetric(
    //                                 horizontal: width * 0.02,
    //                                 vertical: appBarHeight * 0.06),
    //                             height: appBarHeight * 0.26,
    //                             child: SFSearchFilter(
    //                               labelText: dateText,
    //                               iconPath: r"assets\icon\calendar.svg",
    //                               margin: EdgeInsets.only(left: width * 0.02),
    //                               padding: EdgeInsets.symmetric(
    //                                   vertical: appBarHeight * 0.02),
    //                               onTap: () {
    //                                 setState(() {
    //                                   showModal = true;
    //                                   searchFilter = SearchFilter.Date;
    //                                 });
    //                               },
    //                             ),
    //                           ),
    //                         ),
    //                         Expanded(
    //                           child: Container(
    //                             padding: EdgeInsets.symmetric(
    //                                 horizontal: width * 0.02,
    //                                 vertical: appBarHeight * 0.06),
    //                             height: appBarHeight * 0.26,
    //                             child: SFSearchFilter(
    //                               labelText: timeText,
    //                               iconPath: r"assets\icon\clock.svg",
    //                               margin: EdgeInsets.only(left: width * 0.02),
    //                               padding: EdgeInsets.symmetric(
    //                                   vertical: appBarHeight * 0.02),
    //                               onTap: () {
    //                                 setState(() {
    //                                   showModal = true;
    //                                   searchFilter = SearchFilter.Time;
    //                                 });
    //                               },
    //                             ),
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                     Container(
    //                       padding: EdgeInsets.symmetric(
    //                           horizontal: width * 0.02,
    //                           vertical: appBarHeight * 0.06),
    //                       height: appBarHeight * 0.26,
    //                       child: SFButton(
    //                           buttonLabel: "Buscar",
    //                           buttonType: ButtonType.Secondary,
    //                           iconPath: r"assets\icon\search.svg",
    //                           textPadding: EdgeInsets.symmetric(
    //                               vertical: appBarHeight * 0.02),
    //                           onTap: () {}),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //               Expanded(
    //                 child: Container(
    //                   color: AppTheme.colors.secondaryBack,
    //                   child: hasAnyFilter
    //                       ? Padding(
    //                           padding: EdgeInsets.symmetric(
    //                               horizontal: width * 0.04),
    //                           child: ListView(
    //                             children: [
    //                               Container(
    //                                 height: 230,
    //                                 decoration: BoxDecoration(
    //                                     color: AppTheme.colors.secondaryPaper,
    //                                     borderRadius: BorderRadius.circular(16),
    //                                     border: Border.all(
    //                                         color: AppTheme.colors.divider,
    //                                         width: 0.5)),
    //                                 child: Column(
    //                                   children: [
    //                                     Padding(
    //                                       padding: EdgeInsets.symmetric(
    //                                           horizontal: 12, vertical: 8),
    //                                       child: Row(
    //                                         children: [
    //                                           ClipRRect(
    //                                             borderRadius:
    //                                                 BorderRadius.circular(16),
    //                                             child: Image.asset(
    //                                               r"assets\icon\logo.png",
    //                                               height: 82,
    //                                               width: 82,
    //                                             ),
    //                                           ),
    //                                           Padding(
    //                                               padding: EdgeInsets.only(
    //                                                   right: 12)),
    //                                           Expanded(
    //                                               child: SizedBox(
    //                                             height: 82,
    //                                             child: Column(
    //                                               crossAxisAlignment:
    //                                                   CrossAxisAlignment.start,
    //                                               mainAxisAlignment:
    //                                                   MainAxisAlignment
    //                                                       .spaceBetween,
    //                                               children: [
    //                                                 Text(
    //                                                   "Beach Tennis Club",
    //                                                   style: TextStyle(
    //                                                       fontWeight:
    //                                                           FontWeight.w700,
    //                                                       fontSize: 18,
    //                                                       color: AppTheme.colors
    //                                                           .primaryBlue),
    //                                                 ),
    //                                                 Row(
    //                                                   children: [
    //                                                     SvgPicture.asset(
    //                                                         r"assets\icon\location_ping.svg"),
    //                                                     Text(
    //                                                       "Av. Cel. Marcos, 1956 - Ipanema",
    //                                                       style: TextStyle(
    //                                                           fontWeight:
    //                                                               FontWeight
    //                                                                   .w500,
    //                                                           fontSize: 10,
    //                                                           color: AppTheme
    //                                                               .colors
    //                                                               .primaryBlue),
    //                                                     ),
    //                                                   ],
    //                                                 ),
    //                                                 Column(
    //                                                   crossAxisAlignment:
    //                                                       CrossAxisAlignment
    //                                                           .start,
    //                                                   children: [
    //                                                     Text(
    //                                                       "Horários disponíveis",
    //                                                       style: TextStyle(
    //                                                           fontWeight:
    //                                                               FontWeight
    //                                                                   .w700,
    //                                                           fontSize: 14,
    //                                                           color: AppTheme
    //                                                               .colors
    //                                                               .textDarkGrey),
    //                                                     ),
    //                                                     Text(
    //                                                       "Selecione uma ou mais opções",
    //                                                       style: TextStyle(
    //                                                           fontWeight:
    //                                                               FontWeight
    //                                                                   .w500,
    //                                                           fontSize: 10,
    //                                                           color: AppTheme
    //                                                               .colors
    //                                                               .textDarkGrey),
    //                                                     ),
    //                                                   ],
    //                                                 )
    //                                               ],
    //                                             ),
    //                                           )),
    //                                         ],
    //                                       ),
    //                                     ),
    //                                     Container(
    //                                       height: 50,
    //                                       child: ListView(
    //                                         scrollDirection: Axis.horizontal,
    //                                         children: [
    //                                           Container(
    //                                             margin:
    //                                                 const EdgeInsets.symmetric(
    //                                                     horizontal: 8.0),
    //                                             child: Container(
    //                                               width: 75,
    //                                               decoration: BoxDecoration(
    //                                                 borderRadius:
    //                                                     BorderRadius.circular(
    //                                                         16),
    //                                                 border: Border.all(
    //                                                     color: AppTheme
    //                                                         .colors.primaryBlue,
    //                                                     width: 1),
    //                                               ),
    //                                               child: Padding(
    //                                                 padding:
    //                                                     EdgeInsets.symmetric(
    //                                                         horizontal: 10,
    //                                                         vertical: 4),
    //                                                 child: Column(
    //                                                   children: [
    //                                                     Row(
    //                                                       mainAxisAlignment:
    //                                                           MainAxisAlignment
    //                                                               .spaceBetween,
    //                                                       children: [
    //                                                         SvgPicture.asset(
    //                                                             r"assets\icon\clock.svg"),
    //                                                         Expanded(
    //                                                           child: FittedBox(
    //                                                             fit: BoxFit
    //                                                                 .scaleDown,
    //                                                             child: Text(
    //                                                                 "19:00"),
    //                                                           ),
    //                                                         ),
    //                                                       ],
    //                                                     ),
    //                                                     Row(
    //                                                       mainAxisAlignment:
    //                                                           MainAxisAlignment
    //                                                               .spaceBetween,
    //                                                       children: [
    //                                                         SvgPicture.asset(
    //                                                             r"assets\icon\payment.svg"),
    //                                                         Expanded(
    //                                                           child: FittedBox(
    //                                                             fit: BoxFit
    //                                                                 .scaleDown,
    //                                                             child: Text(
    //                                                                 "100/h"),
    //                                                           ),
    //                                                         ),
    //                                                       ],
    //                                                     ),
    //                                                   ],
    //                                                 ),
    //                                               ),
    //                                             ),
    //                                           ),
    //                                         ],
    //                                       ),
    //                                     )
    //                                   ],
    //                                 ),
    //                               )
    //                             ],
    //                           ),
    //                         )
    //                       : Center(
    //                           child: Container(
    //                             height: height * 0.2,
    //                             padding: EdgeInsets.only(
    //                                 left: width * 0.2, right: width * 0.2),
    //                             child: Column(
    //                               mainAxisAlignment:
    //                                   MainAxisAlignment.spaceAround,
    //                               children: [
    //                                 SvgPicture.asset(
    //                                   r"assets\icon\happy_face.svg",
    //                                   height: height * 0.1,
    //                                 ),
    //                                 SizedBox(
    //                                   height: height * 0.05,
    //                                   child: Text(
    //                                     "Use os filtros para buscar por quadras e partidas disponíveis.",
    //                                     style: TextStyle(
    //                                       color: AppTheme.colors.textBlue,
    //                                       fontWeight: FontWeight.w700,
    //                                     ),
    //                                   ),
    //                                 ),
    //                                 Container(
    //                                   height:
    //                                       height * 0.01 > 4 ? 4 : height * 0.01,
    //                                   width: width * 0.8,
    //                                   color: AppTheme.colors.divider,
    //                                 )
    //                               ],
    //                             ),
    //                           ),
    //                         ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //         showModal
    //             ? searchFilter == SearchFilter.Local
    //                 ? Container()
    //                 : searchFilter == SearchFilter.Date
    //                     ? Stack(
    //                         alignment: Alignment.center,
    //                         children: [
    //                           Container(
    //                             height: height,
    //                             width: width,
    //                             color: AppTheme.colors.primaryBlue
    //                                 .withOpacity(0.4),
    //                           ),
    //                           Container(
    //                             decoration: BoxDecoration(
    //                               color: AppTheme.colors.secondaryPaper,
    //                               borderRadius: BorderRadius.circular(16),
    //                               border: Border.all(
    //                                   color: AppTheme.colors.primaryDarkBlue,
    //                                   width: 1),
    //                               boxShadow: [
    //                                 BoxShadow(
    //                                     blurRadius: 1,
    //                                     color: AppTheme.colors.primaryDarkBlue)
    //                               ],
    //                             ),
    //                             width: width * 0.9,
    //                             height: height * 0.5,
    //                             child: Column(
    //                               children: [
    //                                 CalendarDatePicker2(
    //                                   config: CalendarDatePicker2Config(
    //                                     weekdayLabels: [
    //                                       'Dom',
    //                                       'Seg',
    //                                       'Ter',
    //                                       'Qua',
    //                                       'Qui',
    //                                       'Sex',
    //                                       'Sáb'
    //                                     ],
    //                                     firstDate: DateTime(
    //                                         today.year, today.month, today.day),
    //                                     calendarType:
    //                                         CalendarDatePicker2Type.range,
    //                                     selectedDayHighlightColor:
    //                                         AppTheme.colors.primaryBlue,
    //                                     weekdayLabelTextStyle: const TextStyle(
    //                                       color: Colors.black87,
    //                                       fontWeight: FontWeight.bold,
    //                                     ),
    //                                     controlsTextStyle: const TextStyle(
    //                                       color: Colors.black,
    //                                       fontSize: 15,
    //                                       fontWeight: FontWeight.bold,
    //                                     ),
    //                                   ),
    //                                   initialValue: datePickerRange,
    //                                   onValueChanged: (values) => setState(
    //                                       () => datePickerRange = values),
    //                                 ),
    //                                 Padding(
    //                                   padding: EdgeInsets.symmetric(
    //                                       horizontal: width * 0.15),
    //                                   child: SFButton(
    //                                       iconPath: r"assets\icon\search.svg",
    //                                       buttonLabel: "Aplicar Filtro",
    //                                       textPadding: EdgeInsets.symmetric(
    //                                           vertical: appBarHeight * 0.02),
    //                                       buttonType: ButtonType.Secondary,
    //                                       onTap: () {
    //                                         setState(() {
    //                                           print("false");
    //                                           if (datePickerRange.isNotEmpty) {
    //                                             var startDate = ConvertDatetime(
    //                                                 datePickerRange[0]!);
    //                                             var endDate =
    //                                                 datePickerRange.length > 1
    //                                                     ? ConvertDatetime(
    //                                                         datePickerRange[1]!)
    //                                                     : 'null';

    //                                             if (datePickerRange.length >
    //                                                 1) {
    //                                               dateText =
    //                                                   "${datePickerRange[0]!.day.toString().padLeft(2, '0')}/${datePickerRange[0]!.month.toString().padLeft(2, '0')} - ${datePickerRange[1]!.day.toString().padLeft(2, '0')}/${datePickerRange[1]!.month.toString().padLeft(2, '0')}";
    //                                             } else {
    //                                               dateText =
    //                                                   "${datePickerRange[0]!.day.toString().padLeft(2, '0')}/${datePickerRange[0]!.month.toString().padLeft(2, '0')}";
    //                                             }
    //                                           }
    //                                           showModal = false;
    //                                         });
    //                                       }),
    //                                 )
    //                               ],
    //                             ),
    //                           ),
    //                         ],
    //                       )
    //                     : Stack(
    //                         alignment: Alignment.center,
    //                         children: [
    //                           Container(
    //                             height: height,
    //                             width: width,
    //                             color: AppTheme.colors.primaryBlue
    //                                 .withOpacity(0.4),
    //                           ),
    //                           Container(
    //                             decoration: BoxDecoration(
    //                               color: AppTheme.colors.secondaryPaper,
    //                               borderRadius: BorderRadius.circular(16),
    //                               border: Border.all(
    //                                   color: AppTheme.colors.primaryDarkBlue,
    //                                   width: 1),
    //                               boxShadow: [
    //                                 BoxShadow(
    //                                     blurRadius: 1,
    //                                     color: AppTheme.colors.primaryDarkBlue)
    //                               ],
    //                             ),
    //                             width: width * 0.9,
    //                             child: Column(
    //                               mainAxisSize: MainAxisSize.min,
    //                               children: [
    //                                 Container(
    //                                   padding: EdgeInsets.symmetric(
    //                                       horizontal: width * 0.05,
    //                                       vertical: height * 0.02),
    //                                   child: Row(
    //                                     mainAxisAlignment:
    //                                         MainAxisAlignment.spaceBetween,
    //                                     children: [
    //                                       Expanded(
    //                                         child: FittedBox(
    //                                           fit: BoxFit.fitWidth,
    //                                           child: Text(
    //                                             "Que horas você quer jogar?",
    //                                             style: TextStyle(
    //                                                 fontWeight: FontWeight.bold,
    //                                                 color: AppTheme
    //                                                     .colors.primaryBlue),
    //                                           ),
    //                                         ),
    //                                       ),
    //                                       Padding(
    //                                           padding: EdgeInsets.only(
    //                                               left: width * 0.08)),
    //                                       SFButton(
    //                                           textPadding:
    //                                               EdgeInsets.all(width * 0.01),
    //                                           buttonLabel: "Limpar",
    //                                           buttonType: ButtonType.Primary,
    //                                           onTap: () {
    //                                             setState(() {
    //                                               timePickerRange =
    //                                                   defaultTimePickerRange;
    //                                             });
    //                                           })
    //                                     ],
    //                                   ),
    //                                 ),
    //                                 Container(
    //                                   padding: EdgeInsets.symmetric(
    //                                       vertical: height * 0.02),
    //                                   child: TimeRange(
    //                                     fromTitle: Text(
    //                                       'De',
    //                                     ),
    //                                     toTitle: Text(
    //                                       'Até',
    //                                     ),
    //                                     titlePadding: 20,
    //                                     textStyle: TextStyle(
    //                                         fontWeight: FontWeight.normal,
    //                                         color: Colors.black87),
    //                                     activeTextStyle: TextStyle(
    //                                         fontWeight: FontWeight.bold,
    //                                         color: Colors.white),
    //                                     borderColor:
    //                                         AppTheme.colors.primaryBlue,
    //                                     backgroundColor: Colors.transparent,
    //                                     activeBackgroundColor:
    //                                         AppTheme.colors.primaryBlue,
    //                                     initialRange: timePickerRange,
    //                                     firstTime:
    //                                         TimeOfDay(hour: 0, minute: 0),
    //                                     lastTime:
    //                                         TimeOfDay(hour: 23, minute: 30),
    //                                     timeStep: 30,
    //                                     timeBlock: 30,
    //                                     onRangeCompleted: (range) => setState(
    //                                         () => timePickerRange = range),
    //                                   ),
    //                                 ),
    //                                 Container(
    //                                   padding: EdgeInsets.symmetric(
    //                                       vertical: height * 0.02,
    //                                       horizontal: width * 0.15),
    //                                   child: SFButton(
    //                                       iconPath: r"assets\icon\search.svg",
    //                                       buttonLabel: "Aplicar Filtro",
    //                                       textPadding: EdgeInsets.symmetric(
    //                                           vertical: appBarHeight * 0.02),
    //                                       buttonType: ButtonType.Secondary,
    //                                       onTap: () {
    //                                         setState(() {
    //                                           if (timePickerRange != null) {
    //                                             timeText =
    //                                                 "${timePickerRange!.start.hour.toString().padLeft(2, '0')}:${timePickerRange!.start.minute.toString().padLeft(2, '0')} - ${timePickerRange!.end.hour.toString().padLeft(2, '0')}:${timePickerRange!.end.minute.toString().padLeft(2, '0')}";
    //                                           }
    //                                           showModal = false;
    //                                         });
    //                                       }),
    //                                 )
    //                               ],
    //                             ),
    //                           ),
    //                         ],
    //                       )
    //             : Container()
    //       ],
    //     ),
    //   ),
    // );
  }
}
