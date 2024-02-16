import 'package:flutter/material.dart';
import 'package:sandfriends_web/Utils/Constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class KPI extends StatelessWidget {
  String title;
  String value;
  String iconPath;
  Color primaryColor;
  Color secondaryColor;
  bool isCurrency;

  KPI({
    required this.title,
    required this.value,
    required this.iconPath,
    required this.primaryColor,
    required this.secondaryColor,
    this.isCurrency = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: textWhite,
        borderRadius: BorderRadius.circular(
          defaultBorderRadius,
        ),
        boxShadow: [
          BoxShadow(
            color: textLightGrey,
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 5), // changes position of shadow
          ),
        ],
        border: Border.all(
          color: textLightGrey,
          width: 0.5,
        ),
      ),
      height: 65,
      padding: EdgeInsets.symmetric(
          vertical: defaultPadding / 2, horizontal: defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: textDarkGrey,
              fontSize: 10,
            ),
          ),
          SizedBox(
            height: defaultPadding / 4,
          ),
          Expanded(
              child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: secondaryColor,
                ),
                height: 30,
                width: 30,
                child: Center(
                  child: SvgPicture.asset(
                    iconPath,
                    color: primaryColor,
                    height: 20,
                    width: 20,
                  ),
                ),
              ),
              SizedBox(
                width: defaultPadding / 2,
              ),
              Expanded(
                  child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isCurrency)
                      Text(
                        "R\$",
                        style: TextStyle(
                          color: textLightGrey,
                        ),
                      ),
                    Text(
                      value,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    )
                  ],
                ),
              ))
            ],
          ))
        ],
      ),
    );
  }
}
