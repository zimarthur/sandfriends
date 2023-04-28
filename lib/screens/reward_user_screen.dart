import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/models/enums.dart';
import 'package:sandfriends/models/reward_user.dart';
import 'package:sandfriends/widgets/SF_Scaffold.dart';
import 'package:http/http.dart' as http;

import '../providers/categories_provider.dart';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/SFLoading.dart';

class RewardUserScreen extends StatefulWidget {
  const RewardUserScreen({Key? key}) : super(key: key);

  @override
  State<RewardUserScreen> createState() => _RewardUserScreenState();
}

class _RewardUserScreenState extends State<RewardUserScreen> {
  bool showModal = false;
  Widget? modalWidget;
  bool isLoading = true;
  List<RewardUser> userRewards = [];

  @override
  void initState() {
    super.initState();
    GetUserRewards(context);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SFScaffold(
      titleText: "Minhas recompensas",
      onTapReturn: () => context.goNamed('reward_screen'),
      appBarType: AppBarType.Secondary,
      showModal: showModal,
      modalWidget: modalWidget,
      onTapBackground: () {
        setState(() {
          showModal = false;
        });
      },
      child: Container(
        color: AppTheme.colors.secondaryBack,
        child: Container(
          child: isLoading
              ? const Expanded(
                  child: Center(
                    child: SFLoading(),
                  ),
                )
              : Container(
                  color: AppTheme.colors.secondaryBack,
                  child: ListView.builder(
                      itemCount: userRewards.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              if (userRewards[index].rewardClaimed) {
                                modalWidget = Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.04,
                                  ),
                                  height: height * 0.55,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        height: height * 0.1,
                                        child: SvgPicture.asset(
                                            r"assets\icon\happy_face.svg"),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        height: height * 0.1,
                                        child: Text(
                                          "Você já coleteu essa recompensa no dia ${DateFormat("dd/MM/yyyy").format(userRewards[index].rewardClaimedDate!)}",
                                          textScaleFactor: 1.5,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: AppTheme.colors.textBlue,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Container(
                                        height: height * 0.15,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: width * 0.25,
                                                  child: Text("Objetivo: "),
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        right: width * 0.02)),
                                                Flexible(
                                                  child: Text(
                                                    userRewards[index]
                                                        .monthReward
                                                        .description,
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  width: width * 0.25,
                                                  child: Text("Recompensa: "),
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        right: width * 0.02)),
                                                Flexible(
                                                  child: Text(
                                                    userRewards[index]
                                                        .selectedReward!,
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  width: width * 0.25,
                                                  child: Flexible(
                                                    child: Text("Local: "),
                                                  ),
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        right: width * 0.02)),
                                                Expanded(
                                                  child: Text(
                                                    userRewards[index]
                                                        .store!
                                                        .name,
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                modalWidget = Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.04,
                                  ),
                                  height: height * 0.55,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        height: height * 0.1,
                                        child: SvgPicture.asset(
                                            r"assets\icon\happy_face.svg"),
                                      ),
                                      Container(
                                        height: height * 0.1,
                                        child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Text(
                                            "Colete sua recompensa!",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: AppTheme.colors.textBlue,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: height * 0.05,
                                        child: Flexible(
                                          child: Text(
                                            "Apresente o código abaixo a um estabelecimento parceiro",
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        height: height * 0.1,
                                        child: Text(
                                          "${userRewards[index].idRewardUser}",
                                          textScaleFactor: 2,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: AppTheme.colors.textBlue,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Container(
                                        height: height * 0.03,
                                        child: Flexible(
                                          child: Text(
                                            "e informe qual recompensa você deseja:",
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: height * 0.1,
                                        child: ListView.builder(
                                          itemCount: userRewards[index]
                                              .monthReward
                                              .rewards
                                              .length,
                                          itemBuilder: (context, rewardIndex) {
                                            return Text(
                                              "- ${userRewards[index].monthReward.rewards[rewardIndex]}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color:
                                                      AppTheme.colors.textBlue,
                                                  fontWeight: FontWeight.w500),
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }

                              showModal = true;
                            });
                          },
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: userRewards[index].rewardClaimed == true
                                    ? AppTheme.colors.secondaryYellow
                                        .withOpacity(0.5)
                                    : AppTheme.colors.secondaryYellow,
                                width: 1,
                              ),
                              color: userRewards[index].rewardClaimed == true
                                  ? AppTheme.colors.secondaryYellow
                                      .withOpacity(0.1)
                                  : AppTheme.colors.secondaryYellow
                                      .withOpacity(0.6),
                            ),
                            margin: EdgeInsets.symmetric(
                                vertical: height * 0.005,
                                horizontal: width * 0.02),
                            padding: EdgeInsets.symmetric(
                                horizontal: width * 0.02,
                                vertical: height * 0.01),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 5),
                                  height: 15,
                                  child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      "${Provider.of<CategoriesProvider>(context, listen: false).monthsPortugueseComplete[userRewards[index].monthReward.startingDate.month - 1]} de ${userRewards[index].monthReward.startingDate.year}",
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: width * 0.2,
                                        child: SvgPicture.asset(
                                            r"assets\icon\medal.svg"),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          right: width * 0.04,
                                        ),
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          height: width * 0.2,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  userRewards[index]
                                                      .monthReward
                                                      .description,
                                                  textAlign: TextAlign.start,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  userRewards[index]
                                                          .rewardClaimed
                                                      ? "Você já coletou essa recompensa"
                                                      : "Toque para coletar sua recompensa",
                                                  style: (TextStyle(
                                                    color: userRewards[index]
                                                            .rewardClaimed
                                                        ? AppTheme.colors
                                                            .textLightGrey
                                                        : AppTheme.colors
                                                            .textDarkGrey,
                                                  )),
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
                          ),
                        );
                      }),
                ),
        ),
      ),
    );
  }

  Future<void> GetUserRewards(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    var response = await http.get(
      Uri.parse(
          'https://www.sandfriends.com.br/RewardUserStatus/${Provider.of<UserProvider>(context, listen: false).user!.idUser}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (mounted) {
      if (response.statusCode == 200) {
        userRewards.clear();
        Map<String, dynamic> responseBody = json.decode(response.body);
        for (int i = 0; i < responseBody['RewardUser'].length; i++) {
          userRewards.add(rewardUserFromJson(responseBody['RewardUser'][i]));
        }
        userRewards.sort(
          (a, b) {
            int compare = b.monthReward.startingDate
                .compareTo(a.monthReward.startingDate);

            if (compare == 0) {
              return b.monthReward.startingDate
                  .compareTo(a.monthReward.startingDate);
            } else {
              return compare;
            }
          },
        );
      }
    }

    setState(() {
      isLoading = false;
    });
  }
}
