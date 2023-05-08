import 'package:flutter/material.dart';

import '../ViewModel/CourtViewModel.dart';

class CourtWidget extends StatefulWidget {
  CourtViewModel viewModel;
  CourtWidget({
    required this.viewModel,
  });

  @override
  State<CourtWidget> createState() => _CourtWidgetState();
}

class _CourtWidgetState extends State<CourtWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
