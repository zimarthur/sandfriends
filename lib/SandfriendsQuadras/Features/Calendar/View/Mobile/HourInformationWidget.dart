import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends_web/Features/Calendar/Model/HourInformation.dart';
import 'package:sandfriends_web/Features/Calendar/ViewModel/CalendarViewModel.dart';
import 'package:sandfriends_web/SharedComponents/Model/Hour.dart';
import 'package:sandfriends_web/SharedComponents/View/SFButton.dart';
import 'package:sandfriends_web/Utils/SFDateTime.dart';
import 'package:sandfriends_web/Utils/TypesExtensions.dart';
import '../../../../SharedComponents/Model/Court.dart';
import '../../../../Utils/Constants.dart';

class HourInformationWidget extends StatefulWidget {
  Animation<Offset> slideAnimation;
  CalendarViewModel viewModel;
  Court court;
  Hour timeBegin;
  Hour timeEnd;
  VoidCallback onClose;
  HourInformationWidget({
    required this.slideAnimation,
    required this.viewModel,
    required this.court,
    required this.timeBegin,
    required this.timeEnd,
    required this.onClose,
    super.key,
  });

  @override
  State<HourInformationWidget> createState() => _HourInformationWidgetState();
}

class _HourInformationWidgetState extends State<HourInformationWidget> {
  Duration animationDuration = Duration(milliseconds: 200);
  double collapsedHeight = 100;
  double expandedHeight = 160;

