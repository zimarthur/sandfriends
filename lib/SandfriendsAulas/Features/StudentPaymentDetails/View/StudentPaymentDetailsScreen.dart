import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Components/SFAvatarUser.dart';
import 'package:sandfriends/Common/Components/SFButton.dart';
import 'package:sandfriends/Common/Model/AppMatch/AppMatchUser.dart';
import 'package:sandfriends/Common/Utils/TypeExtensions.dart';
import 'package:sandfriends/SandfriendsAulas/Features/StudentPaymentDetails/View/PaymentDetails.dart';
import 'package:sandfriends/SandfriendsAulas/Features/Students/Model/TeamPaymentForUser.dart';
import 'package:sandfriends/SandfriendsAulas/SharedComponents/AulasSectionTitleText.dart';

import '../../../../Common/StandardScreen/StandardScreen.dart';
import '../../../../Common/Utils/Constants.dart';
import '../../Students/Model/UserClassPayment.dart';
import '../ViewModel/StudentPaymentDetailsViewModel.dart';

class StudentPaymentDetailsScreen extends StatefulWidget {
  UserClassPayment userClassPayment;
  StudentPaymentDetailsScreen({
    required this.userClassPayment,
    super.key,
  });

  @override
  State<StudentPaymentDetailsScreen> createState() =>
      _StudentPaymentDetailsScreenState();
}

class _StudentPaymentDetailsScreenState
    extends State<StudentPaymentDetailsScreen> {
  final viewModel = StudentPaymentDetailsViewModel();
  @override
  void initState() {
    viewModel.initStudentPaymentDetaisl(context, widget.userClassPayment);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<StudentPaymentDetailsViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<StudentPaymentDetailsViewModel>(
        builder: (context, viewModel, _) {
          return StandardScreen(
            titleText: "Informações do aluno",
            background: secondaryBack,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: defaultPadding / 2,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: defaultPadding,
                  ),
                  Row(
                    children: [
                      SFAvatarUser(
                        height: 100,
                        user: viewModel.userClassPayment.user,
                        showRank: false,
                      ),
                      SizedBox(
                        width: defaultPadding / 2,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              viewModel.userClassPayment.user.fullName,
                              style: TextStyle(
                                color: textDarkGrey,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "${viewModel.userClassPayment.totalMatches.length} aulas em ${viewModel.userClassPayment.totalMatches.first.date.formatWrittenMonthYear()}",
                              style: TextStyle(
                                color: textLightGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: defaultPadding,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: secondaryPaper,
                      borderRadius: BorderRadius.circular(
                        defaultBorderRadius,
                      ),
                      border: Border.all(
                        color: divider,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: defaultPadding / 2,
                      vertical: defaultPadding,
                    ),
                    child: PaymentDetails(
                      total: viewModel.userClassPayment.totalCost.formatPrice(),
                      paid: viewModel.userClassPayment.totalPaid.formatPrice(),
                      remaining: viewModel.userClassPayment.remainingCost
                          .formatPrice(),
                    ),
                  ),
                  SizedBox(
                    height: defaultPadding,
                  ),
                  SectionTitleText(
                    title:
                        "Turmas (${viewModel.userClassPayment.teamPayments.length})",
                  ),
                  SizedBox(
                    height: defaultPadding / 2,
                  ),
                  ListView.builder(
                    itemCount: viewModel.userClassPayment.teamPayments.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      TeamPaymentForUser teamPaymentForUser =
                          viewModel.userClassPayment.teamPayments[index];
                      return Container(
                        margin: EdgeInsets.symmetric(
                          vertical: defaultPadding / 2,
                        ),
                        decoration: BoxDecoration(
                          color: primaryBlue,
                          borderRadius: BorderRadius.circular(
                            defaultBorderRadius,
                          ),
                          border: Border.all(
                            color: divider,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 2,
                              offset: Offset(2, 2),
                              color: divider,
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(
                                defaultPadding / 2,
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    r"assets/icon/class.svg",
                                    color: textWhite,
                                    height: 15,
                                  ),
                                  SizedBox(
                                    width: defaultPadding / 2,
                                  ),
                                  Expanded(
                                    child: Text(
                                      teamPaymentForUser.team.name,
                                      style: TextStyle(
                                        color: textWhite,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: defaultPadding / 2,
                                  ),
                                  SvgPicture.asset(
                                    r"assets/icon/user_singular.svg",
                                    color: textWhite,
                                    height: 15,
                                  ),
                                  SizedBox(
                                    width: defaultPadding / 2,
                                  ),
                                  Text(
                                    teamPaymentForUser
                                        .team.acceptedMembers.length
                                        .toString(),
                                    style: TextStyle(
                                      color: textWhite,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: secondaryPaper,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(
                                    defaultBorderRadius,
                                  ),
                                  bottomRight: Radius.circular(
                                    defaultBorderRadius,
                                  ),
                                ),
                              ),
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                vertical: defaultPadding / 2,
                                horizontal: defaultPadding,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Regra de preço utilizada",
                                    style: TextStyle(
                                      color: textDarkGrey,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 10,
                                    ),
                                  ),
                                  Text(
                                    teamPaymentForUser
                                        .classPlanForUser.completeDescription,
                                    style: TextStyle(
                                      color: primaryBlue,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(
                                    height: defaultPadding,
                                  ),
                                  Text(
                                    "Aulas",
                                    style: TextStyle(
                                      color: textDarkGrey,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 10,
                                    ),
                                  ),
                                  ListView.builder(
                                      itemCount: teamPaymentForUser
                                          .pricedTeamMatches.length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                        AppMatchUser match = teamPaymentForUser
                                            .pricedTeamMatches[index];
                                        return GestureDetector(
                                          onTap: () => viewModel.onTapMatch(
                                            context,
                                            match,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: defaultPadding / 2,
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/icon/${match.selectedMember!.hasPaid ? 'check_circle' : 'x_circle'}.svg",
                                                      color: match
                                                              .selectedMember!
                                                              .hasPaid
                                                          ? greenText
                                                          : redText,
                                                    ),
                                                    SizedBox(
                                                      width: defaultPadding / 2,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        DateFormat("dd/MM/yy")
                                                            .format(match.date),
                                                        style: TextStyle(
                                                          color: textDarkGrey,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: defaultPadding / 2,
                                                    ),
                                                    Text(
                                                      match
                                                          .selectedMember!.cost!
                                                          .formatPrice(),
                                                      style: TextStyle(
                                                        color: primaryBlue,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: defaultPadding / 2,
                                                    ),
                                                    SvgPicture.asset(
                                                      r"assets/icon/edit.svg",
                                                      color: primaryBlue,
                                                      height: 20,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: defaultPadding / 4,
                                                ),
                                                Container(
                                                  color: divider,
                                                  height: 2,
                                                  width: double.infinity,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                  SizedBox(
                                    height: defaultPadding,
                                  ),
                                  PaymentDetails(
                                    total: teamPaymentForUser.totalCost
                                        .formatPrice(),
                                    paid: teamPaymentForUser.totalPaid
                                        .formatPrice(),
                                    remaining: teamPaymentForUser.remainingCost
                                        .formatPrice(),
                                  ),
                                  SizedBox(
                                    height: defaultPadding,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
