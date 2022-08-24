import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/providers/match_provider.dart';
import 'package:sandfriends/widgets/SF_AvailableHours.dart';
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
  bool isSelectedCourt(BuildContext context, bool listen) {
    if (Provider.of<MatchProvider>(context, listen: listen)
            .indexSelectedCourt ==
        widget.court.index) {
      return true;
    } else {
      return false;
    }
  }

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
                    child: Image.network(
                      widget.court.imageUrl,
                      height: 82,
                      width: 82,
                    ),
                    /*Image.asset(
                      r"assets\icon\logo.png",
                      height: 82,
                      width: 82,
                    ),*/
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
                  return SFAvailableHours(
                    court: widget.court,
                    hourIndex: index,
                  );
                }),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.03, vertical: height * 0.01),
              child: SFButton(
                  buttonLabel: "Agendar Horário",
                  buttonType: isSelectedCourt(context, true)
                      ? ButtonType.Primary
                      : ButtonType.Disabled,
                  textPadding: EdgeInsets.symmetric(vertical: 5),
                  onTap: () {
                    if (isSelectedCourt(context, false)) {
                      print("pode agendar");
                      context.goNamed('court_screen');
                    } else {
                      print("seleciona horario antes");
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