  @override
  build(BuildContext context) {
    HourInformation hourInformation = widget.viewModel.hourInformation!;
    Color widgetColor = hourInformation.freeHour
        ? green
        : hourInformation.match
            ? hourInformation.refMatch!.blocked
                ? secondaryYellowDark
                : !hourInformation.refMatch!.isFromRecurrentMatch
                    ? primaryBlue
                    : primaryLightBlue
            : hourInformation.refRecurrentMatch!.blocked
                ? secondaryYellowDark
                : primaryLightBlue;
    bool isBlockedHour =
        hourInformation.match && hourInformation.refMatch!.blocked ||
            hourInformation.recurrentMatch &&
                hourInformation.refRecurrentMatch!.blocked;
    return SlideTransition(
      position: widget.slideAnimation,
      child: GestureDetector(
        onTap: () {},
        onHorizontalDragUpdate: (drag) {
          if (drag.delta.dx < -5.0) {
            widget.onClose();
          }
        },
        onVerticalDragUpdate: (drag) {
          if (drag.delta.dy < -5.0) {
            widget.viewModel.setIsHourInformationExpanded(value: true);
          } else if (drag.delta.dy > 5) {
            widget.viewModel.setIsHourInformationExpanded(value: false);
          }
        },
        child: AnimatedContainer(
          duration: animationDuration,
          margin: EdgeInsets.all(defaultPadding / 2),
          padding: EdgeInsets.symmetric(
            vertical: defaultPadding / 2,
            horizontal: defaultPadding,
          ),
          height: widget.viewModel.isHourInformationExpanded
              ? expandedHeight
              : collapsedHeight,
          decoration: BoxDecoration(
            color: secondaryPaper,
            borderRadius: BorderRadius.circular(
              defaultBorderRadius,
            ),
            boxShadow: [
              BoxShadow(
                color: textLightGrey,
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: Column(
            children: [
              SizedBox(
                height: collapsedHeight - defaultPadding,
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      decoration: BoxDecoration(
                        color: widgetColor,
                        borderRadius: BorderRadius.circular(
                          defaultBorderRadius,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: defaultPadding / 2,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.viewModel.hourInformation!.creatorName,
                                  style: TextStyle(
                                      color: widgetColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ),
                              InkWell(
                                onTap: () => widget.viewModel
                                    .setIsHourInformationExpanded(),
                                child: Container(
                                  height: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: widgetColor,
                                  ),
                                  child: AnimatedRotation(
                                    duration: animationDuration,
                                    turns: widget
                                            .viewModel.isHourInformationExpanded
                                        ? 0.5
                                        : 0,
                                    child: SvgPicture.asset(
                                      r"assets/icon/chevron_up.svg",
                                      color: textWhite,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "${widget.viewModel.hourInformation!.timeBegin.hourString} - ${widget.viewModel.hourInformation!.timeEnd.hourString}",
                                          style: TextStyle(
                                            color: textDarkGrey,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: widget.viewModel.hourInformation!
                                                    .sport !=
                                                null
                                            ? Text(
                                                widget
                                                    .viewModel
                                                    .hourInformation!
                                                    .sport!
                                                    .description,
                                                style: TextStyle(
                                                  color: textDarkGrey,
                                                ),
                                              )
                                            : Container(),
                                      ),
                                      Expanded(
                                        child: widget.viewModel.hourInformation!
                                                        .cost !=
                                                    null &&
                                                !isBlockedHour
                                            ? Text(
                                                widget.viewModel
                                                    .hourInformation!.cost!
                                                    .formatPrice(),
                                                style: TextStyle(
                                                  color: textDarkGrey,
                                                ),
                                              )
                                            : Container(),
                                      ),
                                    ],
                                  ),
                                ),
                                if (widget.viewModel.hourInformation!
                                            .payInStore !=
                                        null &&
                                    !isBlockedHour)
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: defaultPadding / 2,
                                        vertical: defaultPadding / 4),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          defaultBorderRadius,
                                        ),
                                        color: widget.viewModel.hourInformation!
                                                .payInStore!
                                            ? redBg
                                            : greenBg),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          widget.viewModel.hourInformation!
                                                  .payInStore!
                                              ? r"assets/icon/needs_payment.svg"
                                              : r"assets/icon/already_paid.svg",
                                          height: 20,
                                        ),
                                        SizedBox(
                                          width: defaultPadding / 2,
                                        ),
                                        Text(
                                          widget.viewModel.hourInformation!
                                                  .payInStore!
                                              ? "Pagar no local"
                                              : "Pago no app",
                                          style: TextStyle(
                                              color: widget
                                                      .viewModel
                                                      .hourInformation!
                                                      .payInStore!
                                                  ? redText
                                                  : greenText,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.viewModel.isHourInformationExpanded)
                Expanded(
                  child: Center(
                    child: isHourPast(widget.viewModel.selectedDay,
                            widget.viewModel.hourInformation!.timeBegin)
                        ? Text(
                            widget.viewModel.hourInformation!.freeHour
                                ? "Encerrado"
                                : "Partida encerrada",
                            style: TextStyle(
                              color: textDarkGrey,
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: defaultPadding),
                            child: Row(
                              children: [
                                widget.viewModel.hourInformation!.freeHour
                                    ? Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: defaultPadding / 4,
                                          ),
                                          child: SFButton(
                                            iconFirst: true,
                                            iconPath: r"assets/icon/plus.svg",
                                            buttonLabel: "Adicionar partida",
                                            buttonType: ButtonType.Primary,
                                            onTap: () => widget.viewModel
                                                .setAddMatchWidget(
                                              context,
                                              widget.court,
                                              widget.timeBegin,
                                              widget.timeEnd,
                                            ),
                                          ),
                                        ),
                                      )
                                    : widget.viewModel.hourInformation!.match
                                        ? !widget.viewModel.hourInformation!
                                                .refMatch!.isFromRecurrentMatch
                                            ? Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        defaultPadding / 4,
                                                  ),
                                                  child: SFButton(
                                                    iconFirst: true,
                                                    iconPath:
                                                        r"assets/icon/delete.svg",
                                                    buttonLabel:
                                                        "Cancelar partida",
                                                    buttonType:
                                                        ButtonType.Delete,
                                                    onTap: () => widget
                                                        .viewModel
                                                        .onTapCancelMatchHourInformation(
                                                      context,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        defaultPadding / 4,
                                                  ),
                                                  child: SFButton(
                                                    buttonLabel:
                                                        "Opções de cancelamento",
                                                    buttonType:
                                                        ButtonType.Delete,
                                                    onTap: () => widget
                                                        .viewModel
                                                        .onTapCancelOptions(
                                                      context,
                                                    ),
                                                  ),
                                                ),
                                              )
                                        : widget.viewModel.hourInformation!
                                                .refRecurrentMatch!.blocked
                                            ? Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        defaultPadding / 4,
                                                  ),
                                                  child: SFButton(
                                                    buttonLabel:
                                                        "Opções de cancelamento",
                                                    buttonType:
                                                        ButtonType.Delete,
                                                    onTap: () => widget
                                                        .viewModel
                                                        .onTapCancelOptions(
                                                      context,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        defaultPadding / 4,
                                                  ),
                                                  child: SFButton(
                                                    iconFirst: true,
                                                    iconPath:
                                                        r"assets/icon/delete.svg",
                                                    buttonLabel:
                                                        "Cancelar mensalista",
                                                    buttonType:
                                                        ButtonType.Delete,
                                                    onTap: () => widget
                                                        .viewModel
                                                        .onTapCancelMatchHourInformation(
                                                      context,
                                                    ),
                                                  ),
                                                ),
                                              ),
                              ],
                            ),
                          ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
