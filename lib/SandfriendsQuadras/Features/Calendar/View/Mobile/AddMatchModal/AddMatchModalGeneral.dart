import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/Common/Model/HourPrice/HourPriceStore.dart';
import '../../../../../../Common/Components/SFButton.dart';
import '../../../../../../Common/Model/Court.dart';
import '../../../../../../Common/Model/Hour.dart';
import '../../../../../../Common/Model/Sport.dart';
import '../../../../../../Common/Model/User/UserStore.dart';
import '../../../../../../Common/Utils/Constants.dart';
import '../../../Model/BlockMatch.dart';
import '../../../Model/CalendarType.dart';
import 'AddMatchDetails.dart';

class AddMatchModalGeneral extends StatefulWidget {
  final Function(BlockMatch) onSelected;
  Hour timeBegin;
  Hour timeEnd;
  Court court;
  Function(UserStore?) onTapSelectPlayer;
  CalendarType selectedMatchType;
  Function(CalendarType) onSelectMatchType;
  TextEditingController obsController;
  UserStore? selectedPlayer;
  String selectedSport;
  List<Sport> sports;
  bool hasSelectedMatchType;
  Function(bool) setHasSelectedMatchType;
  HourPriceStore currentHourPrice;

  AddMatchModalGeneral({
    required this.onSelected,
    required this.timeBegin,
    required this.timeEnd,
    required this.court,
    required this.onTapSelectPlayer,
    required this.selectedMatchType,
    required this.onSelectMatchType,
    required this.obsController,
    required this.selectedPlayer,
    required this.selectedSport,
    required this.sports,
    required this.hasSelectedMatchType,
    required this.setHasSelectedMatchType,
    required this.currentHourPrice,
    super.key,
  });

  @override
  State<AddMatchModalGeneral> createState() => _AddMatchModalGeneralState();
}

class _AddMatchModalGeneralState extends State<AddMatchModalGeneral> {
  String price = "";
  TextEditingController priceController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    price = widget.currentHourPrice.price.toString();
    priceController.text = price;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              r"assets/icon/calendar_add.svg",
              color: primaryBlue,
            ),
            SizedBox(
              width: defaultPadding / 2,
            ),
            const Text(
              "Nova partida",
              style: TextStyle(
                color: primaryBlue,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        Text(
          "${widget.court.description}  |  ${widget.timeBegin.hourString} - ${widget.timeEnd.hourString}",
          style: TextStyle(
            color: textDarkGrey,
          ),
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        Expanded(
          child: LayoutBuilder(builder: (context, constraints) {
            double spacer = defaultPadding;
            double collapsedHeight = (constraints.maxHeight - spacer) / 2;
            double expandedHeight = constraints.maxHeight;
            return Form(
              key: formKey,
              child: Column(
                children: [
                  AddMatchDetails(
                    title: "Partida avulsa",
                    subTitle:
                        "Reserve o horário somente no dia e horário selecionado.",
                    matchType: CalendarType.Match,
                    selectedMatchType: widget.selectedMatchType,
                    onTap: () {
                      widget.onSelectMatchType(CalendarType.Match);
                      setState(() {
                        price = widget.currentHourPrice.price.toString();
                        priceController.text = price;
                      });
                    },
                    priceController: priceController,
                    height: widget.hasSelectedMatchType
                        ? widget.selectedMatchType == CalendarType.Match
                            ? expandedHeight
                            : 0
                        : collapsedHeight,
                    isExpanded: widget.hasSelectedMatchType &&
                        widget.selectedMatchType == CalendarType.Match,
                    obsController: widget.obsController,
                    sports: widget.sports,
                    selectedSport: widget.selectedSport,
                    selectedPlayer: widget.selectedPlayer,
                    onTapSelectPlayer: (player) =>
                        widget.onTapSelectPlayer(player),
                    onChangePrice: (newPrice) => setState(() {
                      price = newPrice;
                    }),
                  ),
                  if (!widget.hasSelectedMatchType)
                    SizedBox(
                      height: spacer,
                    ),
                  AddMatchDetails(
                    title: "Partida mensalista",
                    subTitle:
                        "Deixe esse horário reservado recorrentemente todas semanas nesse dia e horário.",
                    matchType: CalendarType.RecurrentMatch,
                    selectedMatchType: widget.selectedMatchType,
                    onTap: () {
                      widget.onSelectMatchType(CalendarType.RecurrentMatch);
                      setState(() {
                        price = (widget.currentHourPrice.recurrentPrice ??
                                widget.currentHourPrice.price)
                            .toString();
                        priceController.text = price;
                      });
                    },
                    priceController: priceController,
                    height: widget.hasSelectedMatchType
                        ? widget.selectedMatchType ==
                                CalendarType.RecurrentMatch
                            ? expandedHeight
                            : 0
                        : collapsedHeight,
                    isExpanded: widget.hasSelectedMatchType &&
                        widget.selectedMatchType == CalendarType.RecurrentMatch,
                    obsController: widget.obsController,
                    sports: widget.sports,
                    selectedSport: widget.selectedSport,
                    selectedPlayer: widget.selectedPlayer,
                    onTapSelectPlayer: (player) =>
                        widget.onTapSelectPlayer(player),
                    onChangePrice: (newPrice) => setState(() {
                      price = newPrice;
                    }),
                  ),
                ],
              ),
            );
          }),
        ),
        SizedBox(
          height: defaultPadding,
        ),
        Row(
          children: [
            if (widget.hasSelectedMatchType)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding / 4),
                  child: SFButton(
                    buttonLabel: "Voltar",
                    isPrimary: false,
                    onTap: () => widget.setHasSelectedMatchType(false),
                  ),
                ),
              ),
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: defaultPadding / 4),
                child: SFButton(
                    buttonLabel: widget.hasSelectedMatchType
                        ? "Criar partida"
                        : "Continuar",
                    onTap: () {
                      if (!widget.hasSelectedMatchType) {
                        widget.setHasSelectedMatchType(true);
                      } else if (widget.selectedPlayer != null &&
                          formKey.currentState?.validate() == true) {
                        widget.onSelected(
                          BlockMatch(
                            isRecurrent: widget.selectedMatchType ==
                                CalendarType.RecurrentMatch,
                            idStoreCourt: widget.court.idStoreCourt!,
                            timeBegin: widget.timeBegin,
                            observation: widget.obsController.text,
                            idSport: widget.sports
                                .firstWhere((sport) =>
                                    sport.description == widget.selectedSport)
                                .idSport,
                            player: widget.selectedPlayer!,
                            price: double.parse(price),
                          ),
                        );
                      }
                    }),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
