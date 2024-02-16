import 'package:flutter/material.dart';
import 'package:sandfriends_web/Features/Calendar/ViewModel/CalendarViewModel.dart';
import 'package:sandfriends_web/SharedComponents/Model/Gender.dart';
import 'package:sandfriends_web/SharedComponents/Model/Rank.dart';
import 'package:sandfriends_web/SharedComponents/View/SFDropDown.dart';
import 'package:sandfriends_web/Utils/Responsive.dart';
import 'package:sandfriends_web/Utils/Validators.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../Common/Model/Court.dart';
import '../../../../../Common/Model/Hour.dart';
import '../../../../../Common/Model/Sport.dart';
import '../../../../../Common/Components/SFButton.dart';
import '../../../../../Common/Components/SFTextField.dart';
import '../../../../../Common/Utils/Constants.dart';
import '../../../../SharedComponents/Model/Player.dart';

class StorePlayerWidget extends StatefulWidget {
  Player? editPlayer;
  VoidCallback onReturn;
  Function(Player) onSavePlayer;
  Function(Player) onCreatePlayer;
  List<Sport> sports;
  List<Rank> ranks;
  List<Gender> genders;

  StorePlayerWidget({
    required this.editPlayer,
    required this.onReturn,
    required this.onSavePlayer,
    required this.onCreatePlayer,
    required this.sports,
    required this.ranks,
    required this.genders,
  });

  @override
  State<StorePlayerWidget> createState() => _StorePlayerWidgetState();
}

class _StorePlayerWidgetState extends State<StorePlayerWidget> {
  late Player newPlayer;
  final formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  List<Rank> get filteredRanks => widget.ranks
      .where((rank) => rank.idSport == newPlayer.sport!.idSport)
      .toList();

  bool isEditingPlayer = false;

  @override
  void initState() {
    setState(() {
      if (widget.editPlayer != null) {
        newPlayer = Player.copyFrom(widget.editPlayer!);
        firstNameController.text = newPlayer.firstName;
        lastNameController.text = newPlayer.lastName;
        phoneNumberController.text = newPlayer.phoneNumber!;

        isEditingPlayer = true;
      } else {
        Sport sport = widget.sports.first;
        newPlayer = Player(
          firstName: "",
          lastName: "",
          isStorePlayer: true,
          phoneNumber: "",
          sport: sport,
          rank: widget.ranks.firstWhere(
            (rank) => rank.idSport == sport.idSport && rank.rankSportLevel == 0,
          ),
          gender: widget.genders.firstWhere(
            (gender) => gender.idGender == 3,
          ),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: Responsive.isMobile(context) ? width * 0.95 : 500,
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        border: Border.all(
          color: divider,
          width: 1,
        ),
      ),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    r"assets/icon/user_plus.svg",
                    height: 30,
                    color: primaryBlue,
                  ),
                  SizedBox(
                    width: defaultPadding / 2,
                  ),
                  Text(
                    isEditingPlayer ? "Editar jogador" : "Adicionar jogador",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: textBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: defaultPadding / 2,
              ),
              Text(
                "${isEditingPlayer ? "Atualize" : "Adicione"} os jogadores que ainda não baixaram o app para ter um controle melhor dos seus clientes",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: textDarkGrey,
                ),
              ),
              const SizedBox(
                height: defaultPadding * 2,
              ),
              Row(
                children: [
                  const Expanded(flex: 1, child: Text("Nome:")),
                  Expanded(
                    flex: 2,
                    child: SFTextField(
                      labelText: "",
                      pourpose: TextFieldPourpose.Standard,
                      controller: firstNameController,
                      onChanged: (firstName) {
                        setState(() {
                          newPlayer.firstName = firstName;
                        });
                      },
                      validator: (a) =>
                          emptyCheck(a, "Digite o nome do/da jogador(a)"),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: defaultPadding,
              ),
              Row(
                children: [
                  const Expanded(flex: 1, child: Text("Sobrenome:")),
                  Expanded(
                    flex: 2,
                    child: SFTextField(
                      labelText: "",
                      pourpose: TextFieldPourpose.Standard,
                      controller: lastNameController,
                      onChanged: (lastName) {
                        setState(() {
                          newPlayer.lastName = lastName;
                        });
                      },
                      validator: (a) =>
                          emptyCheck(a, "Digite o sobrenome do/da jogador(a)"),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: defaultPadding,
              ),
              Row(
                children: [
                  const Expanded(flex: 1, child: Text("Celular:")),
                  Expanded(
                    flex: 2,
                    child: SFTextField(
                      labelText: "",
                      pourpose: TextFieldPourpose.Numeric,
                      controller: phoneNumberController,
                      onChanged: (phoneNumber) {
                        setState(() {
                          newPlayer.phoneNumber = phoneNumber;
                        });
                      },
                      validator: (a) =>
                          emptyCheck(a, "Digite o celular do/da jogador(a)"),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: defaultPadding,
              ),
              Row(
                children: [
                  Text("Gênero:"),
                  Expanded(
                    child: Container(),
                  ),
                  SFDropdown(
                    labelText: newPlayer.gender!.genderName,
                    items: widget.genders.map((e) => e.genderName).toList(),
                    validator: (value) {},
                    onChanged: (p0) {
                      setState(() {
                        newPlayer.gender = widget.genders
                            .firstWhere((gender) => gender.genderName == p0);
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Text("Esporte:"),
                  Expanded(
                    child: Container(),
                  ),
                  SFDropdown(
                    labelText: newPlayer.sport!.description,
                    items: widget.sports.map((e) => e.description).toList(),
                    validator: (value) {},
                    onChanged: (p0) {
                      setState(() {
                        newPlayer.sport = widget.sports
                            .firstWhere((sport) => sport.description == p0);
                        newPlayer.rank = widget.ranks.firstWhere((rank) =>
                            rank.rankSportLevel == 0 &&
                            rank.idSport == newPlayer.sport!.idSport);
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Text("Rank:"),
                  Expanded(
                    child: Container(),
                  ),
                  SFDropdown(
                    labelText: newPlayer.rank!.rankName,
                    items: filteredRanks.map((e) => e.rankName).toList(),
                    validator: (value) {},
                    onChanged: (p0) {
                      setState(() {
                        newPlayer.rank = filteredRanks
                            .firstWhere((rank) => rank.rankName == p0);
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 2 * defaultPadding,
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
                      buttonLabel:
                          isEditingPlayer ? "Salvar" : "Adicionar jogador",
                      buttonType: ButtonType.Primary,
                      onTap: () {
                        if (formKey.currentState?.validate() == true) {
                          if (isEditingPlayer) {
                            widget.onSavePlayer(newPlayer);
                          } else {
                            widget.onCreatePlayer(newPlayer);
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
