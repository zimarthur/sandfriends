import 'package:flutter/material.dart';
import 'package:sandfriends_web/Features/Calendar/Model/CalendarType.dart';
import 'package:sandfriends_web/SharedComponents/Model/AppMatch.dart';
import 'package:sandfriends_web/SharedComponents/Model/AppRecurrentMatch.dart';
import 'package:sandfriends_web/Utils/Constants.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends_web/Utils/Responsive.dart';
import 'package:sandfriends_web/Utils/SFDateTime.dart';
import '../../../../../../Common/Components/SFButton.dart';
import '../../../../../../SharedComponents/View/SFTextfield.dart';
import 'package:intl/intl.dart';

class CancelOptionsModal extends StatefulWidget {
  VoidCallback onReturn;
  DateTime selectedDay;
  AppRecurrentMatch recurrentMatch;
  Function(CalendarType) onCancel;

  CancelOptionsModal({
    required this.onReturn,
    required this.selectedDay,
    required this.recurrentMatch,
    required this.onCancel,
  });

  @override
  State<CancelOptionsModal> createState() => _CancelOptionsModalState();
}

class _CancelOptionsModalState extends State<CancelOptionsModal> {
  CalendarType? selectedCalendarType;
  @override
  Widget build(BuildContext context) {
    double mobileWidth = MediaQuery.of(context).size.width;
    return Container(
      width: Responsive.isMobile(context) ? mobileWidth * 0.95 : 500,
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        border: Border.all(
          color: divider,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Opções de cancelamento",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: red,
            ),
          ),
          SizedBox(
            height: defaultPadding / 2,
          ),
          Text(
            "${widget.recurrentMatch.court.description}  |  ${widget.recurrentMatch.startingHour.hourString} - ${widget.recurrentMatch.endingHour.hourString} | ${weekdayRecurrent[widget.recurrentMatch.weekday]}",
            style: TextStyle(
              color: textDarkGrey,
            ),
          ),
          SizedBox(
            height: defaultPadding / 2,
          ),
          RichText(
            text: TextSpan(
              text: "O horário ",
              style: const TextStyle(
                color: textDarkGrey,
                fontFamily: 'Lexend',
              ),
              children: <TextSpan>[
                TextSpan(
                  text: " pertence a(o) mensalista ",
                  style: const TextStyle(
                    color: textDarkGrey,
                  ),
                ),
                TextSpan(
                  text: widget.recurrentMatch.creatorName,
                  style: const TextStyle(
                    color: textBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ". O que você deseja cancelar?",
                  style: const TextStyle(
                    color: textDarkGrey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: defaultPadding * 2,
          ),
          Column(
            children: [
              InkWell(
                onTap: () => setState(() {
                  selectedCalendarType = CalendarType.Match;
                }),
                child: CancelOptionsModalSelector(
                  calendarType: CalendarType.Match,
                  selectedCalendarType: selectedCalendarType,
                  title:
                      "Cancelar partida do dia ${DateFormat('dd/MM/yy').format(
                    widget.selectedDay,
                  )}",
                  subText:
                      "As outras partidas do mensalista permancem agendadas.",
                ),
              ),
              SizedBox(
                height: defaultPadding,
              ),
              InkWell(
                onTap: () => setState(() {
                  selectedCalendarType = CalendarType.RecurrentMatch;
                }),
                child: CancelOptionsModalSelector(
                  calendarType: CalendarType.RecurrentMatch,
                  selectedCalendarType: selectedCalendarType,
                  title: "Cancelar mensalista",
                  subText:
                      "Cancela todas próximas partidas agendadas pelo(a) ${widget.recurrentMatch.creatorFirstName} e deixa o horário livre para outro mensalista",
                ),
              ),
            ],
          ),
          const SizedBox(
            height: defaultPadding * 2,
          ),
          Row(
            children: [
              Expanded(
                child: SFButton(
                  buttonLabel: "Voltar",
                  buttonType: ButtonType.Secondary,
                  onTap: widget.onReturn,
                ),
              ),
              const SizedBox(
                width: defaultPadding,
              ),
              Expanded(
                child: SFButton(
                  buttonLabel: "Cancelar",
                  buttonType: selectedCalendarType == null
                      ? ButtonType.Disabled
                      : ButtonType.Delete,
                  onTap: () {
                    if (selectedCalendarType != null) {
                      widget.onCancel(selectedCalendarType!);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CancelOptionsModalSelector extends StatefulWidget {
  CalendarType? selectedCalendarType;
  CalendarType calendarType;
  String title;
  String subText;
  CancelOptionsModalSelector(
      {required this.selectedCalendarType,
      required this.calendarType,
      required this.title,
      required this.subText,
      super.key});

  @override
  State<CancelOptionsModalSelector> createState() =>
      _CancelOptionsModalSelectorState();
}

class _CancelOptionsModalSelectorState
    extends State<CancelOptionsModalSelector> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          defaultBorderRadius,
        ),
        border: widget.selectedCalendarType == widget.calendarType
            ? Border.all(color: primaryBlue, width: 2)
            : Border.all(
                color: divider,
              ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  color: widget.selectedCalendarType == widget.calendarType
                      ? textBlue
                      : textBlack,
                  fontWeight: widget.selectedCalendarType == widget.calendarType
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
          Text(
            widget.subText,
            style: TextStyle(
              fontSize: 10,
              color: textDarkGrey,
            ),
          )
        ],
      ),
    );
  }
}
