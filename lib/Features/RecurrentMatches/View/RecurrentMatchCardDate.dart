import 'package:flutter/material.dart';

import '../../../Utils/Constants.dart';

class RecurrentMatchCardDate extends StatelessWidget {
  String month;
  int day;
  RecurrentMatchCardDate({Key? key, 
    required this.month,
    required this.day,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 60,
      decoration: BoxDecoration(
        border: Border.all(
          color: primaryLightBlue,
          width: 0.5,
        ),
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Text(
                      month,
                      style: const TextStyle(
                        color: textDarkGrey,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 35,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Text(
                      "$day",
                      style: const TextStyle(
                        color: textDarkGrey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 10,
            decoration: const BoxDecoration(
              color: primaryLightBlue,
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
