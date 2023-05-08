import 'package:flutter/material.dart';

import '../ViewModel/RecurrentMatchesViewModel.dart';

class RecurrentMatchesWidget extends StatefulWidget {
  RecurrentMatchesViewModel viewModel;
  RecurrentMatchesWidget({
    required this.viewModel,
  });

  @override
  State<RecurrentMatchesWidget> createState() => _RecurrentMatchesWidgetState();
}

class _RecurrentMatchesWidgetState extends State<RecurrentMatchesWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
