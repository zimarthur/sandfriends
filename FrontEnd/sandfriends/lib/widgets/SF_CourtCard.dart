import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/widgets/SF_Button.dart';

import '../models/court.dart';
import '../theme/app_theme.dart';

class SFCourtCard extends StatefulWidget {
  final Court court;

  SFCourtCard({
    required this.court,
  });

  @override
  State<SFCourtCard> createState() => _SFCourtCardState();
}

class _SFCourtCardState extends State<SFCourtCard> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.03),
      margin: EdgeInsets.symmetric(vertical: height * 0.005),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
            color: AppTheme.colors.secondaryPaper,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.colors.divider, width: 0.5)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      r"assets\icon\logo.png",
                      height: 82,
                      width: 82,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(right: 12)),
                  Expanded(
                      child: SizedBox(
                    height: 82,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.court.name,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: AppTheme.colors.primaryBlue),
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(r"assets\icon\location_ping.svg"),
                            Text(
                              widget.court.address,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                  color: AppTheme.colors.primaryBlue),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Horários disponíveis",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: AppTheme.colors.textDarkGrey),
                            ),
                            Text(
                              "Selecione uma ou mais opções",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                  color: AppTheme.colors.textDarkGrey),
                            ),
                          ],
                        )
                      ],
                    ),
                  )),
                ],
              ),
            ),
            Container(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.court.availableHours.length,
                itemBuilder: ((context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Container(
                      width: 75,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: AppTheme.colors.primaryBlue, width: 1),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset(r"assets\icon\clock.svg"),
                                Expanded(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      widget.court.availableHours[index].hour,
                                      style: TextStyle(
                                          color: AppTheme.colors.primaryBlue),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset(r"assets\icon\payment.svg"),
                                Expanded(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      widget.court.availableHours[index].price,
                                      style: TextStyle(
                                          color: AppTheme.colors.primaryBlue),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.1, vertical: height * 0.01),
              child: SFButton(
                  buttonLabel: "Agendar Horário",
                  buttonType: ButtonType.Disabled,
                  textPadding: EdgeInsets.symmetric(vertical: 5),
                  onTap: () {}),
            ),
          ],
        ),
      ),
    );
  }
}
