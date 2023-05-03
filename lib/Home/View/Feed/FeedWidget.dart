import 'package:flutter/material.dart';

import '../../ViewModel/HomeViewModel.dart';

class FeedWidget extends StatefulWidget {
  HomeViewModel viewModel;
  FeedWidget({
    required this.viewModel,
  });

  @override
  State<FeedWidget> createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
