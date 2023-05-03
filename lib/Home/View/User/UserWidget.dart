import 'package:flutter/material.dart';

import '../../ViewModel/HomeViewModel.dart';

class UserWidget extends StatefulWidget {
  HomeViewModel viewModel;
  UserWidget({
    required this.viewModel,
  });

  @override
  State<UserWidget> createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
