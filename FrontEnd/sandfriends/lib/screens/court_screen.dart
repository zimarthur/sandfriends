import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/models/enums.dart';
import 'package:sandfriends/theme/app_theme.dart';
import 'package:sandfriends/widgets/SF_Scaffold.dart';
import 'package:photo_view/photo_view.dart';

import '../providers/match_provider.dart';

class CourtScreen extends StatefulWidget {
  const CourtScreen({Key? key}) : super(key: key);

  @override
  State<CourtScreen> createState() => _CourtScreenState();
}

class _CourtScreenState extends State<CourtScreen> {
  bool showModal = false;
  ScrollController _controller = ScrollController();

  final imageList = [
    r'assets\its\1.jpg',
    r'assets\its\2.jpg',
    r'assets\its\3.jpg',
    r'assets\its\3.jpg',
  ];

  void _onScrollEvent() {
    if (_controller.position.pixels.toInt() %
            (MediaQuery.of(context).size.width * 0.94).toInt() ==
        0) {
      Provider.of<MatchProvider>(context, listen: false).indexCurrentPhoto =
          (_controller.position.pixels ~/
                  (MediaQuery.of(context).size.width * 0.94))
              .round();
    }
  }

  @override
  void initState() {
    _controller.addListener(_onScrollEvent);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_onScrollEvent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SFScaffold(
      titleText: "Explorar quadras",
      goNamed: 'match_search_screen',
      appBarType: AppBarType.Primary,
      showModal: showModal,
      child: Container(
        width: width,
        color: AppTheme.colors.secondaryBack,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: width * 0.03),
          child: ListView(
            children: [
              Container(
                height: height * 0.2,
                width: width * 0.94,
                //padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                margin: EdgeInsets.symmetric(vertical: height * 0.01),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    ListView.builder(
                      controller: _controller,
                      scrollDirection: Axis.horizontal,
                      physics: PageScrollPhysics(),
                      itemCount: imageList.length,
                      itemBuilder: ((context, index) {
                        return Container(
                          width: width * 0.94,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Image.asset(
                              imageList[index],
                            ),
                          ),
                        );
                      }),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: height * 0.01),
                      child: Container(
                        height: width * 0.02,
                        width: width * 0.04 * imageList.length,
                        child: ListView.builder(
                          itemCount: imageList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: ((context, index) {
                            bool isIndex = Provider.of<MatchProvider>(context)
                                    .indexCurrentPhoto ==
                                index;
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: width * 0.01,
                              ),
                              child: ClipOval(
                                child: Container(
                                  color: isIndex
                                      ? AppTheme.colors.primaryBlue
                                      : AppTheme.colors.secondaryBack,
                                  height: width * 0.02,
                                  width: width * 0.02,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.15,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Image.network(
                        Provider.of<MatchProvider>(context, listen: false)
                            .selectedCourt!
                            .imageUrl,
                        height: height * 0.1,
                        width: height * 0.1,
                      ),
                    ),
                  ],
                ),
              ),
              Text(Provider.of<MatchProvider>(context, listen: false)
                  .selectedCourt!
                  .name),
            ],
          ),
        ),
      ),
    );
  }
}
