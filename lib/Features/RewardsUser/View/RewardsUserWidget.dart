import 'package:flutter/material.dart';

import '../ViewModel/RewardsUserViewModel.dart';

class RewardsUserWidget extends StatefulWidget {
  RewardsUserViewModel viewModel;
  RewardsUserWidget({
    required this.viewModel,
  });

  @override
  State<RewardsUserWidget> createState() => _RewardsUserWidgetState();
}

class _RewardsUserWidgetState extends State<RewardsUserWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
