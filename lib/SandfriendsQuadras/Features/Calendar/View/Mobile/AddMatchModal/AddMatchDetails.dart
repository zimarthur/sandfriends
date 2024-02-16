import 'package:flutter/material.dart';

import '../../../../../../Common/Utils/Constants.dart';
import '../../../../../SharedComponents/Model/Player.dart';
import '../../../../../SharedComponents/Model/Sport.dart';
import '../../../../../SharedComponents/View/SFDropDown.dart';
import '../../../../../Common/Components/SFTextField.dart';
import '../../../../../SharedComponents/View/SelectPlayer.dart';
import '../../../../../Utils/Constants.dart';
import '../../../../../Utils/Validators.dart';
import '../../../Model/CalendarType.dart';

class AddMatchDetails extends StatefulWidget {
  String title;
  String subTitle;
  CalendarType matchType;
  CalendarType selectedMatchType;
  VoidCallback onTap;
  double height;
  bool isExpanded;
  TextEditingController obsController;
  List<Sport> sports;
  String selectedSport;
  Player? selectedPlayer;
  Function(Player?) onTapSelectPlayer;
  Function(String) onChangePrice;
  TextEditingController priceController;

  AddMatchDetails(
      {required this.title,
      required this.subTitle,
      required this.matchType,
      required this.selectedMatchType,
      required this.onTap,
      required this.height,
      required this.isExpanded,
      required this.obsController,
      required this.sports,
      required this.selectedSport,
      required this.selectedPlayer,
      required this.onTapSelectPlayer,
      required this.onChangePrice,
      required this.priceController,
      super.key});

  @override
  State<AddMatchDetails> createState() => _AddMatchDetailsState();
}

class _AddMatchDetailsState extends State<AddMatchDetails> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: Duration(
          milliseconds: 200,
        ),
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            defaultBorderRadius,
          ),
          border: Border.all(
            color: widget.matchType == widget.selectedMatchType
                ? widget.selectedMatchType == CalendarType.Match
                    ? primaryBlue
                    : primaryLightBlue
                : divider,
            width: widget.matchType == widget.selectedMatchType ? 4 : 2,
          ),
          gradient: widget.matchType == widget.selectedMatchType
              ? RadialGradient(
                  colors: [
                    widget.selectedMatchType == CalendarType.Match
                        ? primaryBlue.withOpacity(0.5)
                        : primaryLightBlue.withOpacity(0.5),
                    textWhite,
                  ],
                  center: Alignment.topLeft,
                )
              : null,
        ),
        child: widget.height == 0
            ? Container()
            : Padding(
                padding: EdgeInsets.all(
                  defaultPadding / 2,
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 30,
                          alignment: Alignment.centerLeft,
                          child: Radio(
                            value: widget.matchType,
                            groupValue: widget.selectedMatchType,
                            activeColor:
                                widget.selectedMatchType == CalendarType.Match
                                    ? primaryBlue
                                    : primaryLightBlue,
                            onChanged: (a) => widget.onTap(),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                height: 30,
                                child: Text(
                                  widget.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: widget.matchType ==
                                            widget.selectedMatchType
                                        ? widget.selectedMatchType ==
                                                CalendarType.Match
                                            ? primaryBlue
                                            : primaryLightBlue
                                        : textDarkGrey,
                                  ),
                                ),
                              ),
                              Text(
                                widget.subTitle,
                                style: TextStyle(
                                  color: textDarkGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (widget.isExpanded)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: defaultPadding,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: defaultPadding / 2),
                                  child: Row(
                                    children: [
                                      Text("Jogador:"),
                                      SizedBox(
                                        width: defaultPadding,
                                      ),
                                      Expanded(
                                        child: SelectPlayer(
                                          player: widget.selectedPlayer,
                                          onTap: () => widget.onTapSelectPlayer(
                                            widget.selectedPlayer,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: defaultPadding / 2),
                                  child: Row(
                                    children: [
                                      Text("Esporte:"),
                                      SizedBox(
                                        width: defaultPadding / 2,
                                      ),
                                      Expanded(
                                          child: SFDropdown(
                                        align: Alignment.centerRight,
                                        labelText: widget.selectedSport,
                                        items: widget.sports
                                            .map((e) => e.description)
                                            .toList(),
                                        validator: (value) {},
                                        onChanged: (p0) {
                                          setState(() {
                                            widget.selectedSport = p0!;
                                          });
                                        },
                                      )),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: defaultPadding / 2),
                                  child: Row(
                                    children: [
                                      Expanded(child: Text("Preço:")),
                                      SizedBox(
                                        width: defaultPadding / 2,
                                      ),
                                      Expanded(
                                        child: SFTextField(
                                          labelText: "",
                                          pourpose: TextFieldPourpose.Numeric,
                                          textAlign: TextAlign.center,
                                          controller: widget.priceController,
                                          onChanged: (a) =>
                                              widget.onChangePrice(a),
                                          validator: (a) => priceValidator(
                                            a,
                                            "Digite o valor da partida",
                                          ),
                                          prefixText: "R\$",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Observação:",
                                      style: TextStyle(
                                        color: textDarkGrey,
                                      ),
                                    ),
                                    SFTextField(
                                      labelText: "",
                                      pourpose: TextFieldPourpose.Multiline,
                                      minLines: 3,
                                      maxLines: 3,
                                      controller: widget.obsController,
                                      validator: (a) {},
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
