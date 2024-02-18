import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../Common/Utils/Constants.dart';
import '../../ViewModel/HomeViewModel.dart';
import '../Web/OccupationWidget.dart';

class CourtOccupationWidget extends StatefulWidget {
  HomeViewModel viewModel;
  CourtOccupationWidget({
    required this.viewModel,
    super.key,
  });

  @override
  State<CourtOccupationWidget> createState() => _CourtOccupationWidgetState();
}

class _CourtOccupationWidgetState extends State<CourtOccupationWidget> {
  bool isExpanded = false;
  Duration duration = Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => setState(() {
        isExpanded = !isExpanded;
      }),
      child: Container(
        decoration: BoxDecoration(
          color: textWhite,
          borderRadius: BorderRadius.circular(defaultBorderRadius),
          boxShadow: [
            BoxShadow(
              color: textLightGrey,
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(0, 5), // changes position of shadow
            ),
          ],
          border: isExpanded
              ? Border.all(
                  color: primaryBlue,
                  width: 2,
                )
              : null,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: defaultPadding,
          vertical: defaultPadding / 2,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Ocupação das quadras",
                  style: TextStyle(
                    color: textBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AnimatedRotation(
                  duration: duration,
                  turns: isExpanded ? 0.5 : 0,
                  child: SvgPicture.asset(
                    r"assets/icon/chevron_down.svg",
                    color: primaryBlue,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: OccupationWidget(
                title: "Geral",
                result: widget.viewModel.averageOccupation,
              ),
            ),
            if (isExpanded)
              Column(
                children: [
                  Container(
                    height: 2,
                    width: double.infinity,
                    color: divider,
                    padding: EdgeInsets.symmetric(vertical: defaultPadding / 2),
                  ),
                  ListView.builder(
                    itemCount: widget.viewModel.courtsOccupation.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.all(defaultPadding / 2),
                        child: OccupationWidget(
                          title: widget.viewModel.courtsOccupation[index].court
                              .description,
                          result: widget.viewModel.courtsOccupation[index]
                              .occupationPercentage,
                        ),
                      );
                    },
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
