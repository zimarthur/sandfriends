import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/screens/sport_selection_screen.dart';
import 'package:sandfriends/widgets/SF_NavBar.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../providers/redirect_provider.dart';
import 'feed_screen.dart';
import 'user_screen.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({this.initialPage});
  final String? initialPage;
  @override
  State<HomeScreen> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<HomeScreen> {
  static List<Widget> _widgetOptions = [];

  bool isLoaded = false;
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (Provider.of<Redirect>(context, listen: false)
          .pageController
          .hasClients) {
        if (widget.initialPage == 'user_screen') {
          _onItemTapped(0);
        } else if (widget.initialPage == 'sport_selection_screen') {
          _onItemTapped(2);
        } else {
          _onItemTapped(1);
        }
      }
    });
    super.initState();

    _widgetOptions = <Widget>[
      UserScreen(),
      FeedScreen(),
      SportSelectionScreen(recurrentMatch: false),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      Provider.of<Redirect>(context, listen: false).selectedPageIndex = index;
      Provider.of<Redirect>(context, listen: false).goto(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: PageView(
          controller: Provider.of<Redirect>(context).pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: _widgetOptions,
        ),
        bottomNavigationBar: SandFriendsNavBar(
          onItemSelected: _onItemTapped,
          selectedIndex: Provider.of<Redirect>(context).selectedPageIndex!,
          items: [
            SandFriendsNavBarItem(
              image:
                  SvgPicture.asset(r"assets\icon\navigation\user_screen.svg"),
              imageActive: SvgPicture.asset(
                  r"assets\icon\navigation\user_screen_selected.svg"),
              tabColor: AppTheme.colors.primaryBlue,
            ),
            SandFriendsNavBarItem(
              image:
                  SvgPicture.asset(r"assets\icon\navigation\feed_screen.svg"),
              imageActive: SvgPicture.asset(
                  r"assets\icon\navigation\feed_screen_selected.svg"),
              tabColor: AppTheme.colors.primaryBlue,
            ),
            SandFriendsNavBarItem(
              image: SvgPicture.asset(
                  r"assets\icon\navigation\schedule_screen.svg"),
              imageActive: SvgPicture.asset(
                  r"assets\icon\navigation\schedule_screen_selected.svg"),
              tabColor: AppTheme.colors.primaryBlue,
            ),
          ],
        ),
      ),
    );
  }
}
