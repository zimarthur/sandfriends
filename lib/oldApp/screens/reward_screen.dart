import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/oldApp/models/enums.dart';
import 'package:sandfriends/oldApp/providers/user_provider.dart';
import 'package:sandfriends/oldApp/theme/app_theme.dart';
import 'package:sandfriends/oldApp/widgets/SF_Button.dart';
import 'package:sandfriends/oldApp/widgets/SF_Scaffold.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class RewardScreen extends StatefulWidget {
  @override
  State<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  bool showModal = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SFScaffold(
      titleText: "Recompensas",
      onTapReturn: () =>
          context.goNamed('home', params: {'initialPage': 'feed_screen'}),
      appBarType: AppBarType.Secondary,
      showModal: showModal,
      child: Container(
        color: AppTheme.colors.secondaryBack,
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: height * 0.1),
              child: ClipOval(
                child: Container(
                  height: height * 0.2,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.colors.secondaryYellow,
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: height * 0.8,
              margin: EdgeInsets.only(top: height * 0.2),
              padding: EdgeInsets.symmetric(
                  vertical: height * 0.02, horizontal: width * 0.05),
              color: AppTheme.colors.secondaryYellow,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: height * 0.02),
                    child: Text(
                      Provider.of<UserProvider>(context, listen: false)
                          .userReward!
                          .description,
                      textAlign: TextAlign.center,
                      textScaleFactor: 1.5,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.colors.textBlue,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        height:
                            Provider.of<UserProvider>(context, listen: false)
                                        .userReward!
                                        .userRewardQuantity ==
                                    Provider.of<UserProvider>(context,
                                            listen: false)
                                        .userReward!
                                        .rewardQuantity
                                ? height * 0.3
                                : height * 0.2,
                        child: SfRadialGauge(axes: <RadialAxis>[
                          RadialAxis(
                            annotations: <GaugeAnnotation>[
                              GaugeAnnotation(
                                  positionFactor: 0.1,
                                  angle: 90,
                                  widget: Text(
                                    "${Provider.of<UserProvider>(context, listen: false).userReward!.userRewardQuantity} de ${Provider.of<UserProvider>(context, listen: false).userReward!.rewardQuantity}",
                                    style: TextStyle(
                                        color: Provider.of<UserProvider>(
                                                        context,
                                                        listen: false)
                                                    .userReward!
                                                    .userRewardQuantity ==
                                                Provider.of<UserProvider>(
                                                        context,
                                                        listen: false)
                                                    .userReward!
                                                    .rewardQuantity
                                            ? Colors.green
                                            : AppTheme.colors.primaryBlue,
                                        fontWeight: FontWeight.w500),
                                  ))
                            ],
                            pointers: <GaugePointer>[
                              RangePointer(
                                value: Provider.of<UserProvider>(context,
                                        listen: false)
                                    .userReward!
                                    .userRewardQuantity!
                                    .toDouble(),
                                cornerStyle: CornerStyle.bothCurve,
                                width: 0.2,
                                sizeUnit: GaugeSizeUnit.factor,
                                color: Provider.of<UserProvider>(context,
                                                listen: false)
                                            .userReward!
                                            .userRewardQuantity ==
                                        Provider.of<UserProvider>(context,
                                                listen: false)
                                            .userReward!
                                            .rewardQuantity
                                    ? Colors.green
                                    : AppTheme.colors.primaryBlue,
                              )
                            ],
                            minimum: 0,
                            maximum: Provider.of<UserProvider>(context,
                                    listen: false)
                                .userReward!
                                .rewardQuantity
                                .toDouble(),
                            showLabels: false,
                            showTicks: false,
                            axisLineStyle: AxisLineStyle(
                              thickness: 0.2,
                              cornerStyle: CornerStyle.bothCurve,
                              color:
                                  AppTheme.colors.primaryBlue.withOpacity(0.3),
                              thicknessUnit: GaugeSizeUnit.factor,
                            ),
                          )
                        ]),
                      ),
                      Provider.of<UserProvider>(context, listen: false)
                                  .userReward!
                                  .userRewardQuantity ==
                              Provider.of<UserProvider>(context, listen: false)
                                  .userReward!
                                  .rewardQuantity
                          ? RichText(
                              textAlign: TextAlign.center,
                              textScaleFactor: 1.1,
                              text: const TextSpan(
                                text: 'Você completou o desafio!\nEntre em ',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500,
                                ),
                                children: [
                                  TextSpan(
                                    text: '"Minhas Recompensas"',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: Colors.green,
                                    ),
                                  ),
                                  TextSpan(
                                      text: ' para coletar sua recompensa.'),
                                ],
                              ),
                            )
                          : Column(
                              children: [
                                Container(
                                  height: height * 0.1,
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        child: Text(
                                          "Recompensas:",
                                          textScaleFactor: 1.1,
                                          style: TextStyle(
                                            color: AppTheme.colors.textDarkGrey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: Provider.of<UserProvider>(
                                                  context,
                                                  listen: false)
                                              .userReward!
                                              .rewards
                                              .length,
                                          itemBuilder: (context, index) {
                                            return Text(
                                              "- ${Provider.of<UserProvider>(context, listen: false).userReward!.rewards[index]}",
                                              style: TextStyle(
                                                  color: AppTheme
                                                      .colors.textDarkGrey),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  child: Text(
                                    "*válido de ${DateFormat("dd/MM/yyyy").format(Provider.of<UserProvider>(context, listen: false).userReward!.startingDate)} até ${DateFormat("dd/MM/yyyy").format(Provider.of<UserProvider>(context, listen: false).userReward!.endingDate)}",
                                    textScaleFactor: 0.9,
                                    style: TextStyle(
                                      color: AppTheme.colors.textDarkGrey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                  SFButton(
                      textPadding:
                          EdgeInsets.symmetric(vertical: height * 0.01),
                      buttonLabel: "Minhas Recompensas",
                      buttonType: ButtonType.YellowSecondary,
                      onTap: () {
                        context.goNamed('reward_user_screen');
                      }),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: height * 0.03),
              height: height * 0.2,
              child: SvgPicture.asset(
                r"assets\icon\medal.svg",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
