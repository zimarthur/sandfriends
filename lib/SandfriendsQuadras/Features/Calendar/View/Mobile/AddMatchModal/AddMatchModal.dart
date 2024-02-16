import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends_web/Features/Calendar/Model/BlockMatch.dart';
import 'package:sandfriends_web/Features/Calendar/View/Mobile/AddMatchModal/AddMatchDetails.dart';
import 'package:sandfriends_web/Features/Calendar/View/Mobile/AddMatchModal/AddMatchModalGeneral.dart';
import 'package:sandfriends_web/Features/Menu/ViewModel/DataProvider.dart';
import 'package:sandfriends_web/SharedComponents/Model/HourPrice.dart';
import 'package:sandfriends_web/SharedComponents/View/PlayersSelection.dart';
import 'package:sandfriends_web/SharedComponents/View/SFButton.dart';
import 'package:sandfriends_web/SharedComponents/View/SFTextfield.dart';
import 'package:sandfriends_web/SharedComponents/View/SelectPlayer.dart';
import 'package:sandfriends_web/Utils/Validators.dart';
import '../../../../../SharedComponents/Model/Court.dart';
import '../../../../../SharedComponents/Model/Hour.dart';
import '../../../../../SharedComponents/Model/Player.dart';
import '../../../../../SharedComponents/Model/Sport.dart';
import '../../../../../SharedComponents/View/SFDropDown.dart';
import '../../../../../Utils/Constants.dart';
import '../../../Model/CalendarType.dart';
import 'package:provider/provider.dart';

class AddMatchModal extends StatefulWidget {
  final VoidCallback onReturn;
  final Function(BlockMatch) onSelected;
  Hour timeBegin;
  Hour timeEnd;
  Court court;
  Function(CalendarType) onAddNewPlayer;
  CalendarType? initCalendarType;
  HourPrice currentHourPrice;

  AddMatchModal({
    required this.onReturn,
    required this.onSelected,
    required this.currentHourPrice,
    required this.timeBegin,
    required this.timeEnd,
    required this.court,
    required this.onAddNewPlayer,
    this.initCalendarType,
    super.key,
  });

  @override
  State<AddMatchModal> createState() => _AddMatchModalState();
}

class _AddMatchModalState extends State<AddMatchModal> {
  AddMatchModalPage currentPage = AddMatchModalPage.MatchInfo;
  CalendarType selectedMatchType = CalendarType.Match;
  late String selectedSport;
  List<Sport> sports = [];
  Player? selectedPlayer;
  TextEditingController obsController = TextEditingController();
  TextEditingController playerController = TextEditingController();
  bool hasSelectedMatchType = false;

  @override
  void initState() {
    if (widget.initCalendarType != null) {
      selectedMatchType = widget.initCalendarType!;
      hasSelectedMatchType = true;
      currentPage = AddMatchModalPage.SelectPlayer;
    }
    sports = Provider.of<DataProvider>(context, listen: false).availableSports;
    selectedSport = sports.first.description;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(
        defaultPadding,
      ),
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryDarkBlue, width: 1),
        boxShadow: const [BoxShadow(blurRadius: 1, color: primaryDarkBlue)],
      ),
      width: width * 0.9,
      height: height * 0.8,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: defaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                currentPage == AddMatchModalPage.SelectPlayer
                    ? InkWell(
                        onTap: () => setState(() {
                          currentPage = AddMatchModalPage.MatchInfo;
                        }),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding / 2),
                          child: SvgPicture.asset(
                            r"assets/icon/arrow_left.svg",
                            color: textDarkGrey,
                            height: 20,
                          ),
                        ),
                      )
                    : Container(),
                InkWell(
                  onTap: () => widget.onReturn(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding / 2),
                    child: SvgPicture.asset(
                      r"assets/icon/x.svg",
                      color: textDarkGrey,
                      height: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: currentPage == AddMatchModalPage.MatchInfo
                ? AddMatchModalGeneral(
                    onSelected: (blockedMatch) =>
                        widget.onSelected(blockedMatch),
                    timeBegin: widget.timeBegin,
                    timeEnd: widget.timeEnd,
                    court: widget.court,
                    onTapSelectPlayer: (player) => setState(() {
                      currentPage = AddMatchModalPage.SelectPlayer;
                    }),
                    obsController: obsController,
                    selectedMatchType: selectedMatchType,
                    selectedPlayer: selectedPlayer,
                    onSelectMatchType: (matchType) {
                      setState(() {
                        selectedMatchType = matchType;
                      });
                    },
                    selectedSport: selectedSport,
                    sports: sports,
                    hasSelectedMatchType: hasSelectedMatchType,
                    setHasSelectedMatchType: (p0) {
                      setState(() {
                        hasSelectedMatchType = p0;
                      });
                    },
                    currentHourPrice: widget.currentHourPrice,
                  )
                : Column(
                    children: [
                      SFTextField(
                        labelText: "Pesquisar jogador",
                        pourpose: TextFieldPourpose.Standard,
                        controller: playerController,
                        validator: (value) {},
                      ),
                      SizedBox(
                        height: defaultPadding / 2,
                      ),
                      Expanded(
                          child: PlayersSelection(
                        selectedPlayer: selectedPlayer,
                        onAddNewPlayer: () =>
                            widget.onAddNewPlayer(selectedMatchType),
                        onPlayerSelected: (player) {
                          setState(() {
                            selectedPlayer = player;
                            currentPage = AddMatchModalPage.MatchInfo;
                          });
                        },
                        playerController: playerController,
                        showSport: false,
                      ))
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

enum AddMatchModalPage { MatchInfo, SelectPlayer }
