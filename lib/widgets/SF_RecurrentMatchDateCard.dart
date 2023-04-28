import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class RecurrentMatchDateCard extends StatelessWidget {
  String month;
  int day;
  RecurrentMatchDateCard({Key? key, required this.day, required this.month})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 60,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppTheme.colors.primaryLightBlue,
          width: 0.5,
        ),
        color: AppTheme.colors.secondaryPaper,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 20,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Text(
                      month,
                      style: TextStyle(
                        color: AppTheme.colors.textDarkGrey,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 35,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Text(
                      "$day",
                      style: TextStyle(
                        color: AppTheme.colors.textDarkGrey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 10,
            decoration: BoxDecoration(
              color: AppTheme.colors.primaryLightBlue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16.0),
                bottomRight: Radius.circular(16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
