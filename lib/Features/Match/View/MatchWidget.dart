import 'package:flutter/material.dart';

import '../ViewModel/MatchViewModel.dart';

class MatchWidget extends StatefulWidget {
  MatchViewModel viewModel;
  MatchWidget({
    required this.viewModel,
  });

  @override
  State<MatchWidget> createState() => _MatchWidgetState();
}

class _MatchWidgetState extends State<MatchWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
