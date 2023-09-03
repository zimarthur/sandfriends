import 'package:flutter/material.dart';

import '../../../../SharedComponents/View/SportSelector.dart';
import '../../ViewModel/HomeViewModel.dart';

class SportSelectorWidget extends StatefulWidget {
  final HomeViewModel viewModel;
  const SportSelectorWidget({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  State<SportSelectorWidget> createState() => _SportSelectorWidgetState();
}

class _SportSelectorWidgetState extends State<SportSelectorWidget> {
  @override
  Widget build(BuildContext context) {
    return SportSelector(
      isRecurrentMatch: false,
      onSportSelected: (sport) => widget.viewModel.onSportSelected(
        context,
        sport,
      ),
    );
  }
}
