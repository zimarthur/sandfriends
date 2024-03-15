import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../SandfriendsQuadras/Features/Menu/ViewModel/StoreProvider.dart';
import '../Model/User/UserStore.dart';
import '../Utils/Constants.dart';

class PlayersSelection extends StatefulWidget {
  UserStore? selectedPlayer;
  Function(UserStore) onPlayerSelected;
  VoidCallback onAddNewPlayer;
  TextEditingController playerController;
  bool showSport;

  PlayersSelection(
      {required this.selectedPlayer,
      required this.onPlayerSelected,
      required this.onAddNewPlayer,
      required this.playerController,
      required this.showSport,
      super.key});

  @override
  State<PlayersSelection> createState() => _PlayersSelectionState();
}

class _PlayersSelectionState extends State<PlayersSelection> {
  String filteredText = "";
  List<UserStore> players = [];
  List<UserStore> get filteredPlayers => players
      .where(
        (player) => player.fullName.toLowerCase().contains(
              widget.playerController.text.toLowerCase(),
            ),
      )
      .toList();
  @override
  void initState() {
    players = Provider.of<StoreProvider>(context, listen: false).storePlayers;
    widget.playerController.addListener(() {
      if (mounted) {
        setState(() {
          filteredText = widget.playerController.text;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.playerController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(defaultPadding / 2),
            decoration: BoxDecoration(
              border: Border.all(
                color: textLightGrey,
              ),
              color: secondaryBack,
              borderRadius: BorderRadius.circular(
                defaultBorderRadius,
              ),
            ),
            child: players.isEmpty
                ? Center(
                    child: Text(
                      "Nenhum jogador encontrado",
                      style: TextStyle(
                        color: textDarkGrey,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredPlayers.length,
                    itemBuilder: (context, index) {
                      bool isPlayerSelected =
                          filteredPlayers[index] == widget.selectedPlayer;
                      return InkWell(
                        onTap: () =>
                            widget.onPlayerSelected(filteredPlayers[index]),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: defaultPadding / 4,
                            horizontal: defaultPadding / 2,
                          ),
                          margin: EdgeInsets.only(
                            bottom: defaultPadding / 4,
                            top: defaultPadding / 4,
                            right: 10, //scrollbar
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: isPlayerSelected ? primaryBlue : divider,
                                width: isPlayerSelected ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(
                                defaultBorderRadius,
                              ),
                              color: secondaryPaper),
                          child: Row(
                            children: [
                              Radio(
                                activeColor: primaryBlue,
                                value: filteredPlayers[index],
                                groupValue: widget.selectedPlayer,
                                onChanged: (player) => widget
                                    .onPlayerSelected(filteredPlayers[index]),
                              ),
                              SizedBox(
                                width: defaultPadding,
                              ),
                              Expanded(
                                child: Text(
                                  filteredPlayers[index].fullName,
                                  style: TextStyle(
                                    color: isPlayerSelected
                                        ? textBlue
                                        : textDarkGrey,
                                  ),
                                ),
                              ),
                              if (widget.showSport)
                                Text(
                                  filteredPlayers[index]
                                      .preferenceSport!
                                      .description,
                                  style: TextStyle(
                                    color: isPlayerSelected
                                        ? textBlue
                                        : textDarkGrey,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
          ),
        ),
        SizedBox(
          height: defaultPadding / 4,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Não encontrou o jogador? ",
              style: TextStyle(
                color: textDarkGrey,
                fontSize: 12,
              ),
            ),
            InkWell(
                onTap: () => widget.onAddNewPlayer(),
                child: Text(
                  "Cadastre aqui! ",
                  style: TextStyle(
                    color: textBlue,
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                  ),
                )),
          ],
        ),
        const SizedBox(
          height: defaultPadding,
        ),
      ],
    );
  }
}
