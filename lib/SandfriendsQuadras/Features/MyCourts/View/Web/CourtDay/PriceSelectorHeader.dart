import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/SandfriendsQuadras/Features/MyCourts/ViewModel/MyCourtsViewModel.dart';
import '../../../../../../Common/Utils/Constants.dart';

class PriceSelectorHeader extends StatelessWidget {
  bool allowRecurrent;
  bool isSettingTeacherPrices;
  MyCourtsViewModel viewModel;

  PriceSelectorHeader({
    super.key,
    required this.allowRecurrent,
    required this.isSettingTeacherPrices,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          flex: 3,
          child: Text(
            "Intervalo",
            style: TextStyle(color: textLightGrey),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isSettingTeacherPrices)
                Padding(
                  padding: EdgeInsets.only(
                    right: defaultPadding / 2,
                  ),
                  child: SvgPicture.asset(
                    r"assets/icon/class.svg",
                    color: primaryBlue,
                    height: 20,
                  ),
                ),
              Text(
                "Avulso",
                style: TextStyle(color: textLightGrey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: allowRecurrent
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isSettingTeacherPrices)
                      Padding(
                        padding: EdgeInsets.only(
                          right: defaultPadding / 2,
                        ),
                        child: SvgPicture.asset(
                          r"assets/icon/class.svg",
                          color: primaryBlue,
                          height: 20,
                        ),
                      ),
                    Text(
                      "Mensalista",
                      style: TextStyle(color: textLightGrey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              : Container(),
        ),
      ],
    );
  }
}
