import 'package:flutter/material.dart';
import 'package:sandfriends/theme/app_theme.dart';

class FeedScreen extends StatelessWidget {
  static const routeName = '/feed';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.colors.secondaryYellow,
      constraints: const BoxConstraints.expand(),
      child: ListView(
        children: const [],
      ),
    );
  }
}
