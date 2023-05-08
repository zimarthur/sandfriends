import 'package:flutter/material.dart';

import '../ViewModel/OpenMatchesViewModel.dart';

class OpenMatchesWidget extends StatefulWidget {
  OpenMatchesViewModel viewModel;
  OpenMatchesWidget({
    required this.viewModel,
  });

  @override
  State<OpenMatchesWidget> createState() => _OpenMatchesWidgetState();
}

class _OpenMatchesWidgetState extends State<OpenMatchesWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
