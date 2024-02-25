import 'package:flutter/material.dart';
import '../../../../../Common/Utils/Constants.dart';

class OccupationWidget extends StatelessWidget {
  String title;
  double result;

  OccupationWidget({
    super.key,
    required this.title,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (layoutContext, layoutConstraints) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: textDarkGrey, fontSize: 12),
                ),
              ),
              Text(
                "${(result * 100).toStringAsFixed(0)}%",
                style: const TextStyle(
                    color: textBlue, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(
            height: defaultPadding / 2,
          ),
          Stack(
            children: [
              Container(
                width: layoutConstraints.maxWidth,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    defaultBorderRadius,
                  ),
                  color: divider,
                ),
              ),
              Container(
                width: layoutConstraints.maxWidth * result,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    defaultBorderRadius,
                  ),
                  color: primaryBlue,
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}
