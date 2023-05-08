import 'package:flutter/material.dart';
import 'package:sandfriends/SharedComponents/View/SportSelector.dart';

import '../../ViewModel/HomeViewModel.dart';

class SportSelectorWidget extends StatefulWidget {
  HomeViewModel viewModel;
  SportSelectorWidget({
    required this.viewModel,
  });

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