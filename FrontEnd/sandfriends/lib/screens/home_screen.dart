import 'package:flutter/material.dart';
import 'package:sandfriends/screens/schedule_screen.dart';
import 'package:sandfriends/widgets/SF_NavBar.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'schedule_screen.dart';
import 'feed_screen.dart';
import 'user_screen.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({this.initialPage});
  final String? initialPage;
  @override
  State<HomeScreen> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<HomeScreen> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = [];
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();

    if (widget.initialPage == 'user_screen') {
      _selectedIndex = 0;
    } else if (widget.initialPage == 'schedule_screen') {
      _selectedIndex = 2;
    } else {
      _selectedIndex = 1;
    }

    _widgetOptions = <Widget>[
      UserScreen(),
      FeedScreen(),
      ScheduleScreen(),
    ];

    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _widgetOptions,
      ),
      bottomNavigationBar: SandFriendsNavBar(
        onItemSelected: _onItemTapped,
        selectedIndex: _selectedIndex,
        items: [
          SandFriendsNavBarItem(
            image: SvgPicture.asset(r"assets\icon\navigation\user_screen.svg"),
            imageActive: SvgPicture.asset(
                r"assets\icon\navigation\user_screen_selected.svg"),
            tabColor: AppTheme.colors.primaryBlue,
          ),
          SandFriendsNavBarItem(
            image: SvgPicture.asset(r"assets\icon\navigation\feed_screen.svg"),
            imageActive: SvgPicture.asset(
                r"assets\icon\navigation\feed_screen_selected.svg"),
            tabColor: AppTheme.colors.primaryBlue,
          ),
          SandFriendsNavBarItem(
            image:
                SvgPicture.asset(r"assets\icon\navigation\schedule_screen.svg"),
            imageActive: SvgPicture.asset(
                r"assets\icon\navigation\schedule_screen_selected.svg"),
            tabColor: AppTheme.colors.primaryBlue,
          ),
        ],
      ),
    );
  }
}
