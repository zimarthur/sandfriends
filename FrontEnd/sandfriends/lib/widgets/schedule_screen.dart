import 'package:flutter/material.dart';
import 'package:sandfriends/theme/app_theme.dart';

class ScheduleScreen extends StatefulWidget {
  static const routeName = '/schedule';

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with AutomaticKeepAliveClientMixin<ScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: AppTheme.colors.secondaryLightBlue,
      constraints: const BoxConstraints.expand(),
      child: ListView(
        children: const [
          Text("teste"),
          Text("teste"),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter a search term',
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
