import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../SharedComponents/Providers/UserProvider/UserProvider.dart';
import '../../../SharedComponents/View/SFButton.dart';
import '../../../Utils/Constants.dart';
import '../ViewModel/RewardsViewModel.dart';

class RewardsWidget extends StatefulWidget {
  RewardsViewModel viewModel;
  RewardsWidget({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  State<RewardsWidget> createState() => _RewardsWidgetState();
}

class _RewardsWidgetState extends State<RewardsWidget> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      color: secondaryBack,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: height * 0.1),
            child: ClipOval(
              child: Container(
                height: height * 0.2,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: secondaryYellow,
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
            color: secondaryYellow,
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
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: textBlue,
                    ),
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: Provider.of<UserProvider>(context, listen: false)
                                  .userReward!
                                  .userRewardQuantity ==
                              Provider.of<UserProvider>(context, listen: false)
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
                                    color: Provider.of<UserProvider>(context,
                                                    listen: false)
                                                .userReward!
                                                .userRewardQuantity ==
                                            Provider.of<UserProvider>(context,
                                                    listen: false)
                                                .userReward!
                                                .rewardQuantity
                                        ? Colors.green
                                        : primaryBlue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textScaleFactor: 1.3,
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
                                  : primaryBlue,
                            )
                          ],
                          minimum: 0,
                          maximum:
                              Provider.of<UserProvider>(context, listen: false)
                                  .userReward!
                                  .rewardQuantity
                                  .toDouble(),
                          showLabels: false,
                          showTicks: false,
                          axisLineStyle: AxisLineStyle(
                            thickness: 0.2,
                            cornerStyle: CornerStyle.bothCurve,
                            color: primaryBlue.withOpacity(0.3),
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
                                fontFamily: 'Lexend',
                              ),
                              children: [
                                TextSpan(
                                  text: '"Minhas Recompensas"',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: Colors.green,
                                    fontFamily: 'Lexend',
                                  ),
                                ),
                                TextSpan(
                                    text: ' para coletar sua recompensa.',
                                    style: TextStyle(
                                      fontFamily: 'Lexend',
                                    )),
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              Container(
                                height: height * 0.1,
                                alignment: Alignment.centerLeft,
                                margin:
                                    EdgeInsets.only(bottom: defaultPadding * 2),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        "Recompensas:",
                                        textScaleFactor: 1.1,
                                        style: TextStyle(
                                          color: textDarkGrey,
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
                                            style: const TextStyle(
                                                color: textDarkGrey),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  "*válido de ${DateFormat("dd/MM/yyyy").format(Provider.of<UserProvider>(context, listen: false).userReward!.startingDate)} até ${DateFormat("dd/MM/yyyy").format(Provider.of<UserProvider>(context, listen: false).userReward!.endingDate)} para partidas pagas pelo app",
                                  textScaleFactor: 0.9,
                                  style: const TextStyle(
                                    color: textDarkGrey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
                SFButton(
                  textPadding: EdgeInsets.symmetric(vertical: height * 0.01),
                  buttonLabel: "Minhas Recompensas",
                  color: secondaryYellow,
                  isPrimary: false,
                  onTap: () => widget.viewModel.goToRewardsUserScreen(
                    context,
                  ),
                ),
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
    );
  }
}
