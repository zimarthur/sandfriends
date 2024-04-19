import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Model/CreditCard/CreditCardValidator.dart';
import 'package:sandfriends/Common/Model/SelectedPayment.dart';
import 'package:sandfriends/Common/Providers/Environment/EnvironmentProvider.dart';
import 'package:sandfriends/Sandfriends/Features/Checkout/View/Payment/CheckoutPaymentRadio.dart';
import 'package:sandfriends/Sandfriends/Features/Checkout/ViewModel/CheckoutViewModel.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';
import 'package:sandfriends/Common/Utils/Validators.dart';
import 'package:sandfriends/Sandfriends/Providers/TeacherProvider/TeacherProvider.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';

import '../../../../../Common/Model/CreditCard/CreditCardUtils.dart';
import '../../../../../../Common/Components/SFTextField.dart';
import '../../../../../Common/Model/Team.dart';

class CheckoutTeamSelection extends StatefulWidget {
  CheckoutViewModel viewModel;

  CheckoutTeamSelection({
    required this.viewModel,
    Key? key,
  }) : super(key: key);

  @override
  State<CheckoutTeamSelection> createState() => _CheckoutPaymentState();
}

class _CheckoutPaymentState extends State<CheckoutTeamSelection> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: defaultPadding / 2),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.viewModel.canChangeTeam
                      ? "Selecione a turma"
                      : "Turma",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  textScaleFactor: 1.3,
                ),
              ),
              if (widget.viewModel.canChangeTeam)
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, "/create_team"),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding / 2),
                    child: SvgPicture.asset(
                      r"assets/icon/plus_circle.svg",
                      height: 25,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: secondaryPaper,
            border: Border.all(
              color: divider,
            ),
            borderRadius: BorderRadius.circular(
              defaultBorderRadius,
            ),
          ),
          padding: EdgeInsets.all(
            defaultPadding,
          ),
          child: Provider.of<TeacherProvider>(context).teacher.teams.isEmpty
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2 * defaultPadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Você não tem turmas cadastradas",
                        style: TextStyle(
                          color: primaryBlue,
                        ),
                      ),
                      Text(
                        "Crie uma nova turma para agendar uma aula",
                        style: TextStyle(
                          color: textDarkGrey,
                          fontWeight: FontWeight.w300,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.viewModel.canChangeTeam
                      ? Provider.of<TeacherProvider>(context)
                          .teacher
                          .teams
                          .length
                      : 1,
                  itemBuilder: (context, index) {
                    Team team = widget.viewModel.canChangeTeam
                        ? Provider.of<TeacherProvider>(context)
                            .teacher
                            .teams[index]
                        : widget.viewModel.selectedTeam!;

                    return GestureDetector(
                      onTap: () => widget.viewModel.onSelectTeam(team),
                      child: Container(
                        padding: EdgeInsets.all(
                          defaultPadding / 2,
                        ),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(defaultBorderRadius),
                                color: widget.viewModel.selectedTeam?.idTeam ==
                                        team.idTeam
                                    ? primaryBlue
                                    : secondaryPaper,
                              ),
                              width: 4,
                              height: 35,
                              margin:
                                  EdgeInsets.only(right: defaultPadding / 2),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    team.name,
                                    style: TextStyle(
                                      color:
                                          team.sport == widget.viewModel.sport
                                              ? textBlack
                                              : textLightGrey,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        team.sport.description,
                                        style: TextStyle(
                                          color: team.sport ==
                                                  widget.viewModel.sport
                                              ? textDarkGrey
                                              : red,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        " | ${team.rank.name} | ${team.gender.name}",
                                        style: TextStyle(
                                          color: textDarkGrey,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
        ),
      ],
    );
  }
}
