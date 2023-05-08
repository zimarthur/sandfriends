import 'package:flutter/material.dart';

import '../ViewModel/RewardsViewModel.dart';

class RewardsWidget extends StatefulWidget {
  RewardsViewModel viewModel;
  RewardsWidget({
    required this.viewModel,
  });

  @override
  State<RewardsWidget> createState() => _RewardsWidgetState();
}

class _RewardsWidgetState extends State<RewardsWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
