import 'package:flutter/material.dart';
import 'package:sandfriends/UserDetails/ViewModel/UserDetailsViewModel.dart';

class UserDetailsWidget extends StatefulWidget {
  UserDetailsViewModel viewModel;
  UserDetailsWidget({
    required this.viewModel,
  });

  @override
  State<UserDetailsWidget> createState() => _UserDetailsWidgetState();
}

class _UserDetailsWidgetState extends State<UserDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
