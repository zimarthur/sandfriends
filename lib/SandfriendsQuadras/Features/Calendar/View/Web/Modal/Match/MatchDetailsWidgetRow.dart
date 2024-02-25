import 'package:flutter/material.dart';

import '../../../../../../../Common/Utils/Constants.dart';

class MatchDetailsWidgetRow extends StatelessWidget {
  String title;
  String? value;
  Widget? customValue;
  bool fixedHeight;

  MatchDetailsWidgetRow({
    super.key,
    required this.title,
    this.value,
    this.customValue,
    this.fixedHeight = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: fixedHeight ? 50 : null,
      child: Row(
        crossAxisAlignment:
            fixedHeight ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              title,
              style: const TextStyle(color: textDarkGrey, fontSize: 14),
            ),
          ),
          Expanded(
            flex: 3,
            child: customValue ??
                Text(
                  value!,
                  style: const TextStyle(fontSize: 14),
                ),
          ),
        ],
      ),
    );
  }
}
