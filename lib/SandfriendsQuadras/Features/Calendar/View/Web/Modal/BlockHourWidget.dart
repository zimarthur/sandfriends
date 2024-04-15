import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../Common/Components/PlayersSelection.dart';
import '../../../../../../Common/Components/SFDropDown.dart';
import '../../../../../../Common/Components/SFTextField.dart';
import '../../../../../../Common/Components/SelectPlayer.dart';
import '../../../../../../Common/Model/Court.dart';
import '../../../../../../Common/Model/Hour.dart';
import '../../../../../../Common/Model/User/UserStore.dart';
import '../../../../../../Common/Utils/Validators.dart';
import '../../../../../../Common/Model/Sport.dart';
import '../../../../../../Common/Components/SFButton.dart';
import '../../../../../../Common/Utils/Constants.dart';
import '../../../../../../Common/Utils/SFDateTime.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class BlockHourWidget extends StatefulWidget {
  bool isRecurrent;
  DateTime day;
  Hour hour;
  Court court;
  VoidCallback onReturn;
  Function(UserStore, int, String, double) onBlock;
  List<Sport> sports;
  VoidCallback onAddNewPlayer;
  double standardPrice;

  BlockHourWidget({
    required this.isRecurrent,
    required this.day,
    required this.hour,
    required this.court,
    required this.onReturn,
    required this.onBlock,
    required this.sports,
    required this.onAddNewPlayer,
    required this.standardPrice,
  });

  @override
  State<BlockHourWidget> createState() => _BlockHourWidgetState();
}

class _BlockHourWidgetState extends State<BlockHourWidget> {
  late String selectedSport;
  final formKey = GlobalKey<FormState>();
  TextEditingController obsController = TextEditingController();
  TextEditingController playerController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  ScrollController scrollController = ScrollController();
  bool onPlayerSelection = false;
  UserStore? selectedPlayer;

  @override
  void initState() {
    selectedSport = widget.sports.first.description;
    priceController.text = widget.standardPrice.toString();
    super.initState();
  }

  void onPlayerSelected(UserStore player) {
    setState(() {
      onPlayerSelection = false;
      selectedPlayer = player;
      selectedSport = player.preferenceSport!.description;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width * 0.4 > 550 ? 550 : width * 0.4,
      height: height * 0.8 > 550 ? 550 : height * 0.8,
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        border: Border.all(
          color: divider,
          width: 1,
        ),
      ),
      padding: EdgeInsets.all(defaultPadding),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.isRecurrent
                  ? "Bloqueio de horário mensalista"
                  : "Bloqueio de horário avulso",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: textBlue,
              ),
            ),
            Text(
              "Este horário ficará indisponível para os jogadores. Você pode desbloquear o horário a qualquer momento",
              style: TextStyle(
                fontSize: 14,
                color: textDarkGrey,
              ),
            ),
            SizedBox(
              height: defaultPadding,
            ),
            Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(r"assets/icon/court.svg"),
                      SizedBox(
                        width: defaultPadding / 2,
                      ),
                      Text(
                        widget.court.description,
                        style: TextStyle(
                          color: textDarkGrey,
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(r"assets/icon/calendar.svg"),
                      SizedBox(
                        width: defaultPadding / 2,
                      ),
                      Text(
                        widget.isRecurrent
                            ? weekdayFull[getSFWeekday(widget.day.weekday)]
                            : DateFormat('dd/MM/yyyy').format(
                                widget.day,
                              ),
                        style: TextStyle(
                          color: textDarkGrey,
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(r"assets/icon/clock.svg"),
                      SizedBox(
                        width: defaultPadding / 2,
                      ),
                      Text(
                        widget.hour.hourString,
                        style: TextStyle(
                          color: textDarkGrey,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: defaultPadding * 2,
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(flex: 1, child: Text("Jogador:")),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: onPlayerSelection
                              ? Row(
                                  children: [
                                    Expanded(
                                      child: SFTextField(
                                        labelText: "Pesquisar jogador",
                                        pourpose: TextFieldPourpose.Standard,
                                        controller: playerController,
                                        validator: (a) {},
                                      ),
                                    ),
                                    SizedBox(
                                      width: defaultPadding / 2,
                                    ),
                                    InkWell(
                                        onTap: () => setState(() {
                                              onPlayerSelection = false;
                                            }),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: defaultPadding / 2),
                                          child: SvgPicture.asset(
                                            r"assets/icon/x.svg",
                                            color: textDarkGrey,
                                          ),
                                        )),
                                  ],
                                )
                              : SelectPlayer(
                                  player: selectedPlayer,
                                  onTap: () => setState(
                                    () {
                                      onPlayerSelection = true;
                                    },
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: defaultPadding / 2,
                  ),
                  if (onPlayerSelection)
                    Expanded(
                        child: PlayersSelection(
                      selectedPlayer: selectedPlayer,
                      onAddNewPlayer: () => widget.onAddNewPlayer(),
                      playerController: playerController,
                      onPlayerSelected: (player) => onPlayerSelected(player),
                      showSport: true,
                    ))
                  else
                    Expanded(
                      child: CustomScrollView(
                        slivers: [
                          SliverFillRemaining(
                            hasScrollBody: false,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  children: [
                                    Expanded(flex: 1, child: Text("Esporte:")),
                                    SFDropdown(
                                      labelText: selectedSport,
                                      items: widget.sports
                                          .map((e) => e.description)
                                          .toList(),
                                      validator: (value) {},
                                      onChanged: (p0) {
                                        setState(() {
                                          selectedSport = p0!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        "Preço:",
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: SFTextField(
                                        labelText: "",
                                        pourpose: TextFieldPourpose.Numeric,
                                        controller: priceController,
                                        validator: (a) => priceValidator(
                                          a,
                                          "Digite o valor da partida",
                                        ),
                                        prefixText: "R\$",
                                      ),
                                    )
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Gostaria de deixar alguma observação?",
                                      style: TextStyle(
                                        color: textDarkGrey,
                                      ),
                                    ),
                                    SFTextField(
                                      labelText: "",
                                      pourpose: TextFieldPourpose.Multiline,
                                      minLines: 3,
                                      maxLines: 3,
                                      controller: obsController,
                                      validator: (a) {},
                                    ),
                                  ],
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
            const SizedBox(
              height: defaultPadding,
            ),
            Row(
              children: [
                Expanded(
                  child: SFButton(
                    buttonLabel: "Voltar",
                    isPrimary: false,
                    onTap: widget.onReturn,
                  ),
                ),
                const SizedBox(
                  width: defaultPadding,
                ),
                Expanded(
                  child: SFButton(
                    buttonLabel: "Bloquear Horário",
                    color: selectedPlayer == null ? disabled : red,
                    onTap: () {
                      if (selectedPlayer != null) {
                        widget.onBlock(
                          selectedPlayer!,
                          widget.sports
                              .firstWhere(
                                  (sport) => sport.description == selectedSport)
                              .idSport,
                          obsController.text,
                          double.parse(
                            priceController.text,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
