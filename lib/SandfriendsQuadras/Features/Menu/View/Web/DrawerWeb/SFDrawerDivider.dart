import 'package:flutter/material.dart';
import '../../../../../../Common/Utils/Constants.dart';

class SFDrawerDivider extends StatelessWidget {
  const SFDrawerDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      width: double.infinity,
      color: divider,
      margin: const EdgeInsets.symmetric(vertical: defaultPadding),
    );
  }
}
