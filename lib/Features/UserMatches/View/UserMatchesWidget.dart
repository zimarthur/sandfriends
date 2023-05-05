import 'package:flutter/material.dart';
import 'package:sandfriends/Features/UserMatches/ViewModel/UserMatchesViewModel.dart';

class UserMatchesWidget extends StatefulWidget {
  UserMatchesViewModel viewModel;
  UserMatchesWidget({
    required this.viewModel,
  });

  @override
  State<UserMatchesWidget> createState() => _UserMatchesWidgetState();
}

class _UserMatchesWidgetState extends State<UserMatchesWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
