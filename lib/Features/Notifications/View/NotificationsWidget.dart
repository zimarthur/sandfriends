import 'package:flutter/material.dart';

import '../ViewModel/NotificationsViewModel.dart';

class NotificationsWidget extends StatefulWidget {
  NotificationsViewModel viewModel;
  NotificationsWidget({
    required this.viewModel,
  });

  @override
  State<NotificationsWidget> createState() => _NotificationsWidgetState();
}

class _NotificationsWidgetState extends State<NotificationsWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
