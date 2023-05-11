import 'package:flutter/material.dart';

import '../ViewModel/RewardsUserViewModel.dart';

class RewardsUserScreen extends StatefulWidget {
  const RewardsUserScreen({Key? key}) : super(key: key);

  @override
  State<RewardsUserScreen> createState() => _RewardsUserScreenState();
}

class _RewardsUserScreenState extends State<RewardsUserScreen> {
  final viewModel = RewardsUserViewModel();
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
