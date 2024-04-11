import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Components/SFAvatarUser.dart';
import 'package:sandfriends/Common/Components/SFTextField.dart';
import 'package:sandfriends/Common/Model/AppMatch/AppMatchUser.dart';
import 'package:sandfriends/Common/Model/MatchMember.dart';
import 'package:sandfriends/Common/Model/User/User.dart';
import 'package:sandfriends/Common/Utils/Validators.dart';

import '../../../../Common/Components/SFButton.dart';
import '../../../../Common/StandardScreen/StandardScreenViewModel.dart';
import '../../../../Common/Utils/Constants.dart';
import '../../Students/Model/TeamPaymentForUser.dart';

class ClassMatchPaymentModal extends StatefulWidget {
  AppMatchUser match;
  User user;
  Function(bool, double) onUpdateClassPayment;
  ClassMatchPaymentModal({
    required this.match,
    required this.user,
    required this.onUpdateClassPayment,
    super.key,
  });

  @override
  State<ClassMatchPaymentModal> createState() => _ClassMatchPaymentModalState();
}

class _ClassMatchPaymentModalState extends State<ClassMatchPaymentModal> {
  final classPaymentPriceKey = GlobalKey<FormState>();

  TextEditingController priceController = TextEditingController();
  late bool hasPaid;
  List<MatchMember> sortedMembers = [];

  @override
  void initState() {
    priceController.text =
        widget.match.selectedMember!.cost!.toStringAsFixed(0);
    hasPaid = widget.match.selectedMember!.hasPaid;
    sortedMembers = widget.match.classMembers;
    for (int i = 0; i < sortedMembers.length; i++) {
      if (sortedMembers[i].user.id == widget.user.id) {
        MatchMember auxMember = sortedMembers[i];
        sortedMembers[i] = sortedMembers[0];
        sortedMembers[0] = auxMember;
      }
    }
    super.initState();
  }

  bool get hasChanged =>
      hasPaid != widget.match.selectedMember!.hasPaid ||
      priceController.text !=
          widget.match.selectedMember!.cost!.toStringAsFixed(0);

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
      child: Form(
        key: classPaymentPriceKey,
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () =>
                    Provider.of<StandardScreenViewModel>(context, listen: false)
                        .removeLastOverlay(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                  child: SvgPicture.asset(
                    r"assets/icon/x.svg",
                    color: textDarkGrey,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Turma:",
                    style: TextStyle(
                        color: textDarkGrey,
                        fontSize: 12,
                        fontWeight: FontWeight.w300),
                  ),
                  SizedBox(
                    height: defaultPadding / 4,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        r"assets/icon/class.svg",
                        color: primaryBlue,
                        height: 15,
                      ),
                      SizedBox(
                        width: defaultPadding / 2,
                      ),
                      Expanded(
                        child: Text(
                          widget.match.team!.name,
                          style: TextStyle(
                            color: primaryBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: defaultPadding / 2,
                  ),
                  Text(
                    "Aula:",
                    style: TextStyle(
                        color: textDarkGrey,
                        fontSize: 12,
                        fontWeight: FontWeight.w300),
                  ),
                  SizedBox(
                    height: defaultPadding / 4,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        r"assets/icon/calendar.svg",
                        color: primaryBlue,
                        height: 15,
                      ),
                      SizedBox(
                        width: defaultPadding / 2,
                      ),
                      Expanded(
                        child: Text(
                          DateFormat("dd/MM/yyyy").format(widget.match.date),
                          style: TextStyle(
                            color: primaryBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        r"assets/icon/court.svg",
                        color: primaryBlue,
                        height: 15,
                      ),
                      SizedBox(
                        width: defaultPadding / 2,
                      ),
                      Expanded(
                        child: Text(
                          widget.match.court.store!.name,
                          style: TextStyle(
                            color: primaryBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: defaultPadding / 2,
                  ),
                  Text(
                    "Alunos nessa aula:",
                    style: TextStyle(
                        color: textDarkGrey,
                        fontSize: 12,
                        fontWeight: FontWeight.w300),
                  ),
                  SizedBox(
                    height: defaultPadding / 4,
                  ),
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: sortedMembers.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            SFAvatarUser(
                              height: 60,
                              user: sortedMembers[index].user,
                              showRank: false,
                              customBorderColor:
                                  index == 0 ? primaryBlue : null,
                            ),
                            Text(
                              sortedMembers[index].user.firstName!,
                              style: TextStyle(
                                color: index == 0 ? primaryBlue : textDarkGrey,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: defaultPadding / 2,
                  ),
                  Expanded(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          defaultBorderRadius,
                        ),
                        border: Border.all(
                          color: primaryBlue,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Pagamento",
                            style: TextStyle(
                              color: primaryBlue,
                              fontSize: 16,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "Preço:",
                                style: TextStyle(
                                  color: textDarkGrey,
                                ),
                              ),
                              SizedBox(
                                width: defaultPadding,
                              ),
                              Expanded(
                                child: SFTextField(
                                  labelText: "",
                                  pourpose: TextFieldPourpose.Numeric,
                                  controller: priceController,
                                  textAlign: TextAlign.center,
                                  prefixText: r"R$",
                                  validator: (price) => priceValidator(
                                      price, "Digite o valor da aula"),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Status:",
                                style: TextStyle(
                                  color: textDarkGrey,
                                ),
                              ),
                              SizedBox(
                                width: defaultPadding,
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () => setState(() {
                                        hasPaid = true;
                                      }),
                                      child: Container(
                                        padding:
                                            EdgeInsets.all(defaultPadding / 2),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              defaultBorderRadius),
                                          color: hasPaid ? greenBg : divider,
                                          border: Border.all(
                                            color: hasPaid
                                                ? greenText
                                                : textDarkGrey,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              r"assets/icon/check_circle.svg",
                                              color: hasPaid
                                                  ? greenText
                                                  : textDarkGrey,
                                            ),
                                            SizedBox(
                                              width: defaultPadding / 2,
                                            ),
                                            Text(
                                              "Confirmado",
                                              style: TextStyle(
                                                color: hasPaid
                                                    ? greenText
                                                    : textDarkGrey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: defaultPadding / 2,
                                    ),
                                    GestureDetector(
                                      onTap: () => setState(() {
                                        hasPaid = false;
                                      }),
                                      child: Container(
                                        padding:
                                            EdgeInsets.all(defaultPadding / 2),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              defaultBorderRadius),
                                          color: hasPaid ? divider : redBg,
                                          border: Border.all(
                                            color: hasPaid
                                                ? textDarkGrey
                                                : redText,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              r"assets/icon/x_circle.svg",
                                              color: hasPaid
                                                  ? textDarkGrey
                                                  : redText,
                                            ),
                                            SizedBox(
                                              width: defaultPadding / 2,
                                            ),
                                            Text(
                                              "Não confirmado",
                                              style: TextStyle(
                                                color: hasPaid
                                                    ? textDarkGrey
                                                    : redText,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: defaultPadding,
            ),
            SFButton(
              buttonLabel: "Salvar",
              color: hasChanged ? primaryBlue : disabled,
              onTap: () {
                if (hasChanged &&
                    classPaymentPriceKey.currentState?.validate() == true) {
                  widget.onUpdateClassPayment(
                      hasPaid, double.parse(priceController.text));
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
