import 'package:flutter/material.dart';
import '../Enum/EnumPeriodVisualization.dart';
import 'SFToggle.dart';

class SFPeriodToggle extends StatefulWidget {
  EnumPeriodVisualization currentPeriodVisualization;
  Function(EnumPeriodVisualization) onChanged;
  String? customText;
  List<String>? labels;
  SFPeriodToggle({
    required this.currentPeriodVisualization,
    required this.onChanged,
    this.customText,
    this.labels,
  });

  @override
  State<SFPeriodToggle> createState() => _SFPeriodToggleState();
}

class _SFPeriodToggleState extends State<SFPeriodToggle> {
  @override
  Widget build(BuildContext context) {
    return SFToggle(
      widget.labels ??
          [
            EnumPeriodVisualization.Today.value,
            EnumPeriodVisualization.CurrentMonth.value,
            widget.currentPeriodVisualization == EnumPeriodVisualization.Custom
                ? widget.customText!
                : EnumPeriodVisualization.Custom.value,
          ],
      widget.currentPeriodVisualization.index,
      (newPeriod) => widget.onChanged(
        EnumPeriodVisualization.values.elementAt(
          newPeriod,
        ),
      ),
    );
  }
}
