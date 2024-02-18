enum EnumPeriodVisualization { Today, CurrentMonth, Custom }

extension EnumPeriodVisualizationString on EnumPeriodVisualization {
  String get value {
    switch (this) {
      case EnumPeriodVisualization.Today:
        return 'Hoje';
      case EnumPeriodVisualization.CurrentMonth:
        return 'Nesse mês';
      case EnumPeriodVisualization.Custom:
        return 'Personalizado';
    }
  }
}

List<EnumPeriodVisualization> periodVisualizationEnums = [
  EnumPeriodVisualization.Today,
  EnumPeriodVisualization.CurrentMonth,
  EnumPeriodVisualization.Custom
];
